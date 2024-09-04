`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2024 10:03:03
// Design Name: 
// Module Name: Asynchronous_FIFO
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

module synchrnoizer #(parameter Data_Width=8)(
    input [Data_Width:0] data_in,
    input clk,rst,
    output reg [Data_Width:0] data_out
);
    reg [Data_Width:0] q_1;
    always @(posedge clk) begin
        if(!rst) begin
            q_1 <= 0;
            data_out <= 0;
        end
        else begin
            q_1 <= data_in;
            data_out <= q_1;
        end
    end
endmodule

module FIFO_Wr_ptr_handler #(parameter ptr_width = 3)(
    input w_en,w_clk,w_rst,
    input [ptr_width:0] g_rptr_sync,
    output reg full,
    output reg [ptr_width:0] bin_ptr,
    output reg [ptr_width:0] gra_ptr
    );
    reg [ptr_width:0] bin_ptr_next;
    reg [ptr_width:0] gra_ptr_next;
    reg wrap_around;
    wire wfull;
    always @(*) begin
        bin_ptr_next = bin_ptr + (w_en&!full);
        gra_ptr_next = (bin_ptr_next >>1)^bin_ptr_next;
    end
    always @(posedge w_clk or negedge w_rst) begin
        if(!w_rst) begin
            bin_ptr <= 0;
            gra_ptr <= 0;
        end
        else begin
            bin_ptr <= bin_ptr_next;
            gra_ptr <= gra_ptr_next;
        end
    end
    always @(posedge w_clk or negedge w_rst) begin
            if(!w_rst) begin
                full <= 0;
            end
            else begin
                full <= wfull;
            end
        end
    assign wfull = (gra_ptr_next == {~g_rptr_sync[ptr_width:ptr_width-1],g_rptr_sync[ptr_width-2:0]});
endmodule

module FIFO_Rd_handle #(parameter ptr_width = 3)(
    input rd_clk,rd_rst,rd_en,
    input [ptr_width:0] gra_wptr_sync,
    output reg [ptr_width:0] bin_rptr,gra_rptr,
    output reg empty
    );
    reg [ptr_width:0] bin_rptr_next;
    reg [ptr_width:0] gra_rptr_next;
    wire rempty;
    assign rempty = (gra_wptr_sync == gra_rptr_next);
    always @(*) begin
        bin_rptr_next = bin_rptr + (rd_en&!empty);
        gra_rptr_next = (bin_rptr_next>>1)^bin_rptr_next;
    end
    always @(posedge rd_clk or negedge rd_rst) begin
        if(!rd_rst) begin
            bin_rptr <= 0;
            gra_rptr <= 0;
        end
        else begin
            bin_rptr <= bin_rptr_next;
            gra_rptr <= gra_rptr_next;
        end
    end
    always @(posedge rd_clk or negedge rd_rst) begin
        if(!rd_rst) begin empty <= 1; end
        else begin empty <= rempty; end
    end
endmodule

module FIFO_Mem #(parameter DEPTH=8,parameter WIDTH =8,parameter PTR_WIDTH=3)(
        input w_en,w_clk,rd_en,rd_clk,
        input [PTR_WIDTH:0] bin_wptr,bin_rdptr,
        input [WIDTH-1:0] data_in,
        input full,empty,
        output wire [WIDTH-1:0] data_out
        );
        
        reg [WIDTH-1:0] fifo[DEPTH-1:0];
        always @(posedge w_clk) begin
            if(w_en&&!full) begin
                fifo[bin_wptr[PTR_WIDTH-1:0]] <= data_in;
            end
        end 
       always @(posedge rd_clk) begin
           if(rd_en&&!empty) begin
               data_out <= fifo[bin_rdptr[PTR_WIDTH-1:0]];
           end
       end
endmodule

module Asynchronous_FIFO #(parameter DEPTH=8, parameter WIDTH=8)(
        input w_clk,w_rst,rd_clk,rd_rst,w_en,rd_en,
        input [WIDTH-1:0] data_in,
        output wire [WIDTH-1:0] data_out,
        output wire full,empty
        );
        
        parameter PTR_WIDTH = $clog2(DEPTH);
        wire [PTR_WIDTH:0] g_wptr_sync,g_rdptr_sync;
        wire [PTR_WIDTH:0] bin_wptr,bin_rd_ptr;
        wire [PTR_WIDTH:0] g_wptr,g_rdptr;
        wire [PTR_WIDTH-1:0] w_addr,rd_addr;
        
        synchrnoizer #(PTR_WIDTH) sync_wptr(.clk(rd_clk),.rst(rd_rst),.data_in(g_wptr),.data_out(g_wptr_sync));
        synchrnoizer #(PTR_WIDTH) sync_rd_ptr(.clk(w_clk),.rst(w_rst),.data_in(g_rdptr),.data_out(g_rdptr_sync));
        FIFO_Wr_ptr_handler #(PTR_WIDTH) wr_h(.w_en(w_en),.w_clk(w_clk),.w_rst(w_rst),.g_rptr_sync(g_rdptr_sync),.full(full),.bin_ptr(bin_wptr),.gra_ptr(g_wptr));
        FIFO_Rd_handle #(PTR_WIDTH) rd_h(.rd_clk(rd_clk),.rd_rst(rd_rst),.rd_en(rd_en),.gra_wptr_sync(g_wptr_sync),.bin_rptr(bin_rd_ptr),.gra_rptr(g_rdptr),.empty(empty));
        FIFO_Mem #(DEPTH,WIDTH) fifomem(.w_en(w_en),.w_clk(w_clk),.rd_en(rd_en),.rd_clk(rd_clk),.bin_wptr(bin_wptr),.bin_rdptr(bin_rd_ptr),.data_in(data_in),.full(full),.empty(empty),.data_out(data_out));
endmodule
