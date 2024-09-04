`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2024 16:05:18
// Design Name: 
// Module Name: Asynchronous_FIFO_tb
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


module Asynchronous_FIFO_tb;
    parameter DEPTH = 8;
    parameter WIDTH = 8;
    parameter PTR_WIDTH = $clog2(DEPTH);
    reg w_clk, w_rst, rd_clk, rd_rst;
    reg w_en, rd_en;
    reg [WIDTH-1:0] data_in;
    wire [WIDTH-1:0] data_out;
    wire full, empty;
    Asynchronous_FIFO #(DEPTH, WIDTH) dut (
        .w_clk(w_clk),
        .w_rst(w_rst),
        .rd_clk(rd_clk),
        .rd_rst(rd_rst),
        .w_en(w_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 w_clk = ~w_clk;  
    always #7 rd_clk = ~rd_clk; 

    initial begin
        w_clk = 0;
        rd_clk = 0;
        w_rst = 0;
        rd_rst = 0;
        w_en = 0;
        rd_en = 0;
        data_in = 0;

        #10 w_rst = 1;
        rd_rst = 1;
        #10 w_rst = 0;
        rd_rst = 0;
        #10 w_rst = 1;
        rd_rst = 1;
        w_en = 1;
        rd_en = 1;
        data_in = 8'b00000001;
        #10 data_in = 8'b00000010;
        #10 data_in = 8'b00000011;
        #10 data_in = 8'b00000100;
        #10 data_in = 8'b00000101;
        #10 data_in = 8'b00000110;
        #10 data_in = 8'b00000111;
        #10 data_in = 8'b00001000;
        #10 data_in = 8'b00001001;
         #100 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | w_clk: %b | w_rst: %b | w_en: %b | data_in: %h | full: %b | rd_clk: %b | rd_rst: %b | rd_en: %b | data_out: %h | empty: %b",
                 $time, w_clk, w_rst, w_en, data_in, full, rd_clk, rd_rst, rd_en, data_out, empty);
    end
endmodule
