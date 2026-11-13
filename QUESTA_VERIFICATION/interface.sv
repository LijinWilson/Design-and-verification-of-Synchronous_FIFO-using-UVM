`timescale 1ns/1ps // Added timescale for deterministic simulation delays

interface fifo_interface(input logic clk,rst_n);

  logic [7:0]data_in;
  logic [7:0]data_out;
  logic empty;
  logic full;
  logic rd;
  logic wr;
  
  clocking driver_cb @(posedge clk);
		default input #1step output #1;
    output data_in;
    output rd,wr;
    input full,empty;
    input data_out;
  endclocking
  
  clocking monitor_cb @(posedge clk);
		default input #1step output #1;
		input rst_n;
    input data_in;
    input rd,wr;
    input full,empty;
    input data_out;
  endclocking  
  
  modport DRIVER(clocking driver_cb,input clk,rst_n);
  modport MONITOR(clocking monitor_cb,input clk,rst_n);
  
endinterface
