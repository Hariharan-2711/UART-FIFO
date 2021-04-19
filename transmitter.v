module transmitter(pc_t,tx,dma_txend,clk,fifo_status);

    input[7:0] pc_t;
    //input txrdy;
    input clk;
    input fifo_status;
    output reg tx;
    output reg dma_txend;

    reg[7:0] mem_t[0:1023];
    reg txrdy;
   
    parameter tx_idle = 2'b00;
    parameter tx_start = 2'b01;
    parameter tx_data = 2'b10;
    parameter tx_stop = 2'b11;
    
    integer index;
    reg[1:0] mode = 2'b00;
    integer clk_count;
    
    // 10000000/9600 = 1041.66 ~= 1042
    // 10000000/115200 = 86.80 ~= 87
    // 100000000/115200 = 868.05 ~= 868
    // 100000000/9600 = 10416.66 ~= 10417

    reg[7:0] thr;
    reg[9:0] tsr;
    
    always@(posedge clk)
      begin
       if(fifo_status==1'b1)
        begin
         
         thr <= pc_t;

         case(mode)

             tx_idle: begin
                         tx <= 1;
                         txrdy <= 1;
                         clk_count <= 0;
                         dma_txend <= 1;
                         index = 0;
                         
                          
                         if(txrdy==1)
                           begin
                              tsr <= {{1'b1},{thr[7:0]},{1'b0}};
                              mode <= tx_start;
                           end
                         else
                           begin
                              mode <= tx_idle;
                           end
                       end
             
             tx_start: begin
                          txrdy <= 0;
                          tx <= tsr[index]; 
                          if(clk_count <= 867)
                            begin
                              clk_count <= clk_count+1;
                              mode <= tx_start;
                              dma_txend <= 1'b0;
                            end
                          else
                            begin
                              clk_count <= 0;
                              index <= index+1;
                              mode <= tx_data;
                            end
                       end

             tx_data: begin
                          tx <= tsr[index];
                          if(clk_count <= 867)
                            begin
                               clk_count <= clk_count+1;
                               mode <= tx_data;
                            end
                          else
                            begin
                               clk_count <= 0;
                               if(index<8)
                                 begin
                                   index <= index+1;
                                   mode <= tx_data;
                                 end
                               else
                                 begin
                                   mode <= tx_stop;
                                   index <= 9;
                                 end
                            end
                      end

             tx_stop: begin
                          tx <= tsr[index];
                          if(clk_count <= 867)
                            begin
                               clk_count <= clk_count+1;
                               mode <= tx_stop;
                            end
                           else
                            begin
                               clk_count <= 0;
                               dma_txend <= 1;
                               mode <= tx_idle;
                            end
                      end
             default: begin
                          clk_count <= 0;
                          dma_txend <= 0;
                          mode <= tx_idle;
                          index <= 0;
                      end
         
         endcase
       end
      end 

endmodule 
