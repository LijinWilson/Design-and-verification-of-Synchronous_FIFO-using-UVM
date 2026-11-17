// ==============================================================================
// fifo_coverage.sv - Functional coverage for Synchronous FIFO
// ==============================================================================
`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_coverage extends uvm_subscriber #(fifo_seq_item);
  `uvm_component_utils(fifo_coverage)

  fifo_seq_item tx;                // Transaction being sampled
  localparam int DEPTH = 8;        // Match RTL FIFO depth
  int occupancy;                   // Internal tracker for fill level in FIFO

  // ------------------------------------------------------------------
  // 1. DATA COVERAGE: Checks occurrences on the data buses
  // ------------------------------------------------------------------
  covergroup cg_data;
    option.per_instance = 1;

    // PWDATA: Target corner values only when write is accepted
    cp_data_in : coverpoint tx.data_in iff (tx.wr && !tx.full) {
      bins all_zeros = {0};
      bins all_ones  = {~0};
      bins others    = default;
    }

    // PRDATA: Target corner values only when read is accepted
    cp_data_out : coverpoint tx.data_out iff (tx.rd && !tx.empty) {
      bins all_zeros = {0};
      bins all_ones  = {~0};
      bins others    = default;
    }
  endgroup

  // ------------------------------------------------------------------
  // 2. CONTROL COVERAGE: Checks occurrences of all control signals
  // ------------------------------------------------------------------
  covergroup cg_ctrl;
    option.per_instance = 1;

    // Track every possible fill level based on our local tracker
    cp_occupancy : coverpoint occupancy {
      bins levels[] = {[0:DEPTH]};
    }

    // Explicit occurrence checks for all control inputs
    cp_wr_en : coverpoint tx.wr { bins idle = {0}; bins req = {1}; }
    cp_rd_en : coverpoint tx.rd { bins idle = {0}; bins req = {1}; }

    // Explicit occurrence checks for all hardware state outputs
    cp_empty : coverpoint tx.empty { bins low = {0}; bins high = {1}; }
    cp_full  : coverpoint tx.full  { bins low = {0}; bins high = {1}; }

    // Group the physical state for crossing
    cp_state : coverpoint {tx.full, tx.empty} {
      bins empty = {2'b01};
      bins mid   = {2'b00};
      bins full  = {2'b10};
      illegal_bins invalid = {2'b11}; // Hardware should never be full AND empty
    }

    // The Golden Matrix: Crosses every request (wr/rd) against every state (empty/mid/full)
    // This perfectly captures simultaneous RW, pure RW, and illegal/negative tests.
    cross_req_x_state : cross cp_state, cp_wr_en, cp_rd_en;
  endgroup

  // ------------------------------------------------------------------
  // 3. RESET COVERAGE: Checks reset assertions
  // ------------------------------------------------------------------
  covergroup cg_reset;
    option.per_instance = 1;

    // PRESETn: Ensure both reset assert and release are seen
    cp_rst_n : coverpoint tx.rst_n {
      bins rst_assert  = {0};
      bins rst_release = {1};
    }
  endgroup


  // ------------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------------
  function new(string name = "fifo_coverage", uvm_component parent = null);
    super.new(name, parent);
    cg_data  = new();
    cg_ctrl  = new();
    cg_reset = new();
    occupancy = 0;
  endfunction


  // ------------------------------------------------------------------
  // Write Function: Simple, efficient evaluation
  // ------------------------------------------------------------------
  function void write(fifo_seq_item t);
    bit wr_accepted, rd_accepted;
    tx = t;

    // 1. Reset Logic
    if (!t.rst_n) begin
      occupancy = 0;      // Hardware clears memory on reset
      cg_reset.sample();  // Sample reset assertion
      return;             // Do not sample functional logic while in reset
    end

    // 2. Decode Accepted Operations
    wr_accepted = t.wr && !t.full;
    rd_accepted = t.rd && !t.empty;

    // 3. Sample standard coverage
    cg_reset.sample(); // Sample reset release
    cg_data.sample();
    cg_ctrl.sample();

    // 4. Update Occupancy tracker for the NEXT clock cycle
    // By adding accepted writes (1 or 0) and subtracting accepted reads (1 or 0), 
    // it perfectly handles simultaneous reads/writes (+1 -1 = 0 change).
    occupancy = occupancy + wr_accepted - rd_accepted;

  endfunction


  // ------------------------------------------------------------------
  // Report Phase
  // ------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    `uvm_info("COV", $sformatf("Data=%0.2f%%  Ctrl=%0.2f%%  Reset=%0.2f%%", cg_data.get_inst_coverage(), cg_ctrl.get_inst_coverage, cg_reset.get_inst_coverage()), UVM_NONE)
  endfunction

endclass