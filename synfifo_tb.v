`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.01.2025 23:36:02
// Design Name: 
// Module Name: synfifo_tb
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


// Code your testbench here
// or browse Examples
module synfifo_tb();
  //testbench variables
  parameter data_width = 32;
  parameter depth = 8;
  reg clk =0;
  reg rstn;
  reg rd_en, wr_en;
  reg [data_width-1:0]data;
  reg cs;
  wire [data_width-1:0] data_o;
wire empty;
wire full;
  integer i;
  // instantiate the dut
  synfifo 
  #(.depth(depth), .data_width(data_width))
  dut 
  (.clk(clk),
   .rstn(rstn),
       .data(data),
       .rd_en(rd_en),
       .wr_en(wr_en),
       .cs(cs),
       .data_o(data_o),
       .empty(empty),
       .full(full));
  
  // create the clock signals
  always begin #5 clk = ~clk; end
  
  task wr_data(input [data_width-1:0]d_in);
    begin
      @(posedge clk);
      cs =1; wr_en = 1;
      data = d_in;
      $display($time, "write data data = %0d", data);
      @(posedge clk);
      cs =1; wr_en = 0;
    end
  endtask
  
  task rd_data();
  begin
    @(posedge clk);
    cs =1; rd_en = 1;
    @(posedge clk);
    $display($time, "read data data = %0d", data_o); 
   cs =1; rd_en = 0;
  end
  endtask
  
  // create stimulus 
  initial begin
    #1;
    rstn =0; rd_en = 0; wr_en=0;
    
    @(posedge clk)
    rstn=1;
    $display($time, "\n case1");
    wr_data(1);
    wr_data(10);
    wr_data(100);
    rd_data();
    rd_data();
    rd_data();
    $display($time, "\n case2");
    for(i=0;i<depth;i=i+1)begin
      wr_data(2**i);
      rd_data();
    end
    
    for(i=0;i<=depth;i=i+1)begin
  wr_data(2**i);
    end
      
for(i=0;i<depth;i=i+1)begin
      rd_data();
    end
  
#40 $finish;
  end
 
  
endmodule