module uart_test;
    
    reg[7:0] pc_t_in;
    //reg[7:0] pc_r_in;
    //reg txr_in;
    reg clk_t;
    reg clk_r;
    wire ok;
    integer i,j;

    uart u(.pc_in_t(pc_t_in),.clk_t_in(clk_t),.clk_r_in(clk_r),.done(ok));
    
    initial
      begin
        txr_in = 0;
        clk_t = 0;
        clk_r = 0;
        nf = 1;
        u.ft.wr_en = 0;
        u.ft.rd_en = 0;
        u.ft.fifo_tx_status = 0;
        u.ft.fifo_tx_empty = 1;
        u.ft.fifo_tx_full = 0;
      end
 
    initial
      begin
        for(i=0;i<1024;i=i+1)
          begin
            //u.t.mem_t[i] = i;
            u.r.mem_r[i] = 0;
          end
      end
      
    initial
      begin
        for(j=0;j<16;j=j+1)
          begin
            #3 pc_t_in = j;
          end
      end
      
    always
        #5 clk_t = ~clk_t;
        
    always
        #5 clk_r = ~clk_r;
        
    initial
      begin
        #1 u.ft.wr_en = 1;
           u.ft.rd_en = 1;
      end    
          
    /*initial
      begin
         #5      pc_t_in = 8'd119;
         #5      txr_in = 1'b1;
         #5      pc_r_in = 8'd119; 
         #5      txr_in = 1'b0;                    
         #86895  pc_t_in = 8'd219;
         #5      txr_in = 1'b1;
         #5      pc_r_in = 8'd219; 
         #86905  $finish;
         
      end*/
     
        
        
endmodule
