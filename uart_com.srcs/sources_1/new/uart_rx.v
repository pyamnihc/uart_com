`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2019 16:20:29
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input clk_baud, serial_rx, rst,
    output reg rx_done, reg [7:0] rx_byte
    );
    
    parameter Idle = 3'b000;
    parameter StartBit = 3'b001;
    parameter DataBits = 3'b010;
    parameter StopBit = 3'b011;
    parameter Clean = 3'b100;
    
    reg [2:0] state;
    reg [2:0] idx;
    reg [3:0] bit_clk_idx;
    reg bit_clk_stb;
    reg buf_rx;
    reg r_serial_rx;
    
    initial begin
        state <= Idle;
        idx = 0;
        bit_clk_idx = 0;
        bit_clk_stb = 0;
    end
    
    always @(posedge clk_baud) begin
        buf_rx <= serial_rx;
        r_serial_rx <= buf_rx;
    end
    
    always @(posedge clk_baud) begin
        if (rst) begin
            state <= Idle;
        end
        else if (!rst) begin
            case (state) 
                Idle: begin
                    rx_done <= 0;
                    idx <= 0;
                    bit_clk_idx <= 0;
                    bit_clk_stb <= 0;
                   if (!r_serial_rx)
                        state <= StartBit;
                    else
                        state <= Idle;
                end
                
                StartBit: begin
                    if (!bit_clk_idx[3]) begin
                        bit_clk_idx <= bit_clk_idx + 1;
                        state <= StartBit;
                    end
                    else if (!r_serial_rx) begin
                        bit_clk_idx <= 0;
                        bit_clk_stb <= 0;
                        state <= DataBits;
                    end
                    else begin
                        state <= Idle;
                    end
                end
                
                DataBits: begin
                    if (!bit_clk_stb) begin
                        {bit_clk_stb, bit_clk_idx} <= bit_clk_idx + 1;
                        state <= DataBits;
                    end
                    else begin
                        bit_clk_idx <= 0;
                        bit_clk_stb <= 0;
                        rx_byte[idx] <= r_serial_rx;
                        if (idx < 7) begin
                            idx <= idx + 1;
                            state <= DataBits;
                        end
                        else begin
                            idx <= 0;
                            state <= StopBit;
                        end
                    end
                end
                
                StopBit: begin
                    if (!bit_clk_stb) begin
                        {bit_clk_stb, bit_clk_idx} <= bit_clk_idx + 1;
                        state <= StopBit;
                    end
                    else begin
                        bit_clk_idx <= 0;
                        bit_clk_stb <= 0;
                        rx_done <= 1;
                        state <= Clean;
                    end
                end
                
                Clean: begin
                    state <= Idle;
                    rx_done <= 0;
                end
                
                default: 
                    state <= Idle;
            endcase
        end
        else
            state <= Idle;
    end 
endmodule
