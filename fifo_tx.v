module fifo_tx(clk_fifo_tx, data_in, next_frame, data_out);

       input[7:0] data_in;
       input clk_fifo_tx;
       input next_frame;
       //output fifo_tx_status;
       output reg[7:0] data_out;
       
       reg[15:0] fifo_tx_mem[7:0];
       reg[3:0] wr_pt = 4'b0000;
       reg[3:0] rd_pt = 4'b0000;
       reg wr_en;
       reg rd_en;
       reg fifo_tx_full;
       reg fifo_tx_empty;

       always@(posedge clk_fifo_tx)
         begin
           if((wr_en==1'b1)&&(fifo_tx_full==1'b0))
              begin
                if(wr_pt==4'b1111)
                  begin
                     fifo_tx_mem[wr_pt] <= data_in;
                     //wr_en <= 1'b0;//fifo full
                     fifo_tx_full <= 1'b1;
                  end
                else
                  begin
                    fifo_tx_mem[wr_pt] <= data_in;
                    wr_pt <= wr_pt+1;
                  end
              end
           else
              fifo_tx_full <= 1'b1;
              
         end 
         
         always@(posedge clk_fifo_tx)
           begin
             if((fifo_tx_full==1'b1)&&(next_frame==1'b1))
               begin
                 if((rd_en==1'b1)&&(fifo_tx_empty==1'b0))
                   begin
                     if(rd_pt==4'b1111)
                       begin
                         data_out <= fifo_tx[rd_pt]
                         //rd_en <= 1'b0;
                         fifo_tx_empty <= 1'b1;
                       end
                     else
                       begin
                         data_out <= fifo_tx_mem[rd_Pt];
                         rd_pt <= rd_pt+1;
                       end
                   end
                 else
                    fifo_tx_empty <= 1'b1;
               end
           end   

endmodule  
                  
                  
                  
                   
                   
                   
            
