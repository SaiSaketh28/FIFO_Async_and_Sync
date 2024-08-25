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
   reg w_clk, w_rst, rd_clk, rd_rst;
   reg w_en, rd_en;
   reg [WIDTH-1:0] data_in;
   wire [WIDTH-1:0] data_out;
   wire full, empty;
   Asynchronous_FIFO #(DEPTH, WIDTH) uut (
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
   initial begin
       w_clk = 0;
       rd_clk = 0;
       forever begin
           #5 w_clk = ~w_clk; // Write clock with period of 10 ns
           #7 rd_clk = ~rd_clk; // Read clock with period of 14 ns
       end
   end
   
   initial begin
       // Initialize signals
       w_rst = 0;
       rd_rst = 0;
       w_en = 0;
       rd_en = 0;
       data_in = 0;
       
       // Reset the FIFO
       #10 w_rst = 1;
       rd_rst = 1;
       
       #10 w_rst = 0;
       rd_rst = 0;
       
       #10 w_rst = 1;
       rd_rst = 1;
       
       // Begin writing to FIFO
       #10;
       write_to_fifo(8'hA1); // Write A1
       write_to_fifo(8'hB2); // Write B2
       write_to_fifo(8'hC3); // Write C3
       write_to_fifo(8'hD4); // Write D4
       write_to_fifo(8'hE5); // Write E5
       write_to_fifo(8'hF6); // Write F6
       write_to_fifo(8'h07); // Write 07
       write_to_fifo(8'h18); // Write 18
       
       // Attempt to write when full
       write_to_fifo(8'h99); // This should not be written

       // Read from FIFO
       #50;
       read_from_fifo(); // Expect A1
       read_from_fifo(); // Expect B2
       read_from_fifo(); // Expect C3
       read_from_fifo(); // Expect D4
       read_from_fifo(); // Expect E5
       read_from_fifo(); // Expect F6
       read_from_fifo(); // Expect 07
       read_from_fifo(); // Expect 18
       
       // Attempt to read when empty
       read_from_fifo(); // This should not read anything
       
       #100;
       $stop; // End the simulation
   end
   
   // Task to write data to FIFO
   task write_to_fifo(input [WIDTH-1:0] data);
   begin
       if (!full) begin
           data_in = data;
           w_en = 1;
           @(posedge w_clk);
           w_en = 0;
       end else begin
           $display("FIFO is full. Cannot write data: %h", data);
       end
   end
   endtask
   
   // Task to read data from FIFO
   task read_from_fifo;
   begin
       if (!empty) begin
           rd_en = 1;
           @(posedge rd_clk);
           $display("Data read from FIFO: %h", data_out);
           rd_en = 0;
       end else begin
           $display("FIFO is empty. Cannot read data.");
       end
   end
   endtask
endmodule
