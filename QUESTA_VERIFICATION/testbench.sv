import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"
`include "sequence_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"
`include "wr_test.sv"
`include "wr_rd_test.sv"
`include "wr_then_rd_test.sv"
`include "wr_rd_parll_test.sv"

module tbench_top;
  
  bit clk;
  bit reset;
  
//Clock Generation
  initial begin
    clk=0;
    forever #5 clk = ~clk; 
  end

//Reset Generation
  // initial begin
   // reset = 0;
   // #2 reset =1;
  // end
	
// RESET Generation
initial begin
	reset = 1'b0;
	repeat(3) @(posedge clk);
	@(negedge clk) reset = 1'b1;
end
  
//Interface Instance
  fifo_interface fifo_if(clk, reset);
  
//DUT Instance
fifo_SISO DUT(
    .clk(fifo_if.clk), 
    .rst_n(fifo_if.rst_n), 
    .wr_en(fifo_if.wr), 
    .rd_en(fifo_if.rd), 
    .data_in(fifo_if.data_in), 
    .data_out(fifo_if.data_out), 
    .empty(fifo_if.empty), 
    .full(fifo_if.full)
  );

// fifo_SISO DUT(in.clk, in.rst_n, in.wr, in.rd, in.data_in, in.data_out, in.empty, in.full);

//Confg Db  
   initial begin 
		$timeformat(-9, 0, " ns", 5);
    $dumpfile("dump.vcd"); 
    $dumpvars(0, tbench_top);
     //set interface into config db, virtual intf, to get access in dynamic clss
     uvm_config_db#(virtual fifo_interface)::set(null,"*","vif",fifo_if);
		 
		 run_test("fifo_test"); // 1. random stimulus
		 
		 //run_test("fifo_wr_test"); // 2. write Only
//     $display("Starting UVM Test...");  

    // run_test("fifo_wr_rd_test"); // 3. back to back write & read
    
    //run_test("fifo_wr_then_rd_test"); // 4. write complete then read
    
    //run_test("fifo_wr_rd_parll_test"); // 5. write read parallel
  end
  
  
  
endmodule
