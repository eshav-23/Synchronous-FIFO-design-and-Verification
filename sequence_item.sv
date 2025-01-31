`include "uvm_macros.svh"

class fifo_seq_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item)

  //data and control signals in trasaction packet
  // Data members (fields) that make up the transaction
  rand bit [7:0]data;
  rand bit rd_en;
  rand bit wr_en;
  bit full;
  bit empty;
  bit [7:0]data_o;
  
  //Constructor
  function new(string name="fifo_seq_item");
    super.new(name);
  endfunction
  
endclass
