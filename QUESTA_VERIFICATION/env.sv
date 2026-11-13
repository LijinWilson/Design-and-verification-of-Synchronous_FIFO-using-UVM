class fifo_environment extends uvm_env;

  // Factory Registeration
	`uvm_component_utils(fifo_environment)

  fifo_agent agt;
  fifo_scoreboard scb;
  
  //Constructor
  function new(string name = "fifo_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //Build phase
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    agt=fifo_agent::type_id::create("agt", this);
    scb=fifo_scoreboard::type_id::create("scb", this);
  endfunction
    
  //---------------------------------------
  //Connect phase
  //---------------------------------------
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.ap.connect(scb.scb_port);
    `uvm_info("FIFO_ENVIRONMENT", "connect_phase, Connected monitor to scoreboard", UVM_LOW)
  endfunction
    
endclass
