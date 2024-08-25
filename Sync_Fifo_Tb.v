`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2024 19:42:42
// Design Name: 
// Module Name: Sync_Fifo_Tb
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


module Sync_Fifo_Tb;
  // Parameters
    parameter FIFO_DEPTH = 8;
    parameter FIFO_WIDTH = 8;
    // Testbench signals
    reg clk;
    reg rst_n;
    reg w_en;
    reg r_en;
    reg [FIFO_WIDTH-1:0] data_in;
    wire [FIFO_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Instantiate the FIFO module
    Synchronous_FIFO #(FIFO_DEPTH, FIFO_WIDTH) uut (
        .clk(clk),
        .rst_n(rst_n),
        .w_en(w_en),
        .r_en(r_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 time units clock period
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst_n = 0;
        w_en = 0;
        r_en = 0;
        data_in = 0;
        // Reset the FIFO
        #10;
        rst_n = 1;
        // Test writing to FIFO
        $display("Writing to FIFO...");
        repeat (FIFO_DEPTH) begin
            @(posedge clk);
            w_en = 1;
            data_in = data_in + 1;
        end
        w_en = 0;

        // Check if FIFO is full
        if (full)
            $display("FIFO is full as expected.");

        // Test reading from FIFO
        $display("Reading from FIFO...");
        repeat (FIFO_DEPTH) begin
            @(posedge clk);
            r_en = 1;
        end
        r_en = 0;

        // Check if FIFO is empty
        if (empty)
            $display("FIFO is empty as expected.");

        // Test writing and reading simultaneously
        $display("Writing and reading simultaneously...");
        repeat (FIFO_DEPTH) begin
            @(posedge clk);
            w_en = 1;
            r_en = 1;
            data_in = data_in + 1;
        end
        w_en = 0;
        r_en = 0;

        #20;
        $stop; // End simulation
    end
endmodule
