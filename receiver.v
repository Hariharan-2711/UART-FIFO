module receiver(dma_rxend,clk_r,rx);

    //input[7:0] pc_r;
    input rx;
    input clk_r;
    output reg dma_rxend;
    
    reg[7:0] rhr;
    reg[7:0] mem_r[0:1023];
    reg rxrdy = 1'b0;
    reg[9:0] pc_r_index = 10'd0;

    parameter rx_idle = 3'b000;
    parameter rx_start = 3'b001;
    parameter rx_data = 3'b010;
    parameter rx_stop = 3'b011;
    parameter rx_transfer = 3'b100;
    
    // 10000000/9600 = 1041.66 ~= 1042
    // 10000000/115200 = 86.80 ~= 87
    // 100000000/115200 = 868.05 ~= 868
    // 100000000/9600 = 10416.66 ~= 10417
    
    integer clk_cnt;
    reg[2:0] mode_r;
    reg[9:0] rsr;
    integer index_r;
    wire bit;
   
    assign bit = rx;
         
    
    always@(posedge clk_r)
      begin
         
         case(mode_r)
                  
             rx_idle: begin
                         if(bit==1'b0)
                           begin
                              mode_r <= rx_start;
                              index_r <= 0;
                              clk_cnt <= 0;
                              dma_rxend <= 1;
                              rxrdy <= 0;
                           end
                         else
                           mode_r <= rx_idle;
                       end
      
             rx_start: begin
                         if(clk_cnt==(868/2))
                           begin
                              if(bit==1'b0)
                                begin
                                   rsr[index_r] <= bit;
                                   mode_r <= rx_data;
                                   clk_cnt <= 0;
                                   index_r <= index_r+1;
                                   dma_rxend <= 1'b0;
                                end
                              else
                                mode_r <= rx_idle;
                           end
                         else
                           begin
                             clk_cnt <= clk_cnt+1;
                             mode_r <= rx_start;
                           end
                       end

              rx_data: begin
                         if(clk_cnt<=867)
                           begin
                              clk_cnt <= clk_cnt+1;
                              mode_r <= rx_data;
                           end
                          else
                            begin
                               rsr[index_r] <= bit;
                               clk_cnt <= 0;
                               if(index_r < 8)
                                 begin
                                   index_r <= index_r+1;
                                   mode_r <= rx_data;
                                 end
                               else
                                 begin
                                   clk_cnt <= 0;
                                   mode_r <= rx_stop;
                                   index_r <= 9;
                                 end 
                             end  
                        end

               rx_stop: begin
                          if(clk_cnt==868)
                            begin
                               if(bit==1'b1)
                                 begin
                                   rsr[index_r] <= bit;
                                   rhr <= rsr[8:1];
                                   rxrdy <= 1;
                                   dma_rxend <= 1;
                                   clk_cnt <= 0;
                                   mode_r <= rx_transfer;
                                 end
                               else
                                 begin
                                   $display("Data reception failed !!");
                                 end
                             end
                           else
                             begin
                               clk_cnt <= clk_cnt+1;
                               mode_r <= rx_stop;  
                             end
                        end

              rx_transfer: begin
                              if(rxrdy==1'b1)
                              begin
                                mem_r[pc_r_index] <= rhr;
                                pc_r_index <= pc_r_index+1;
                                mode_r <= rx_idle;
                                rxrdy <= 1'b0;
                              end
                           end
                             
              
               default: begin
                          mode_r <= rx_idle;
                          clk_cnt <= 0;
                          index_r = 0;
                          dma_rxend <= 0;
                        end     
                                 
         endcase
      end    

endmodule
