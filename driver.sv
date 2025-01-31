`define DRIV_IF vif.DRIVER.driver_cb

class fifo_driver extends uvm_driver#(fifo_seq_item);
  
  `uvm_component_utils(fifo_driver)
  
  virtual fifo_interface vif;
  fifo_seq_item trans;

  //Constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //Build Phase : get the interface handle from configdb
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif)) 
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  
  //Run Phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      trans = fifo_seq_item ::type_id::create("trans");
      seq_item_port.get_next_item(trans);
      
      @(posedge vif.DRIVER.clk);
      //Driver's writing logic
      if(trans.wr_en) begin
        `DRIV_IF.wr_en<=trans.wr_en;
        `DRIV_IF.rd_en<=trans.rd_en;
        `DRIV_IF.data<=trans.data;
      end
  
      else if(trans.rd_en) begin
        `DRIV_IF.wr_en<=trans.wr_en;
        `DRIV_IF.rd_en<=trans.rd_en; 
      end
    
      seq_item_port.item_done(trans);
    end
  endtask
  
endclass
