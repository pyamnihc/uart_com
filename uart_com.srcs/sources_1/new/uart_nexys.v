`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2019 19:03:15
// Design Name: 
// Module Name: uart_nexys
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


module uart_nexys(
    input CLK100MHZ, UART_TXD_IN,
    output wire UART_RXD_OUT, DP, [7:0] AN, [6:0] SSD
    );
    wire clk;
    assign clk = CLK100MHZ;
    wire serial_rx;
    reg send, load, rst;
    reg [7:0] tx_byte;
    reg [63:0] baud;
    wire tx_active, tx_done, serial_tx, rx_done;
    wire [7:0] rx_byte;
    reg init_bit;
    reg stb;
    reg [15:0] count;
    reg [7:0] rx_data;
    reg [3:0] dp;
    wire [31:0] disp_data;
    
    assign UART_RXD_OUT = serial_tx;
    assign serial_rx = UART_TXD_IN;
    initial begin
        send = 0;
        load = 0;
        rst = 0;
        tx_byte = 0;
        baud = 0;
        init_bit = 0;
        stb = 0;
        count = 0;
        rx_data = 0;
        dp = -1;
    end
    genvar i;
    generate for (i = 0; i < 8; i = i + 1) begin
        assign disp_data[i << 2] = rx_data[i];
    end
    endgenerate
    
    uart u1 (.clk100M(clk), .serial_rx(serial_rx), .send(send), .load(load), .tx_byte(tx_byte), .baud(baud), .rst(rst),
                .tx_active(tx_active), .tx_done(tx_done), .serial_tx(serial_tx), .rx_done(rx_done), .rx_byte(rx_byte));
    
    DispMan d1 (.clk100M(clk), .dp(dp), .data(disp_data), .DP(DP), .AN(AN), .SSD(SSD));           
                
    always @(posedge clk) begin
        if (!init_bit) begin
            init_bit <= 1;
            rst <= 1;
            load <= 1;
            baud = 9600;
        end
        else begin
            rst <= 0;
            load <= 0;
        end
    end
    
    always @(posedge tx_done or posedge rx_done) begin
        if (tx_done) begin
            send <= 0;
        end
        else if (rx_done) begin
            rx_data <= rx_byte;
            tx_byte <= rx_byte;
            send <= 1;
        end
    end
endmodule
