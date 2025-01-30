//Fifo interface

interface fifo_interface(input logic clk,rst);

  logic [7:0]data;
  logic [7:0]data_o;
  logic empty;
  logic full;
  logic rd_en;
  logic wr_en;
  logic [3:0]fifo_cnt;
  
  clocking driver_cb @(posedge clk);
    output data;
    output rd_en,wr_en;
    input full,empty;
    input data_o;
    input fifo_cnt;
  endclocking
  
  clocking monitor_cb @(posedge clk);
    input data;
    input rd_en,wr_en;
    input full,empty;
    input data_o;
    input fifo_cnt;
  endclocking  
  
  modport DRIVER(clocking driver_cb,input clk,rst);
  modport MONITOR(clocking monitor_cb,input clk,rst);
  
endinterface
