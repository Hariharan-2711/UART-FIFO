module uart(pc_in_t, clk_t_in, clk_r_in, ok);

     input[7:0] pc_in_t;
     //input txrdy_in;
     input clk_t_in;
     input clk_r_in;
     wire[7:0] data;
     output ok;
     wire status;
     wire dma_txend_in;
     wire tx_in;
     
     fifo_tx ft(.clk_fifo_tx(clk_t_in), .data_in(pc_in_t), .next_frame(dma_txend_in), .data_out(data), .fifo_tx_status(status));
     transmitter t(.pc_t(data), .clk(clk_t_in), .dma_txend(dma_txend_in), .tx(tx_in), .fifo_status(status));
     receiver r(.rx(tx_in), clk_r(clk_r_in), .dma_rxend());
