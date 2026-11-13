/////////////////////////... R A N D O M    S E Q U E N C E .../////////////////////////

//-----------------------------------------------------------------
// 1. fifo_sequence - random stimulus 
class fifo_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_sequence)
  
  //Constructor
  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  // create, randomize and send the item to driver
  virtual task body();
    repeat(15) begin
    req = fifo_seq_item::type_id::create("req");
    wait_for_grant();
    assert(req.randomize());
    send_request(req);
    wait_for_item_done();
        
      //initial begin 

    // Disable response queue error reporting
    //set_response_queue_error_report_disabled(1);
      
    // set response queue depth more than 8

     //  set_response_queue_depth(15) ;
  //end
   end 
  endtask
endclass


/////////////////////////...W R I T E    S E Q U E N C E.../////////////////////////

//----------------------------------------------------------------------
// 2. write_sequence - "write" type
class fifo_write_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_write_sequence)
      fifo_seq_item item;

  //Constructor
  function new(string name = "fifo_write_sequence");
    super.new(name);
  endfunction
  
  //body task of sequence
  virtual task body();
    $display("Starting UVM Seq Body ...");  

    repeat(8) begin
      req = fifo_seq_item::type_id::create("req");
      
      start_item(req);
      assert(req.randomize() with {req.wr==1;req.rd==0;});
      finish_item(req);
            
      // set_response_queue_depth(15) ;

     // `uvm_do_with(req,{req.wr==1;req.rd==0;})
     end

  endtask
endclass

/////////////////////////...R E A D    S E Q U E N C E...\\\\\\\\\\\\\\\\\

//------------------------------------------------------------------------
// 3. read_sequence - "read" type
class fifo_read_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_read_sequence)
   
  //Constructor
  function new(string name = "fifo_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(8) begin
      // `uvm_do_with(req,{req.rd==1;req.wr==0;})
      // set_response_queue_depth(25) ;
			req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.rd==1; req.wr==0;});
      finish_item(req);

    end
  endtask
  
endclass
        

/////////////////////////...W R I T E  THEN   R E A D   S E Q U E N C E...\\\\\\\\\\\\\\\\\

//------------------------------------------------------------------------------
// 4. wr_rd_sequence - "write" complete first then "read" (sequence's inside sequences)
//used in wr_then_rd_test.sv

//write complete then read complete

class fifo_wr_then_rd_sequence extends uvm_sequence#(fifo_seq_item);
  
  //Declaring sequences
  fifo_write_sequence wr_seq;
  fifo_read_sequence  rd_seq;
  
  `uvm_object_utils(fifo_wr_then_rd_sequence)
   
  //Constructor
  function new(string name = "fifo_wr_then_rd_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do(wr_seq)
    `uvm_do(rd_seq)
  endtask
  
endclass
//--------------------------------------------------------------------------

        
/////////////////////////...W R I T E   R E A D  BACK-TO-BACK S E Q U E N C E...\\\\\\\\\\\\\\\\\

// 5. write_read_sequence - "write" followed by "read" 

//used in wr_rd_test.sv
//write read back to back

 class fifo_write_read_sequence extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_write_read_sequence)
   
  //Constructor
  function new(string name = "fifo_write_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(10) begin
			//req = fifo_seq_item::type_id::create("req");
			//  `uvm_do_with(req,{req.wr==1;req.rd==0;})
			//  `uvm_do_with(req,{req.wr==0;req.rd==1;})
		 
			// set_response_queue_error_report_disabled(1); 
			//set_response_queue_depth(10) ;
			req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr==1; req.rd==0;});
      finish_item(req);
      
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr==0; req.rd==1;});
      finish_item(req);

    end
  endtask
endclass        
        
/////////////////////////...W R I T E,   R E A D   SIMULTANIOUSLY  S E Q U E N C E...\\\\\\\\\\\\\\\\\

//6. write_read_parallel_sequence - "write" & "read" 

//used in wr_rd_test.sv

 class fifo_wr_rd_parallel_seq extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_wr_rd_parallel_seq)
  
  //Constructor
  function new(string name = "fifo_wr_rd_parallel_seq");
    super.new(name);
  endfunction
	
	// fifo_seq_item req;
  
  virtual task body();
    
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr==1;req.rd==0;});
      finish_item(req);
      
      repeat(8) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr==1;req.rd==1;});
      finish_item(req);
     // set_response_queue_depth(15) ;
			
			end
			
			req = fifo_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {req.wr==0;req.rd==1;});
      finish_item(req);
    
    
    
  endtask
   
endclass        

/////////////////////////... C O R N E R   C A S E   S E Q U E N C E...\\\\\\\\\\\\\\\\\

// 7. fifo_corner_seq - Hits underflow, overflow, and wraparound coverage bins
class fifo_corner_seq extends uvm_sequence#(fifo_seq_item);
  
  `uvm_object_utils(fifo_corner_seq)
  
  function new(string name = "fifo_corner_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_info("SEQ", "Starting Corner Case Sequence...", UVM_LOW)
    
    // 1. UNDERFLOW: Try to read from an empty FIFO
    repeat (3) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req); assert(req.randomize() with {wr==0; rd==1;}); finish_item(req);
    end
    
    // 2. FILL TO FULL: Write 8 times
    repeat (8) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req); assert(req.randomize() with {wr==1; rd==0;}); finish_item(req);
    end
    
    // 3. OVERFLOW: Try to write to a full FIFO
    repeat (3) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req); assert(req.randomize() with {wr==1; rd==0;}); finish_item(req);
    end
    
    // 4. WRAPAROUND: Alternating read/writes to force internal pointers to wrap around
    repeat (20) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req); assert(req.randomize() with {wr==1; rd==0;}); finish_item(req);
      
      req = fifo_seq_item::type_id::create("req");
      start_item(req); assert(req.randomize() with {wr==0; rd==1;}); finish_item(req);
    end
    
    // 5. DRAIN & UNDERFLOW: Read until empty, then read some more
    repeat (10) begin
      req = fifo_seq_item::type_id::create("req");
      start_item(req); assert(req.randomize() with {wr==0; rd==1;}); finish_item(req);
    end
    
  endtask
endclass