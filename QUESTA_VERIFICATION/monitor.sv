/* //Fifo Monitor

`define MON_IF vif.monitor_cb

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
      
			trans.wr=`MON_IF.wr;
			trans.data_in=`MON_IF.data_in;
			trans.full=`MON_IF.full;
		 
			trans.rd=`MON_IF.rd;
			trans.data_out=`MON_IF.data_out;
			trans.empty=`MON_IF.empty;
		
			@(posedge `MON_IF);
        
      ap.write(trans);
    end  
    
  endtask
endclass
 */
 
`define MON_IF vif.monitor_cb

class fifo_monitor extends uvm_monitor;
	
	// Factory Registeration
	`uvm_component_utils(fifo_monitor)
	
	// UVM Analysis Port declaration
	uvm_analysis_port #(fifo_seq_item) ap;
	
	// Handle declaration
	virtual fifo_interface vif; // Interface
	fifo_seq_item trans; // Sequence Item
	
	// Constructor
	function new(string name = "fifo_monitor", uvm_component parent = null);
		super.new(name, parent);
		
		// uvm_analysis_port declaration
		ap = new("ap", this);
		
	endfunction
	
	// BUILD PHASE
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// getting Interface
		assert(uvm_config_db #(virtual fifo_interface)::get(this, "", "vif", vif)) else `uvm_fatal("NO_VIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
		
	endfunction
	
	// RUN PHASE
	task run_phase(uvm_phase phase);
		
		super.run_phase(phase);
		
		`uvm_info("MONITOR", "Starting UVM Monitor Run phase...", UVM_MEDIUM)
		
		forever begin
			
			// Wait for monitor clocking block
			@(`MON_IF);
			
			// RESET handling and initializing the values
			if(`MON_IF.rst_n !== 1'b1) begin
				trans = fifo_seq_item::type_id::create("reset_trans");

        trans.rst_n = 0;
        trans.wr = 0;
        trans.rd = 0;
				trans.data_out = '0;

        ap.write(trans);
				
				// wait for reset to de-assert before Starting sampling operation
				wait(vif.rst_n === 1'b1);
				continue;
				
			end
			
			// creating memory for transactions Item
			trans = fifo_seq_item::type_id::create("trans");
			
			// Sample all signals accurately at the stable clock edge
			trans.rst_n    = `MON_IF.rst_n;
			trans.wr       = `MON_IF.wr;
			trans.rd       = `MON_IF.rd;
			trans.data_in  = `MON_IF.data_in;
			trans.full     = `MON_IF.full;
			trans.empty    = `MON_IF.empty;
			trans.data_out = `MON_IF.data_out;
			
			// Log only active transactions to prevent transcript flooding on idle cycles
      if (trans.wr || trans.rd) begin
        `uvm_info("MONITOR", $sformatf("Sampled Transaction:\n%s", trans.sprint()), UVM_HIGH)
      end
      
      // Broadcast transaction to scoreboard every cycle (including idles for read delay tracking)
			// If your monitor only sends active transactions (wr==1 or rd==1) to the scoreboard, the scoreboard will never receive the "idle" clock cycle that contains the actual delayed read data!
      ap.write(trans);
		
		end
		
	endtask
	
endclass