/* 
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
    $display("Starting UVM Driver Run phase...");  

    forever begin
      // trans = fifo_seq_item ::type_id::create("trans");
      seq_item_port.get_next_item(trans);
      
      @(posedge vif.DRIVER.clk);
      //Driver's writing logic
      if(trans.wr) begin
        `DRIV_IF.wr<=trans.wr;
        `DRIV_IF.rd<=trans.rd;
        `DRIV_IF.data_in<=trans.data_in;
      end
  
      else if(trans.rd) begin
        `DRIV_IF.wr<=trans.wr;
        `DRIV_IF.rd<=trans.rd; 
      end
    
      seq_item_port.item_done(trans);
    end
  endtask
  
endclass
 */
 
class fifo_driver extends uvm_driver#(fifo_seq_item);

	// factory registeration
	`uvm_component_utils(fifo_driver)
	
	// handle declarations
	virtual fifo_interface vif;
	fifo_seq_item trans;
	
	// Constructor
	function new(string name = "fifo_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	// BUILD PHASE
	// getting interface
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// getting the interface from configdb
		if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif)) begin 
			`uvm_fatal("NO_VIF",{"virtual interface must be set for: ", get_full_name(),".vif"})
		end
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		`uvm_info("DRIVER", "Starting UVM Driver Run phase...", UVM_MEDIUM)
		
		// initializing wr rd and data_in to 0;
		vif.driver_cb.wr <= 1'b0;
    vif.driver_cb.rd <= 1'b0;
    vif.driver_cb.data_in <= '0;
		
		// handling the reset condition
		// If your UVM driver does not wait for reset to finish, it will immediately fetch the first transaction from the sequence and drive wr = 1 while the DUT is still in reset. The DUT will completely ignore this write, meaning your very first transaction is permanently lost into the void. The scoreboard will then fail because the monitor saw a write that the DUT never actually processed.
		
		wait(vif.rst_n === 1'b1); // after this our transaction will start
		
		forever begin
			// Blocking call: waits here until the sequence provides an item
      seq_item_port.get_next_item(trans);
      
      `uvm_info("DRIVER", $sformatf("Driving Transaction:\n%s", trans.sprint()), UVM_MEDIUM)
			// `uvm_info("DRIVER", $sformatf("Driving Stimulus -> wr=%0b, rd=%0b, data_in=0x%0h", req.wr, req.rd, req.data_in), UVM_MEDIUM)
      
      // Synchronize with the clock edge
      @(vif.DRIVER.driver_cb);
      
      // Drive interface signals
      if (trans.wr) begin
        vif.driver_cb.wr <= trans.wr;
        vif.driver_cb.rd <= trans.rd;
        vif.driver_cb.data_in <= trans.data_in;
      end 
      else if (trans.rd) begin
        vif.driver_cb.wr <= trans.wr;
        vif.driver_cb.rd <= trans.rd;
      end 
      else begin
        // Handles explicit idle transactions (wr=0, rd=0)
				// Through this we are solving major 2 issues.
				// ISSUE - 1
				// Why signals MUST be de-asserted (driven to 0) after a transaction: Simulation wires are "sticky"—they hold their last driven value until explicitly changed. If your sequence sends a write (wr = 1), the driver puts a 1 on the physical interface wire. When the sequence finishes and goes idle, if the driver does not explicitly drive wr <= 0, that wire stays at 1 permanently.
				// ISSUE - 2
				// The Danger of Drain Time: You have a drain_time of 50ns in your tests, which equals 5 extra clock cycles. If you don't drive wr <= 0 at the end of the sequence, the clock keeps ticking for those 5 cycles with wr still stuck at 1. The DUT will execute 5 completely fake, duplicate writes into your FIFO, overflowing it and destroying your scoreboard synchronization.
				vif.driver_cb.wr <= 1'b0;
        vif.driver_cb.rd <= 1'b0;
      end
      
      // Transaction complete
      seq_item_port.item_done();
		end
		
	endtask

endclass