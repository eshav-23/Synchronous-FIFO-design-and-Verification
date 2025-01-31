

//Fifo Monitor

`define MON_IF vif.MONITOR.monitor_cb

class fifo_monitor extends uvm_monitor;
  
  virtual fifo_interface vif;
  
  //Analysis port declaration
  uvm_analysis_port#(fifo_seq_item) ap;
  //uvm_analysis_port is the component that sends transactions to other components.
  
  `uvm_component_utils(fifo_monitor)
  
  //Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap=new("ap", this);
  endfunction
  
  //Build phase : get the interface handle from configdb
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif)) begin
       `uvm_error("build_phase", "No virtual interface specified for this monitor instance")
       end
   endfunction  
  
  //Run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
     fifo_seq_item trans;
     trans = fifo_seq_item ::type_id::create("trans");
      
          trans.wr_en=`MON_IF.wr_en;
          trans.data=`MON_IF.data;
          trans.full=`MON_IF.full;
         
          trans.rd_en=`MON_IF.rd_en;
          trans.data_o=`MON_IF.data_o;
          trans.empty=`MON_IF.empty;
        
          @(posedge vif.MONITOR.clk);
        
      ap.write(trans);
    end  
    
  endtask
endclass
