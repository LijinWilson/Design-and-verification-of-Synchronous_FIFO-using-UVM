### 🎯 UVM Functional Coverage Plan (`fifo_coverage.sv`)

This verification environment uses a dedicated, 100% self-contained UVM Subscriber (`uvm_subscriber #(fifo_seq_item)`) to collect functional coverage. Rather than relying on external assertions to measure coverage, it builds a cycle-accurate internal model to track the FIFO's exact state.

Below is the breakdown of the three primary covergroups and the evaluation engine that drives them.

#### 📦 1. Data Coverage (`cg_data`)
*Guarantees that the data buses successfully transmit critical electrical extremes, but strictly only when the hardware is actually accepting the data.*

| Coverpoint | Target Bus | Enforcement Rule / Bins |
| :--- | :--- | :--- |
| **`cp_data_in`** | Write Data | Samples all-zeros (`{0}`) and all-ones (`{~0}`) **only** if the write is accepted (`tx.wr && !tx.full`). |
| **`cp_data_out`** | Read Data | Samples all-zeros (`{0}`) and all-ones (`{~0}`) **only** if the read is accepted (`tx.rd && !tx.empty`). |

#### 🎛️ 2. Control & State Coverage (`cg_ctrl`)
*Proves that every physical control pin is toggled and that the hardware traverses every possible state combination.*

| Coverpoint / Cross | Tracking Target | Description / Bins |
| :--- | :--- | :--- |
| **`cp_occupancy`** | Fill Levels | Tracks every possible internal fill level sequentially from `0` up to `DEPTH`. |
| **`cp_wr_en` / `cp_rd_en`** | Interface Requests | Explicitly checks that read and write requests transition between `idle` (0) and `req` (1). |
| **`cp_empty` / `cp_full`**| Hardware Flags | Explicitly checks that hardware boundary flags transition between `low` (0) and `high` (1). |
| **`cp_state`** | Physical State | Groups the flags into distinct states: `empty`, `mid`, and `full`. Strictly defines simultaneous full AND empty (`2'b11`) as an **illegal_bin**. |
| **`cross_req_x_state`** | The Golden Matrix | Crosses the physical state with every read and write request. This perfectly captures simultaneous RW operations, pure RW, and negative/illegal tests (like attempting to write when full). |

#### 🛡️ 3. Reset Coverage (`cg_reset`)
*Ensures the testbench properly exercises the system reset.*

| Coverpoint | Tracking Target | Description / Bins |
| :--- | :--- | :--- |
| **`cp_rst_n`** | Reset Pin | Ensures the environment witnesses both the reset assertion (`rst_assert = 0`) and the reset release (`rst_release = 1`). |

---

#### ⚙️ The Evaluation Engine (The `write()` Function)
Because the UVM Monitor cannot physically "see" inside the RTL memory array, the subscriber uses a highly efficient internal tracking mechanism to calculate coverage on the fly.

* **Reset Suspension:** If reset is active (`!t.rst_n`), the engine clears the internal occupancy tracker to `0`, samples the reset assertion, and immediately `return`s. This prevents the collection of garbage functional coverage while the hardware is in reset.
* **Accepted Operation Decoding:** It decodes true hardware behavior by calculating `wr_accepted` (write request + not full) and `rd_accepted` (read request + not empty).
* **Cycle-Accurate Occupancy Math:** At the end of every clock cycle, it updates the internal tracker using this precise formula: 
  `occupancy = occupancy + wr_accepted - rd_accepted;`
  *By adding accepted writes and subtracting accepted reads, this elegant math perfectly handles simultaneous read/write operations (+1 -1 = 0 change) and blocked requests (+0).*

  <img width="1345" height="337" alt="image" src="https://github.com/user-attachments/assets/1bab89f2-19f8-4e7b-9d1c-2c6a59f7aa30" />
