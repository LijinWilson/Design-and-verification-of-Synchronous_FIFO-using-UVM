<img width="1917" height="387" alt="image" src="https://github.com/user-attachments/assets/74f0f51b-fdbc-4582-919f-b9b849eb1310" />
# Synchronous FIFO UVM Testbench - Simulation & Waveform Guide

This reference guide breaks down the functional relationship between our UVM execution log and the QuestaSim waveform capture for our Parameterized Synchronous FIFO (`fifo_SISO`) tested under `fifo_test`.

---

## 📈 Waveform & Log Correlation Guide (`fifo_test`)

### 1. Reset Initialization & De-assertion (`rst_n`)
- **Waveform (`image_b648a7.png`):** At time `0 ns`, `rst_n` starts low (asserted), holding internal write and read pointers cleanly at zero. Around `35 ns`, `rst_n` transitions high, allowing transaction flow.
- **Log Correlation:** The log shows `[SCOREBOARD] Reference FIFO cleared during reset` early on, which stops once reset de-asserts, verifying clean startup without time zero race conditions.

### 2. Write Stimulus & Datapath Flow (`wr_en`, `data_in`)
- **Waveform:** When `wr` is high and `full` is low, input data values (`'h85`, `'h13`, `'h50`, `'h99`, `'he8`) are driven on `data_in` and captured on the positive edge of `clk`[cite: 18].
- **Log Correlation:** The driver logs every transaction as it goes out to the interface (e.g., `Driving Transaction: data_in = 'h85`, `wr = 1`, `rd = 1`).

### 3. Read Verification & Pipeline Latency (`rd_en`, `data_out`)
- **Waveform:** When `rd` goes high, the requested data appears on `data_out` exactly **1 clock cycle later** due to the synchronous memory read architecture[cite: 18].
- **Log Correlation:** The scoreboard tracks this 1-cycle delay and prints explicit confirmation statements:
  ```text
  [SCOREBOARD] PASS: Expected = 85, Actual = 85
  [SCOREBOARD] PASS: Expected = 13, Actual = 13
  [SCOREBOARD] PASS: Expected = 0, Actual = 0
  [SCOREBOARD] PASS: Expected = 50, Actual = 50
