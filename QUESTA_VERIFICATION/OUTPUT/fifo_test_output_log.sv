# ----------------------------------------------------------------
# UVM-1.1d
# (C) 2007-2013 Mentor Graphics Corporation
# (C) 2007-2013 Cadence Design Systems, Inc.
# (C) 2006-2013 Synopsys, Inc.
# (C) 2011-2013 Cypress Semiconductor Corp.
# ----------------------------------------------------------------
# 
#   ***********       IMPORTANT RELEASE NOTES         ************
# 
#   You are using a version of the UVM library that has been compiled
#   with `UVM_NO_DEPRECATED undefined.
#   See http://www.eda.org/svdb/view.php?id=3313 for more details.
# 
#   You are using a version of the UVM library that has been compiled
#   with `UVM_OBJECT_MUST_HAVE_CONSTRUCTOR undefined.
#   See http://www.eda.org/svdb/view.php?id=3770 for more details.
# 
#       (Specify +UVM_NO_RELNOTES to turn off this notice)
# 
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(215) @ 0: reporter [Questa UVM] QUESTA_UVM-1.2.3
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(216) @ 0: reporter [Questa UVM]  questa_uvm::init(+struct)
# UVM_INFO @ 0 ns: reporter [RNTST] Running test fifo_test...
# UVM_INFO agent.sv(34) @ 0 ns: uvm_test_top.env.agt [FIFO_AGENT] connect_phase, Connected driver to sequencer
# UVM_INFO env.sv(29) @ 0 ns: uvm_test_top.env [FIFO_ENVIRONMENT] connect_phase, Connected monitor to scoreboard
# UVM_INFO test.sv(43) @ 0 ns: uvm_test_top [TOPOLOGY] 
# Printing Verification Environment Topology:
# UVM_INFO @ 0 ns: reporter [UVMTOP] UVM testbench topology:
# --------------------------------------------------------------
# Name                       Type                    Size  Value
# --------------------------------------------------------------
# uvm_test_top               fifo_test               -     @471 
#   env                      fifo_environment        -     @478 
#     agt                    fifo_agent              -     @488 
#       driv                 fifo_driver             -     @627 
#         rsp_port           uvm_analysis_port       -     @642 
#         seq_item_port      uvm_seq_item_pull_port  -     @634 
#       mon                  fifo_monitor            -     @503 
#         ap                 uvm_analysis_port       -     @510 
#       seqr                 fifo_sequencer          -     @518 
#         rsp_export         uvm_analysis_export     -     @525 
#         seq_item_export    uvm_seq_item_pull_imp   -     @619 
#         arbitration_queue  array                   0     -    
#         lock_queue         array                   0     -    
#         num_last_reqs      integral                32    'd1  
#         num_last_rsps      integral                32    'd1  
#     scb                    fifo_scoreboard         -     @495 
#       scb_port             uvm_analysis_imp        -     @657 
# --------------------------------------------------------------
# 
# UVM_INFO test.sv(55) @ 0 ns: uvm_test_top [FIFO_TEST] Starting sequence fifo_seq in run_phase
# UVM_INFO monitor.sv(91) @ 0 ns: uvm_test_top.env.agt.mon [MONITOR] Starting UVM Monitor Run phase...
# UVM_INFO driver.sv(80) @ 0 ns: uvm_test_top.env.agt.driv [DRIVER] Starting UVM Driver Run phase...
# UVM_INFO scoreboard.sv(118) @ 5 ns: uvm_test_top.env.scb [SCOREBOARD] Reference FIFO cleared during reset
# UVM_INFO driver.sv(96) @ 30 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @672 
#   data_in   integral       8     'h85 
#   rd        integral       1     'h1  
#   wr        integral       1     'h1  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 35 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @708 
#   data_in   integral       8     'he7 
#   rd        integral       1     'h0  
#   wr        integral       1     'h0  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 45 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @716 
#   data_in   integral       8     'h13 
#   rd        integral       1     'h1  
#   wr        integral       1     'h1  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 55 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @724 
#   data_in   integral       8     'h0  
#   rd        integral       1     'h0  
#   wr        integral       1     'h1  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 65 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @732 
#   data_in   integral       8     'hd3 
#   rd        integral       1     'h0  
#   wr        integral       1     'h0  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO scoreboard.sv(142) @ 75 ns: uvm_test_top.env.scb [SCOREBOARD] PASS: Expected = 85, Actual = 85
# UVM_INFO driver.sv(96) @ 75 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @740 
#   data_in   integral       8     'h2a 
#   rd        integral       1     'h0  
#   wr        integral       1     'h0  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 85 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @748 
#   data_in   integral       8     'h50 
#   rd        integral       1     'h0  
#   wr        integral       1     'h1  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 95 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @756 
#   data_in   integral       8     'h37 
#   rd        integral       1     'h0  
#   wr        integral       1     'h0  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 105 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @764 
#   data_in   integral       8     'h99 
#   rd        integral       1     'h0  
#   wr        integral       1     'h1  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 115 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @772 
#   data_in   integral       8     'hbc 
#   rd        integral       1     'h1  
#   wr        integral       1     'h0  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 125 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @780 
#   data_in   integral       8     'h88 
#   rd        integral       1     'h1  
#   wr        integral       1     'h0  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 135 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @788 
#   data_in   integral       8     'h9b 
#   rd        integral       1     'h0  
#   wr        integral       1     'h0  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO scoreboard.sv(142) @ 145 ns: uvm_test_top.env.scb [SCOREBOARD] PASS: Expected = 13, Actual = 13
# UVM_INFO driver.sv(96) @ 145 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @796 
#   data_in   integral       8     'he8 
#   rd        integral       1     'h0  
#   wr        integral       1     'h1  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO scoreboard.sv(142) @ 155 ns: uvm_test_top.env.scb [SCOREBOARD] PASS: Expected = 0, Actual = 0
# UVM_INFO driver.sv(96) @ 155 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @804 
#   data_in   integral       8     'he4 
#   rd        integral       1     'h1  
#   wr        integral       1     'h0  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO driver.sv(96) @ 165 ns: uvm_test_top.env.agt.driv [DRIVER] Driving Transaction:
# --------------------------------------
# Name        Type           Size  Value
# --------------------------------------
# req         fifo_seq_item  -     @812 
#   data_in   integral       8     'h99 
#   rd        integral       1     'h0  
#   wr        integral       1     'h1  
#   full      integral       1     'h0X 
#   empty     integral       1     'h0X 
#   data_out  integral       8     'h0xx
#   rst_n     integral       1     'h0X 
# --------------------------------------
# 
# UVM_INFO scoreboard.sv(142) @ 185 ns: uvm_test_top.env.scb [SCOREBOARD] PASS: Expected = 50, Actual = 50
# UVM_INFO verilog_src/uvm-1.1d/src/base/uvm_objection.svh(1267) @ 225 ns: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
# UVM_INFO scoreboard.sv(168) @ 225 ns: uvm_test_top.env.scb [SCOREBOARD] SIMULATION SUMMARY: Matches = 4, Mismatches = 0, Items left in Model = 6
# 
# --- UVM Report Summary ---
# 
# ** Report counts by severity
# UVM_INFO :   32
# UVM_WARNING :    0
# UVM_ERROR :    0
# UVM_FATAL :    0
# ** Report counts by id
# [DRIVER]    16
# [FIFO_AGENT]     1
# [FIFO_ENVIRONMENT]     1
# [FIFO_TEST]     1
# [MONITOR]     1
# [Questa UVM]     2
# [RNTST]     1
# [SCOREBOARD]     6
# [TEST_DONE]     1
# [TOPOLOGY]     1
# [UVMTOP]     1
# ** Note: $finish    : C:/questasim64_10.7c/win64/../verilog_src/uvm-1.1d/src/base/uvm_root.svh(430)
#    Time: 225 ns  Iteration: 54  Instance: /tbench_top
# 1
# Break in Task uvm_pkg/uvm_root::run_test at C:/questasim64_10.7c/win64/../verilog_src/uvm-1.1d/src/base/uvm_root.svh line 430

