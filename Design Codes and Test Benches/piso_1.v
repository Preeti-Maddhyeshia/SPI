`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2024 13:50:18
// Design Name: 
// Module Name: piso_1
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


module piso_1 (
    input [8:0] sw,
    input clk,
    input reset_n,
    output reg out
);
    reg [8:0] in_reg;
    reg i_sclk;
    reg [3:0] count;
    reg load; // Added a load signal to control when to load the input register

    // Load input register on reset or when load is high

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            in_reg <= 9'b1;
        end else if (load) begin
            in_reg <= sw;
        end
    end

    // i_sclk generation with a simple toggle every 8 clock cycles

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 4'b0;
            i_sclk <= 1'b0;
        end else if (count == 4'b1000) begin
            i_sclk <= ~i_sclk;
            count <= 4'b0;
        end else begin
            count <= count + 1'b1;
        end
    end

    // Shifting out the data and updating in_reg on the positive edge of i_sclk

    always @(posedge i_sclk or negedge reset_n) begin
        if (!reset_n) begin
            out <= 1'b1;
        end else begin
            out <= in_reg[0];
            in_reg <= in_reg >> 1;
        end
    end

    // Control logic for load signal

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            load <= 1'b1; // Load on reset
        end else begin
            load <= 1'b0; // Disable load after the first clock cycle
        end
    end
endmodule






