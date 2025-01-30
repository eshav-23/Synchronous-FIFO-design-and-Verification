`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2025 23:35:10
// Design Name: 
// Module Name: syn_fifo
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


// Code your design here
module synfifo
  //parameters
  #(parameter depth = 8,
    parameter data_width = 32)
  ( // ports
input clk,
input rstn,
input[data_width-1:0]data,
input rd_en,
input wr_en,
input cs,//chip_selection
output reg [data_width-1:0] data_o,
output empty,
output full);
  
  localparam fifo_depth = $clog2(depth);
  
  // array to store data
  reg [data_width-1:0]mem[0:depth-1];
  
  // read and write pointers have 1 extra bit
  
reg[fifo_depth:0]rd_ptr, wr_ptr;

  // write
  always @(posedge clk or negedge rstn) begin
    if(!rstn) begin  
      wr_ptr <=0;
    end
    else if(cs && wr_en && !full) begin
      mem[wr_ptr[fifo_depth-1:0]] <= data;
      wr_ptr <= wr_ptr + 1'b1;
    end
  end
  
  // read
  always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
      rd_ptr <= 0;
    end
    else if(cs && rd_en && !empty) begin
      data_o <= mem[rd_ptr[fifo_depth-1:0]];
      rd_ptr <= rd_ptr + 1'b1;
    end
  end
  
  assign full = (rd_ptr == {~wr_ptr[fifo_depth],wr_ptr[fifo_depth-1:0]});
  
  assign empty = (rd_ptr == wr_ptr);
endmodule
    
