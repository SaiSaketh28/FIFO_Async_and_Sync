`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2024 19:05:41
// Design Name: 
// Module Name: Synchronous_FIFO
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


module Synchronous_FIFO #(parameter FIFO_DEPTH=8,parameter FIFO_WIDTH=8)(
    input clk,
    input rst_n,
    input w_en,r_en,
    input [FIFO_WIDTH-1:0] data_in,
    output reg [FIFO_WIDTH-1:0] data_out,
    output full,empty);
    
    reg [$clog2(FIFO_DEPTH)-1:0] w_ptr,r_ptr;
    reg [FIFO_WIDTH-1:0] fifo[FIFO_DEPTH-1:0];
    
    // Initialising default values
    always @(posedge clk) begin
        if(!rst_n) begin
            w_ptr <= 0;
            r_ptr <= 0;
            data_out <= 0;
        end
    end
    // Writing data into FIFO
    always @(posedge clk) begin
        if(w_en&&!full) begin
            fifo[w_ptr] <= data_in;
            w_ptr <= w_ptr +1;
        end
    end
    // Reading data
    always @(posedge clk) begin
        if(r_en&&!empty) begin
        data_out <= fifo[r_ptr];
        r_ptr <= r_ptr +1;
        end
    end
    // Assigning full and empty
    assign full = ((w_ptr + 1'b1) == r_ptr);
    assign empty = (w_ptr == r_ptr);
endmodule
