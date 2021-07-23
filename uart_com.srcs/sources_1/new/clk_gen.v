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


module clk_gen(
    input clk100M, rst, load, [63:0] baud, 
    output reg clk_baud
    );
    parameter Size = 64;
    parameter Reset = 1'b0;
    parameter Running = 1'b1;
    reg state;
    reg [Size-1 : 0] count;
    reg [Size-1 : 0] baud_reg;
    reg clk_stb;
    initial begin
        state = Reset;
        clk_baud = 0;
        count = 0;
        baud_reg = 'hC9539B8887229E;
        clk_stb = 0;
    end
    
    always @(posedge clk100M) begin
        if (state == Reset) begin
            count <= 0;
            clk_stb <= 0;
        end 
        else if (state == Running) begin
            {clk_stb, count} <= count + baud_reg;
        
            if (clk_stb) begin
                clk_baud <= !clk_baud;
                clk_stb <= 0;
            end
        end 
    end
    
    always @(posedge clk100M) begin
        if (rst)
            state <= Reset;
            if(load) begin
                case (baud)
                    9600: baud_reg <= 'hC9539B8887229E;
                    19200: baud_reg <= 'h192A737110E453D;         
                    38400: baud_reg <= 'h3254E6E221C8A7A;
                    128000: baud_reg <= 'hA7C5AC471B47842;
                    256000: baud_reg <= 'h14F8B588E368F084;
                    512000: baud_reg <= 'h29F16B11C6D1E109;
                    1024000: baud_reg <= 'h53E2D6238DA3C212;
                    default: baud_reg <= 'hC9539B8887229E;
                endcase
            end   
        else if (!rst) begin
            state <= Running;
        end
        else
            state <= Reset;
    end
        
endmodule


