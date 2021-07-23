`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2018 17:42:17
// Design Name: 
// Module Name: en_gen
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

module DispMan(
    input clk100M, [3:0] dp, [7:0][3:0] data,
    output reg DP, reg [7:0] AN, [6:0] SSD
    );
    wire refresh_clk;
    RefreshClk r_clk (.clk100M(clk100M), .refresh_clk(refresh_clk));
    reg [3:0] idx;  
    initial begin
        AN = 8'b11111110;
        idx = 0;
    end
    
    hex2ssd h2s (.hex(data[idx]), .SSD(SSD));
    
    always @(posedge refresh_clk) begin
        idx <= idx + 1;
        DP <= dp[idx];    
        AN <= {AN[6:0], AN[7]};
    end
    
endmodule
