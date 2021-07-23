`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2019 12:16:57
// Design Name: 
// Module Name: clk_gen
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


module RefreshClk(
    input clk100M, 
    output reg refresh_clk
    );
    parameter Size = 64;
    reg [Size-1 : 0] count;
    reg [Size-1 : 0] step_reg;
    reg clk_stb;
    initial begin
        refresh_clk = 0;
        count = 0;
        step_reg = 'h1421F5F40D837;
        clk_stb = 0;
    end
    
    always @(posedge clk100M) begin
        {clk_stb, count} <= count + step_reg;
        
        if (clk_stb) begin
            refresh_clk <= !refresh_clk;
            clk_stb <= 0;
        end
    end     
endmodule
