class fifo_agent extends uvm_agent;
  
  fifo_sequencer seqr;
  fifo_driver driv;	
  fifo_monitor mon;
  
  //Utility and Field macros
  `uvm_component_utils(fifo_agent)
  
  //Constructor
  function new(string name = "fifo_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
		mon = fifo_monitor::type_id::create("mon",this);
		
		// Checking the Agent is Active or Passive
		if(get_is_active() == UVM_ACTIVE) begin
			seqr = fifo_sequencer::type_id::create("seqr",this);
			driv = fifo_driver::type_id::create("driv",this);		
		end
    
  endfunction
  
  //Connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
		if(get_is_active() == UVM_ACTIVE) begin
			driv.seq_item_port.connect(seqr.seq_item_export);
			`uvm_info("FIFO_AGENT", "connect_phase, Connected driver to sequencer", UVM_LOW);
		end
  endfunction
  
endclass
