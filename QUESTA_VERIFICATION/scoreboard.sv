/* class fifo_scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(fifo_scoreboard)

  //Analysis import declaration
  uvm_analysis_imp#(fifo_seq_item, fifo_scoreboard) scb_port;
  //uvm_analysis_imp is the component that receives and processes the transactions.
  fifo_seq_item que[$];
  
  fifo_seq_item trans;

  
  bit [7:0]mem[$];
  bit [7:0] tx_data;
  bit  read_delay_clk;

  //Constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb_port = new("scb_port", this);
  endfunction
  
  //Write function implemetation
  function void write(fifo_seq_item transaction);
   que.push_back(transaction);
 endfunction 
  
 virtual task run_phase(uvm_phase phase);
    forever begin
    
    wait(que.size()>0);
    trans=que.pop_front();

    //WRITE
    if(trans.wr==1) begin
			mem.push_back(trans.data_in);
    end
          
    //READ
    if(trans.rd==1 || (read_delay_clk != 0)) 
			begin //if block starts here
				if(read_delay_clk==0) read_delay_clk = 1;
					else begin //else
						if(trans.rd==0) read_delay_clk = 0;
							if(mem.size>0) 
								begin
									tx_data = mem.pop_front();
										if(trans.data_out==tx_data) 
											begin
												`uvm_info("SCOREBOARD",$sformatf("------ :: EXPECTED MATCH  :: ------"),UVM_MEDIUM)
												`uvm_info("SCOREBOARD",$sformatf("Exp Data: %0d, Rec data=%0d",tx_data,trans.data_out),UVM_MEDIUM)
												`uvm_info("SCOREBOARD",$sformatf("-------------------------------------------------------"),UVM_MEDIUM)
											end
										else 
											begin
												`uvm_info("SCOREBOARD",$sformatf("------ ::  FAILED MATCH  :: ------"),UVM_MEDIUM)
												`uvm_info("SCOREBOARD",$sformatf("Exp Data: %0d, Rec data=%0d",tx_data,trans.data_out),UVM_MEDIUM)
												`uvm_info("SCOREBOARD",$sformatf("-------------------------------------------------------"),UVM_MEDIUM)
											end
								end
					end //else
			end //if block ends here
          
			else
				read_delay_clk = 0;
 
    end
  endtask 
                  
  
endclass
        
 */
 
class fifo_scoreboard extends uvm_scoreboard;
	
	// factory registeration
	`uvm_component_utils(fifo_scoreboard)
	
	// Analysis Port Declaration.
	uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) scb_port;
	
	// Reference model memory
	localparam int FIFO_DEPTH = 8;
	bit [7:0] mem [$];
	
	// 1 clock cycle read delay
	bit read_delay_clk;
	
	// Reporting Counters
  int unsigned match_cnt;
  int unsigned mismatch_cnt;
	
	// Constructor
	function new(string name = "fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	// BUILD PHASE
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// creating instance or memory for Analysis Port
		scb_port = new("scb_port", this);
	endfunction
	
	// implemetation of write function, receives transaction from monitor on every clock cycle 
	virtual function void write(fifo_seq_item trans);
		bit [7:0] expected_data; // stores the Write data;
		
		// Reset handling
		if (trans.rst_n !== 1'b1) begin
			mem.delete();
			read_delay_clk = 0;
			`uvm_info("SCOREBOARD", "Reference FIFO cleared during reset", UVM_MEDIUM)
			return;
		end
		
		// X-State Detection
    if ($isunknown({trans.wr, trans.rd})) begin
      `uvm_error("SCOREBOARD", "X or Z state detected on wr/rd control signals")
    end
		
		// DUT full and empty Flag Cross-Checking (Ensures RTL flags match reference model state)
    if (trans.empty !== (mem.size() == 0)) begin
      `uvm_error("SCOREBOARD", $sformatf("EMPTY FLAG MISMATCH: DUT=%b, Model Size=%0d", trans.empty, mem.size()))
    end
    if (trans.full !== (mem.size() == FIFO_DEPTH)) begin
      `uvm_error("SCOREBOARD", $sformatf("FULL FLAG MISMATCH: DUT=%b, Model Size=%0d", trans.full, mem.size()))
    end
		
		// Start read operation and checking
		if(read_delay_clk) begin
			if(mem.size() > 0) begin
				expected_data = mem.pop_front();
				
				if(trans.data_out == expected_data) begin
					match_cnt++;
					`uvm_info("SCOREBOARD", $sformatf("PASS: Expected = %0h, Actual = %0h", expected_data, trans.data_out), UVM_LOW)
				end else begin
					mismatch_cnt++;
					`uvm_error("SCOREBOARD", $sformatf("FAIL: Expected = %0h, Actual = %0h", expected_data, trans.data_out))
				end
			end else begin
				`uvm_error("SCOREBOARD", "Read pending but reference memory is empty!")
			end
			// Clear flag. It will be set again in Step 3 if a back-to-back read is occurring.
			read_delay_clk = 0;
		end
		
		// WRITE Operation
		if(trans.wr && !trans.full) begin
			mem.push_back(trans.data_in); // if wr and not full store the write data inside the Reference memory
		end
		
		// READ Operation
		if(trans.rd && !trans.empty) begin
			read_delay_clk = 1; // if rd and not empty, initialize the delay for reading the data;
		end
		
	endfunction
	
	// REPORT PHASE
	virtual function void report_phase(uvm_phase phase);
		`uvm_info("SCOREBOARD", $sformatf("SIMULATION SUMMARY: Matches = %0d, Mismatches = %0d, Items left in Model = %0d", match_cnt, mismatch_cnt, mem.size()), UVM_LOW)
		
		// Checks if the test ended while we were still waiting for a read response
		if (read_delay_clk) begin
			`uvm_warning("SCOREBOARD", "Simulation ended while waiting for a read response (1-cycle delay hanging)")
		end
  endfunction
 
 endclass
 
 
 
 