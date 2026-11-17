### 🎯 SystemVerilog Assertions (SVA) Verification Plan

This testbench employs a comprehensive suite of 18 SystemVerilog Assertions to continuously monitor both the external interface (Black-Box) and internal RTL state (White-Box). 

To make the verification plan easy to digest, the assertions are categorized by their specific defense mechanisms below.

#### 🚦 Protocol & Boundary Defenses
*Guards the FIFO against illegal interface requests and verifies external timing.*

| Assertion Name | Defense Mechanism | Enforcement Rule |
| :--- | :--- | :--- |
| **`A_NO_READ_ON_EMPTY`** | Underflow Trap | Blocks the testbench from driving `rd_en` when `empty` is active. |
| **`A_NO_WRITE_ON_FULL`** | Overflow Trap | Blocks the testbench from driving `wr_en` when `full` is active. |
| **`A_NOT_BOTH`** | Flag Mutex | Guarantees the RTL never asserts `empty` and `full` concurrently. |
| **`A_DOUT_HOLD`** | IDLE Latching | Ensures the output flop securely latches and holds `data_out` indefinitely without a read. |
| **`A_DOUT_FROM_HEAD`** | Pipeline Latency | Verifies new data travels from deep silicon to output pins exactly 1 clock cycle after a read. |

#### 🧠 Internal Pointer & Memory Math (White-Box)
*Probes deep into the silicon to verify pointer accuracy and prevent silent memory corruption.*

| Assertion Name | Defense Mechanism | Enforcement Rule |
| :--- | :--- | :--- |
| **`A_WPTR_INC`** / **`A_RPTR_INC`** | Precision Movement | Internal pointers step forward by exactly +1 *only* when a transaction is accepted. |
| **`A_WPTR_HOLD`** / **`A_RPTR_HOLD`** | Ghost Movement | Pointers hold their stable values and never move during idle states. |
| **`A_OVERFLOW_WR`** | Overwrite Protection | Protects the target write slot and pointers from corruption if a write is attempted while full. |
| **`A_UNDERFLOW_RD`** | Underflow Protection | Ensures internal pointers and `data_out` are not corrupted on a pure read from an empty FIFO. |
| **`A_UNDERFLOW_RDWR`** | Collision Protection | Maintains internal state integrity during a simultaneous illegal read and legal write from empty. |

#### 🛡️ Reset & Signal Integrity (X-Catchers)
*Ensures the hardware initializes correctly and critical signals never float to unknown states.*

| Assertion Name | Defense Mechanism | Enforcement Rule |
| :--- | :--- | :--- |
| **`A_RESET_STATE`** | Async Scrubbing | Active reset asynchronously clears both pointers and `data_out` to zero. |
| **`A_POST_RESET_EMPTY`** | Boot State | FIFO awakens correctly: `empty` starts high (1), `full` starts low (0). |
| **`A_CTRL_KNOWN`** | Control Integrity | `wr_en` and `rd_en` never float to unknown (X/Z) states during runtime. |
| **`A_WDATA_KNOWN`** | Input Integrity | `data_in` is strictly valid (no X/Z) during an accepted write. |
| **`A_FLAGS_KNOWN`** | Hardware Integrity | Internal hardware flags and pointers never float to X/Z. |
| **`A_DOUT_KNOWN`** | Output Integrity | `data_out` remains a valid 0 or 1 while the FIFO contains valid data. |

<img width="1347" height="506" alt="image" src="https://github.com/user-attachments/assets/cd4cd9c7-6eaf-4c38-9d0a-80e697e9352b" />
