`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2019 18:12:38
// Design Name: 
// Module Name: uart_test
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


module uart_test();
reg clk;
reg serial_rx, send, load, rst;
reg [7:0] tx_byte;
reg [63:0] baud;
wire tx_active, tx_done, serial_tx, rx_done;
wire [7:0] rx_byte;
reg init_bit;
reg stb;
reg [7:0] count;
reg [7:0] rx_data;

initial begin
    clk = 0;
    serial_rx = 0;
    send = 0;
    load = 0;
    rst = 0;
    tx_byte = 49;
    baud = 0;
    init_bit = 0;
    stb = 0;
    count = 0;
    rx_data = 0;
    forever begin
        #0.5 clk <= !clk;
    end
end

uart u1 (.clk100M(clk), .serial_rx(serial_rx), .send(send), .load(load), .tx_byte(tx_byte), .baud(baud), .rst(rst),
            .tx_active(tx_active), .tx_done(tx_done), .serial_tx(serial_tx), .rx_done(rx_done), .rx_byte(rx_byte));
            
always @(posedge clk) begin
    if (!init_bit) begin
        init_bit <= 1;
        rst <= 1;
        load <= 1;
        baud = 9600;
    end
    else if (!stb) begin
        rst <= 0;
        load <= 0;
        send <= 1;
    end
    else begin
        send <= 0;
        rst <= 0;
    end
    serial_rx <= serial_tx;
end

always @(posedge tx_done) begin
    if (!stb) begin
        {stb, count} <= count + 1;
        tx_byte <= tx_byte + 1;
    end
end

always @(posedge rx_done) begin
    rx_data <= rx_byte;
end
     
endmodule
