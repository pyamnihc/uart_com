`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2019 13:14:55
// Design Name: 
// Module Name: uart_tx
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

module uart_tx (
    input clk_baud, send, rst, [7:0] tx_byte, 
    output reg tx_active, reg tx_done, reg serial_tx      
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
    reg [7:0] tx_data;
    
    initial begin
        state = Idle;
        idx = 0;
        bit_clk_idx = 0;
        bit_clk_stb = 0;
        tx_data = 0;
    end   
    always @(posedge clk_baud) begin
        if (rst) begin
            state  <= Idle;
        end
        else if (!rst) begin
            case (state)
                Idle: begin
                    serial_tx <= 1;
                    tx_done <= 0;
                    idx <= 0;
                    bit_clk_idx <= 0;
                    bit_clk_stb <= 0;
                                 
                    if (send == 1) begin
                        tx_active <= 1;
                        tx_data <= tx_byte;
                        state <= StartBit;
                    end
                    else
                        state <= Idle;
                end
                
                StartBit: begin
                    serial_tx <= 0;
                    if (!bit_clk_stb) begin
                        {bit_clk_stb, bit_clk_idx} <= bit_clk_idx + 1;
                        state <= StartBit;
                    end
                    else begin
                        bit_clk_idx <= 0;
                        bit_clk_stb <= 0;
                        state <= DataBits;
                    end
                end
                
                DataBits: begin
                    serial_tx <= tx_data[idx];
                    if (!bit_clk_stb) begin
                        {bit_clk_stb, bit_clk_idx} <= bit_clk_idx + 1;
                        state <= DataBits;
                    end
                    else begin
                        bit_clk_idx <= 0;
                        bit_clk_stb <= 0;
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
                    serial_tx <= 1;
                    if (!bit_clk_stb) begin
                        {bit_clk_stb, bit_clk_idx} <= bit_clk_idx + 1;
                        state <= StopBit;
                    end
                    else begin
                        tx_done <= 1;
                        bit_clk_idx <= 0;
                        bit_clk_stb <= 0;
                        state <= Clean;
                        tx_active <= 0;
                    end
                end
                
                Clean: begin
                    tx_done <= 1;
                    state <= Idle;
                end
                
                default: 
                    state <= Idle;
                    
            endcase
        end
        else
            state <= Idle;
    end
endmodule