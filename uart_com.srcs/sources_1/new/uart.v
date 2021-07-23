`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2019 17:34:15
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart(
    input clk100M, serial_rx, send, load, rst, [7:0] tx_byte, [63:0] baud,
    output tx_active, tx_done, serial_tx, rx_done, [7:0] rx_byte 
    );
    wire clk_baud;
    clk_gen c1 (.clk100M(clk100M), .rst(rst), .load(load), .baud(baud), .clk_baud(clk_baud));
    uart_tx utx (.clk_baud(clk_baud), .send(send), .rst(rst), .tx_byte(tx_byte), .tx_active(tx_active), .tx_done(tx_done), .serial_tx(serial_tx));
    uart_rx urx (.clk_baud(clk_baud), .serial_rx(serial_rx), .rst(rst), .rx_done(rx_done), .rx_byte(rx_byte));    
    
endmodule
