//-------------------------------------------------------------------------
//write read back to back test 
//fifo_sequence : random stimulus
//fifo_write_sequence : write stimulus
//-------------------------------------------------------------------------

class fifo_test extends uvm_test;
  
	// Factory Registeration
  `uvm_component_utils(fifo_test)
  
	// component and interface handle
	fifo_environment env;
  virtual fifo_interface vif;
  
  //Constructor
  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env=fifo_environment::type_id::create("env", this);
		
		// 1. GET the virtual interface from the top-level module (tb_top)
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif)) 
      begin
        `uvm_fatal("build_phase","Test virtual interface failed")
      end
		
		// 2. SET the virtual interface to all lower-level components ("*")
		uvm_config_db#(virtual fifo_interface)::set(this, "*", "vif", vif);
  endfunction
	
    
  
  // end_of_elobaration phase
  virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
    
		`uvm_info("TOPOLOGY", "\nPrinting Verification Environment Topology:", UVM_LOW)
		
    uvm_top.print_topology();
  endfunction
  
  //Run phase
  virtual task run_phase(uvm_phase phase);
    fifo_sequence fifo_seq;
    fifo_seq = fifo_sequence::type_id::create("fifo_seq");

    phase.raise_objection( this, "Starting  main phase" );
		
    `uvm_info("FIFO_TEST", "Starting sequence fifo_seq in run_phase", UVM_LOW)
		
    fifo_seq.start(env.agt.seqr);
		
		// DRAIN TIME: Crucial for 1-cycle pipeline!
    // Gives the monitor and scoreboard time to process the very last transaction.
    #50ns;
		
    phase.drop_objection( this , "Finished fifo_seq in main phase" );
  endtask
  
endclass
