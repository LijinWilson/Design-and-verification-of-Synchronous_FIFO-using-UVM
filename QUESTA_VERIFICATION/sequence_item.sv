// mentioning the guard so that it should compiled once during simulation build
`ifndef FIFO_SEQ_ITEM_SV
`define FIFO_SEQ_ITEM_SV 

`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_seq_item extends uvm_sequence_item;

  //data and control signals in trasaction packet
  // Data members (fields) that make up the transaction
  rand logic [7:0]data_in;
  rand logic rd;
  rand logic wr;
  logic full;
  logic empty;
  logic [7:0]data_out;
	logic rst_n;
	
		// Factory Registeration
	`uvm_object_utils_begin(fifo_seq_item)
		`uvm_field_int(data_in, UVM_ALL_ON)
		`uvm_field_int(rd, UVM_ALL_ON)
		`uvm_field_int(wr, UVM_ALL_ON)
		`uvm_field_int(full, UVM_ALL_ON)
		`uvm_field_int(empty, UVM_ALL_ON)
		`uvm_field_int(data_out, UVM_ALL_ON)
		`uvm_field_int(rst_n, UVM_ALL_ON)
	`uvm_object_utils_end
	
  
  //Constructor
  function new(string name="fifo_seq_item");
    super.new(name);
  endfunction
  
endclass

`endif
