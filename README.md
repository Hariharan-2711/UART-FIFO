# UART-FIFO

Behavioural design of UART with a FIFO buffer in verilog

This project aims at the behavioural design of a Universal Asynchronous Receiver and Transmitter

The UART protocol has a frame configured in the following way: 1 start bit, 8 data bits, 1 stop bit, 0 parity bits

The project has 5 modules namely:
   
1. Transmitter.v - 
     This module implements the function of the transmitter. It has FSM consisting of 6 states.

2. Receiver.v - 
     This module implements the function of the receiver. It has FSM consisting of 5 states.
        
3. fifo_tx.v - 
     This module implements the FIFO buffer. 
     The FIFO buffer output is connected to the input buffer of the transmitter.
        
4. uart.v - 
     This module is the main module that receives inputs from the testbench file and provides an interconnect between the fifo_tx, transmitter and receiver modules.

5. uart_testbench.v - 
     This is the test bench file. The inputs from the test bench file are passed to the uart.v module
   
