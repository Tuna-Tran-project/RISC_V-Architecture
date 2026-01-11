MODEL = MODEL_FWD_AT

# SECTION 1 — TOP-LEVEL PROCESSOR SPECIFICATION

This section defines the mandatory top-level module interface and architectural constraints that VSCode Copilot MUST implement exactly.

## 1.0 Supported Pipeline Models

This specification supports **five compliant pipeline microarchitectures**. All models share the same external ports, ISA-visible behavior, and pipeline stage boundaries. They differ only in forwarding support and branch prediction strategy.

**Model 0 — Non-Forwarding Pipeline**

* No data forwarding.
* All ALU RAW hazards stall.
* Load-use hazards stall until the value is available with no forwarding.
* No branch predictor; branches resolved in ID.

**Model 1 — Forwarding Pipeline**

* Full EX/MEM and MEM/WB forwarding.
* No stalls for ALU→ALU back-to-back operations.
* Load-use hazard: exactly 1 stall cycle.
* No branch predictor.

**Model 2 — Forwarding + Always-Taken Predictor**

* Same forwarding behavior as Model 1.
* Always predicts TAKEN for conditional branches.
* IF uses a predicted branch target PC.
* ID resolves the branch:

  * If actually taken → prediction correct, no flush.
  * If actually not-taken → mispredict → flush and redirect to PC+4.

**Model 3 — Forwarding + Two-Bit Dynamic Predictor**

* Same forwarding behavior as Model 1.
* Each static branch has a 2-bit saturating counter.
* Prediction = MSB of counter.
* Counter updates in ID when the branch is resolved.

**Model 4 — Forwarding + G-Share Predictor**

* Same forwarding behavior as Model 1.
* Uses a global history register (GHR).
* Index = PC XOR GHR into a table of 2-bit saturating counters.
* Table entry updates in ID when the branch is resolved.

### 1.0.1 Model Selection Mechanism

The **model choice is made in this specification file**, before VSCode Copilot generates any RTL.

At the very top of the spec (or in a clearly marked config block), the human author SHALL set a single line:

```text
MODEL = MODEL_FWD_AT
```

where `MODEL` MUST be exactly one of:

* `MODEL_NONFWD`     // Non-forwarding pipeline
* `MODEL_FWD`        // Forwarding pipeline
* `MODEL_FWD_AT`     // Forwarding + Always-Taken predictor
* `MODEL_FWD_2BIT`   // Forwarding + 2-bit predictor
* `MODEL_FWD_GSHARE` // Forwarding + G-share predictor

VSCode Copilot MUST:

* Read this chosen `MODEL` value from the spec.
* Implement **only that single microarchitecture** in all generated RTL.
* Hard-code the design for that model (no runtime switches).

The top-level `o_model_id` output SHALL be a fixed 4-bit constant that encodes the chosen model:

| Symbol           | Code |
| ---------------- | ---- |
| MODEL_NONFWD     | 0    |
| MODEL_FWD        | 1    |
| MODEL_FWD_AT     | 2    |
| MODEL_FWD_2BIT   | 3    |
| MODEL_FWD_GSHARE | 4    |

Example: if the spec sets `MODEL = MODEL_FWD_AT`, Copilot SHALL generate RTL equivalent to:

```systemverilog
assign o_model_id = 4'd2; // MODEL_FWD_AT
```

No parameterized multi-model RTL is allowed. The **only** variation is via this `MODEL = ...` choice in the spec that the user edits before invoking Copilot.

Later sections SHALL apply as follows:

* Section 2 (pipeline architecture): applies to **all** models.
* Section 3 (control, hazards, forwarding, predictor):

  * Forwarding rules apply to Models 1–4.
  * Forwarding is disabled for Model 0; RAW hazards stall instead.
  * Predictor rules apply only to Models 2–4; Models 0–1 have no predictor.

The top-level module serves as the root of the entire design tree, and all submodules SHALL be generated to satisfy the rules in this section.

### 1.0.2 Predictor Clarification

To eliminate previous ambiguity seen in early drafts and pseudocode templates, the normative predictor behavior for each model is restated concisely:

| Model | Name                                   | Predictor State Implemented | Tables / RAMs | History Register | 2-bit Counters | Mispredict Condition |
|-------|----------------------------------------|-----------------------------|---------------|------------------|----------------|----------------------|
| 0     | Non-Forwarding                         | None                        | None          | None             | None           | N/A (no prediction)  |
| 1     | Forwarding                             | None                        | None          | None             | None           | N/A (no prediction)  |
| 2     | FWD + Always-Taken (Static)            | Combinational TAKEN policy  | Optional BTB* | None             | None           | Actual outcome NOT-TAKEN |
| 3     | FWD + Per-Branch 2-Bit (Dynamic)       | Per-branch 2-bit counters   | BHT (array)   | None             | Yes            | Counter MSB ≠ actual outcome |
| 4     | FWD + G-Share (PC XOR GHR)             | Indexed 2-bit counters      | Pattern table | Global History   | Yes            | Counter MSB ≠ actual outcome |

Clarifications:
1. Model 2 SHALL NOT instantiate any 2-bit saturating counters. It is a purely static policy: treat every conditional branch as predicted TAKEN; redirect only when resolved NOT-TAKEN.
2. Any earlier text suggesting "Each static branch has a 2-bit saturating counter" under Model 2 is hereby superseded; that wording belongs exclusively to Model 3.
3. Optional BTB (*) for Model 2 may only store target addresses; it MUST NOT contain prediction counters.
4. Only Models 3 and 4 allocate memory arrays for prediction state (BHT or pattern table) initialized to a defined reset value (recommend weakly taken = 10₂).
5. All predictor updates (Models 3–4) occur in ID on resolution; no speculative write-back is permitted.
6. A mispredict flush logic SHALL never be gated on counter write completion; writes are side-effects after control redirection is asserted.

Normative Requirements (override any conflicting earlier draft wording):
* Model 2 RTL MUST NOT declare: reg [1:0] counter [...]; or any equivalent per-branch state structure.
* Model 3/4 RTL MUST implement 2-bit saturating counters with states: 00 (Strong NT), 01 (Weak NT), 10 (Weak T), 11 (Strong T).
* Transition rules:
  * Taken: 00→01, 01→10, 10→11, 11→11
  * Not-Taken: 11→10, 10→01, 01→00, 00→00
* Prediction output = MSB (bit[1]).

Compliance Check Hooks (recommended):
* Assert at synthesis/elaboration that `MODEL_FWD_AT` configuration yields zero 2-bit counter instances.
* For Models 3–4 expose an optional debug bus: `{pred_index, counter_value}` when `o_insn_vld && branch` for validation.

This clarification section SHALL be treated as authoritative for predictor differentiation.

---

## 1.1 Module Name

The top-level processor module SHALL be named:

```
pipelined
```

This exact name MUST be used in `/00_src/pipelined.sv`.

---

## 1.2 Formal Port List (Canonical)

The top-level module SHALL expose **exactly** the following ports. No additions, deletions, renaming, reorderings, or width changes are permitted.

### **Clock and Reset**

```
input  logic        i_clk;
input  logic        i_reset;
```

### **Frontend / Commit Program Counters**

```
output logic [31:0] o_pc_frontend; // IF stage PC
output logic [31:0] o_pc_commit;   // WB commit PC

```

### **Commit Interface**

```
output logic        o_insn_vld;  // Valid architectural commit
output logic        o_ctrl;      // Branch/jump commit
output logic        o_mispred;   // Mispredicted branch/jump commit
output logic        o_halt;      // CPU halted
output logic [3:0]  o_model_id;  // Model ID constant
```

### **I/O Interface**

```
input  logic [31:0] i_io_sw;
output logic [31:0] o_io_ledr;
output logic [31:0] o_io_ledg;
output logic [6:0]  o_io_hex0;
output logic [6:0]  o_io_hex1;
output logic [6:0]  o_io_hex2;
output logic [6:0]  o_io_hex3;
output logic [6:0]  o_io_hex4;
output logic [6:0]  o_io_hex5;
output logic [6:0]  o_io_hex6;
output logic [6:0]  o_io_hex7;
output logic [31:0] o_io_lcd;
```

---

## 1.3 Architectural Requirements

### 1.3.1 RV32I ISA Compliance

The processor SHALL implement **all RV32I base instructions** except FENCE. No CSR, exception, or trap system exists.

### 1.3.2 Register File Rules

* 32 registers x0–x31.
* `x0` always reads as 0 and discards writes.
* 2-read, 1-write ported register file.
* Writes occur synchronously in WB stage.

### 1.3.3 Commit Semantics

* Instructions commit **only** in WB.
* `o_insn_vld` asserts for **exactly one cycle per committed instruction**.
* Flushed instructions do not commit.
* `o_ctrl` asserts only for committed branch/jump.
* `o_mispred` asserts only for committed mispredict.

### 1.3.4 Program Counter Rules

* PC is 32-bit, resets to `0`.
* PC increments by +4 sequentially.
* Branch/jump update occurs only in IF.
* PC[1:0] SHALL always be `2'b00`.

---

## 1.4 Memory Map (Canonical)

This table SHALL appear here and in Section 4.

| Address Range           | Description          |
| ----------------------- | -------------------- |
| 0x0000_0000–0x0000_FFFF | 64 KiB RAM           |
| 0x1000_0000–0x1000_0FFF | LEDR output          |
| 0x1000_1000–0x1000_1FFF | LEDG output          |
| 0x1000_2000–0x1000_2FFF | HEX0–HEX3            |
| 0x1000_3000–0x1000_3FFF | HEX4–HEX7            |
| 0x1000_4000–0x1000_4FFF | LCD output           |
| 0x1001_0000–0x1001_0FFF | Switch input         |
| Others                  | Reserved (no effect) |


### I/O Timing Rules

* All I/O accesses complete in **1 cycle**.
* I/O NEVER stalls.
* Reads return device value next cycle.
* Stores take effect immediately.

---

## 1.5 Memory System (Top-Level Summary)

A complete specification is in Section 4.

Rules:

* `isa.mem` preloads IMEM and DMEM.
* IMEM fetches SHALL be word-aligned.
* DMEM allows unaligned byte/halfword, but word accesses align down.

---

## 1.6 Required Submodules

Copilot MUST generate:

* IF
* ID
* EX
* MEM (with LSU)
* WB
* Register file
* Immediate generator
* ALU
* Branch comparator
* Hazard detection unit
* Forwarding unit
* Optional BTB/predictor

All SHALL follow interfaces defined later.

---

## 1.7 PC Exposure Rules

* `o_pc_frontend` exposes IF stage PC (combinational).
* `o_pc_commit` exposes WB commit PC (sequential).
* `o_pc_commit` updates only on `o_insn_vld`.

---

## 1.8 Output Reset Rules

All outputs SHALL initialize to zero at hardware reset.

Seven-segment outputs use **active-low** polarity.

---

## 1.9 Halt Behavior

Halt occurs when CPU stores to `32'hFFFF_FFFC`.

Rules:

* Immediately flush in-flight instructions.
* Freeze pipeline after flush.
* Stop PC update.
* Stop instruction commit.
* Stop performance counters.
* `o_halt` remains high.
* All I/O becomes read-only.

---

## 1.10 Performance Counters

Counters (cycle, retired, stall, mispred) are:

* 32-bit
* Read-only
* Reset to zero
* Located at `0x1002_0000`–`0x1002_000F`
* Cleared by writing to `0x1002_0010`

---

## 1.11 Instruction Counting Rules

Counts as retired:

* Any valid instruction in WB.
* Real NOP.

Does NOT count:

* Bubbles
* Flushed instructions
* Illegal fetches
* Wrong-path instructions

---

## 1.12 Internal Signal Naming Rules

* `r_` = registers/state
* `s_` = combinational
* `w_` = intermediate nets
* Pipeline regs use `if_id_*`, `id_ex_*`, etc.

Copilot MUST use these prefixes consistently.

---

## 1.13 Strict Memory Error Rules

* Misaligned word accesses align down.
* Misaligned byte/halfword allowed.
* Loads from unmapped → 0.
* Stores to unmapped → ignored.
* No traps or exceptions.

---

## 1.14 Switch Input Synchronization

`i_io_sw` SHALL be registered once before use.
Reads return the registered value.

---

## 1.15 Final Lock-In Rule

If ANY RTL generated by Copilot violates ANY part of Section 1:

* It is considered a **bug**.
* Copilot MUST correct the RTL.
* No alternate implementation is allowed.

---

## 1.16 Rationale Notes (Informative)

These notes help Copilot understand **why** key rules exist.

* **Fixed port list**: Prevents Copilot from inventing incompatible interfaces.
* **Strict memory map**: Ensures stable decode and correct LSU logic.
* **Active-low HEX displays**: Matches DE-series hardware; avoids polarity bugs.
* **Always-aligned PC**: Eliminates compressed ISA and misaligned fetch complexity.
* **I/O non-stalling**: Guarantees forward progress and predictable timing.
* **Halt behavior**: Required by tester framework; ensures simulation stop.
* **Performance counters**: Used by benchmarking harness; must be deterministic.

## 1.17 Forbidden Implementation Patterns

Copilot MUST NOT generate any of the following:

1. **Dynamic port bundles**, interfaces, or structs at top level.
2. **Multiple pipeline clocks** or gated clocks outside HALT mode.
3. **Asynchronous memory models** for IMEM or DMEM.
4. **Combinational feedback paths across stages**.
5. **Multi-cycle ALU, divider, multiplier, or iterative units**.
6. **Exceptions, traps, CSR system**, or unrequested privilege logic.
7. **Implicit latches** due to incomplete combinational blocks.
8. **Behavioral delays** (`#`, `wait`, `fork`, etc.).
9. **Implicit X-propagation** (all bubbles and resets must be zeroed).
10. **Instruction fetch from I/O regions** (must flush instead).

---

# SECTION 2 — PIPELINE ARCHITECTURE SPECIFICATION

---

## 2.1 Pipeline Stage Overview

The processor SHALL implement exactly 5 stages, in order:

1. **IF** — Instruction Fetch
2. **ID** — Decode & Register Read
3. **EX** — Execute & ALU
4. **MEM** — Data Memory / LSU
5. **WB** — Writeback & Commit

Each stage SHALL have:

* Precisely defined inputs and outputs
* Deterministic stall and flush semantics
* Exactly one pipeline register between stages
* No multi-cycle execution units

---

## 2.2 Global Pipeline Rules

1. The pipeline SHALL NEVER have combinational loops.
2. All stages SHALL be separated by sequential pipeline registers.
3. All pipeline registers SHALL initialize to zero on reset.
4. All bubble fields SHALL be zero or NOP-equivalent.
5. All control-bundle bits SHALL update atomically.
6. DMEM and IMEM SHALL NEVER stall.
7. All instructions SHALL be 32-bit; RV32C compressed ISA is forbidden.
8. PC SHALL always remain aligned: `PC[1:0] = 2'b00`.

---

## 2.3 Stage Boundaries & Timing

* **IF:** PC register + combinational address calculation + IMEM synchronous read.
* **ID:** Fully combinational decode logic + register file read.
* **EX:** Fully combinational ALU + compare unit.
* **MEM:** Synchronous read/write memory access.
* **WB:** Synchronous register file write.

ALU and branch compare SHALL be combinational and complete within one cycle.

---

## 2.4 IF Stage Requirements

### Inputs

* `r_pc`
* `pc_next`
* `stall_if`
* `flush_if`

### Outputs

* `instr_f` (or bubble)
* `pc_plus4 = r_pc + 4`

### Rules

1. IF SHALL compute `pc_plus4` every cycle regardless of stall or flush.
2. On `stall_if = 1`: PC stays frozen; IMEM not accessed; output bubble.
3. On `flush_if = 1`: discard fresh fetch; output a bubble.
4. PC update SHALL occur **before** IF/ID register update.
5. Fetches from I/O region SHALL trigger immediate flush.
6. Illegal instruction fetched from IMEM SHALL trigger pipeline flush.

---

## 2.5 IF/ID Pipeline Register Requirements

IF/ID SHALL store:

* `if_id_pc`
* `if_id_instr`
* Bubble flag via control-bundle = 0

On flush:

* All fields SHALL be zeroed.
* PC may be preserved.

On stall:

* IF/ID holds its previous value.

---

## 2.6 ID Stage Requirements

ID SHALL be purely combinational.

### Responsibilities

1. Decode instruction fields.
2. Generate all control bits.
3. Read register file operands.
4. Compute branch decision.
5. Compute branch target using dedicated adder.
6. Perform RAW hazard detection.
7. Initiate stalls or flushes as needed.

### RAW Hazard Inputs

ID SHALL compare rs1/rs2 against:

* `id_ex_rd` (with rd_wen)
* `ex_mem_rd` (with rd_wen)
* `mem_wb_rd` (with rd_wen)

### Forwarding Into ID

Branch compare MUST use forwarded operands.

### Branch Resolution

* Branch decision AND branch target computation occur in ID.
* ID decision ALWAYS overrides predictor.

---

## 2.7 ID/EX Pipeline Register Requirements

Fields SHALL include at minimum:

* `pc`
* `rs1_val`, `rs2_val`, `imm`
* `rd`, `rs1`, `rs2`
* ALU control
* Memory control
* Branch control
* Bubble flag

On flush → bubble.
On stall → hold.

---

## 2.8 EX Stage Requirements

### Responsibilities

1. ALU operations (ADD, SUB, AND, OR, XOR, SLT, SLTU, SLL, SRL, SRA).
2. Structural comparator logic.
3. Produce deterministic output on bubble.
4. Forwarding unit feeds ALU inputs.

### Forwarding Priority

If both EX/MEM and MEM/WB match rd:

* Prefer EX/MEM.

### ALU Timing

* ALU SHALL be purely combinational.
* ALU result SHALL stabilize by end of cycle.
* EX SHALL never stall.

### EX Bubble Behavior

If EX receives bubble:

* Output ALU result = 0.
* Comparator outputs = 0.
* Control outputs = bubble.

---

## 2.9 EX/MEM Pipeline Register Requirements

Fields SHALL include:

* `pc`
* ALU result
* Store data
* Control bundle
* Destination register index
* Bubble flag

On flush → bubble.
On stall → hold.

---

## 2.10 MEM Stage Requirements

### Responsibilities

1. Perform synchronous DMEM read/write.
2. Apply correct store masking via byte strobes.
3. Enforce alignment rules in MEM.
4. Prohibit memory stalls.
5. Perform LSU store-to-load forwarding.
6. Never issue DMEM access on bubble.

### DMEM Read Data Timing

* DMEM read data SHALL be valid at the end of the MEM cycle.

### Store→Load Forwarding

* If a load in MEM reads the same address as a store issued in the same cycle:
  LSU SHALL forward store data directly, bypassing DMEM.

---

## 2.11 MEM/WB Pipeline Register Requirements

Fields SHALL include:

* `pc`
* ALU result
* DMEM read data
* Control bundle
* `rd`
* Bubble flag

On flush → bubble.
On stall → hold.

---

## 2.12 WB Stage Requirements

WB SHALL:

1. Write back to register file synchronously.
2. Assert `o_insn_vld` ONLY for non-bubble instructions.
3. Preserve ordering: older commits ALWAYS retire.
4. Commit even during flush if instruction is older.
5. Enforce two safeguards before writeback:

   * bubble flag = 0
   * rd_wen = 1
6. Perform sign extension for all load instructions.
7. Update performance counters.
8. Drive commit PC.

### Bubble Semantics in WB

* Bubble SHALL NEVER write a register.
* Bubble SHALL NEVER assert `o_insn_vld`.
* Bubble SHALL NOT increment performance counters.

### Real NOP vs Bubble

* Real NOP fetched from memory → counts as real retired instruction.
* Internal bubble → NOT retired.

---

## 2.13 Global Stall & Flush Priority Rules

### Priority Ordering

1. **Flush dominates everything** (stall signals MUST be ignored).
2. Stall applies only if flush is not asserted.
3. ID stall triggers IF stall.
4. IF stall does NOT propagate downward.

### Multi-Condition Cases

* Flush + load-use stall → flush wins.
* Flush + illegal instruction → flush wins.
* Branch resolution flush SHALL override predictor.

---

## 2.14 Illegal Instruction and Illegal PC Handling

### Illegal Instruction

If IF decodes illegal opcode:

* Flush IF & ID immediately.
* Replace pipeline contents with bubbles.

### Illegal PC

If redirect logic produces misaligned PC:

* Flush pipeline.
* Replace with aligned PC.

---

## 2.15 Debug Visibility Requirements

Each stage SHALL expose internal debug taps:

* Stage instruction
* Stage PC
* Control bundle snapshot
* Operand values
* Bubble flag
* Debug-only signals (e.g., `ex_branch_taken_raw`, `ex_alu_overflow`)

These taps SHALL NOT affect functionality.

---

## 2.16 Gated Clock Policy

* Gated clocks are forbidden everywhere except HALT mode.
* Only a single global clock gate MAY be used during HALT.

---

# SECTION 3 — PIPELINE CONTROL, HAZARD MANAGEMENT, STALLS, FLUSHES, FORWARDING, AND PREDICTOR INTERACTION

This section SHALL be treated as the authoritative specification for pipeline control logic used in all 5 supported models (0–4). All implementations generated by Copilot MUST obey these rules exactly.

---

## 3.1 Scope

Section 3 defines the complete runtime control-flow architecture of the RV32I Milestone-3 pipeline:

* Unified control bundle definition
* Pipeline control states
* Hazard Detection Unit (HDU)
* Forwarding Unit
* Stall behavior
* Flush & kill priority rules
* Branch resolution and mispredict behavior
* Predictor interaction (Models 2–4 only)
* Illegal instruction handling
* Per-stage stall/flush tables
* Pseudo-code templates for pipeline registers
* Assertions and x0 enforcement

These rules are **architecturally binding** on all models.

---

## 3.2 Unified Control Bundle

A unified control-bundle SHALL propagate from **ID → EX → MEM → WB**. All fields SHALL update **atomically** every cycle. All control registers SHALL reset to **0**.

### 3.2.1 Fields

Core flags:

* `ctrl_valid` — real instruction
* `ctrl_bubble` — internally inserted bubble
* `ctrl_kill` — invalidated by flush/illegal/mispredict

Functional groups:

* Branch/Jump: `ctrl_branch`, `ctrl_jump`
* ALU: `ctrl_alu_op`
* Memory: `ctrl_mem_read`, `ctrl_mem_write`
* Writeback: `ctrl_wb_en`

### 3.2.2 Semantics

* If `ctrl_valid=0`, it SHALL remain 0 downstream.
* `ctrl_bubble=1` SHALL zero ALU/MEM/WB fields.
* `ctrl_kill=1` SHALL NOT propagate past EX (converted to bubble at EX/MEM).
* Illegal instructions in ID SHALL set `ctrl_kill=1`.
* The combination `ctrl_valid=1` with `ctrl_bubble=1` or `ctrl_kill=1` is **illegal** and MUST assert.

---

## 3.3 Hazard Detection Unit (HDU)

The HDU SHALL detect:

1. RAW hazards
2. Load-use hazards
3. Branch hazards
4. Structural hazards (forbidden)

### 3.3.1 RAW Hazards

RAW logic compares ID.rs1/rs2 against:

* ID/EX.rd
* EX/MEM.rd
* MEM/WB.rd

Bubble/killed instructions SHALL behave as `rd=0`.

HDU produces:

* `haz_rs1`
* `haz_rs2`
* `stall_raw = haz_rs1 | haz_rs2`

### 3.3.2 Load-Use Hazard

If ID needs rd from a load currently in EX:

* Stall exactly **one** cycle.
* If EX instruction is killed → stall suppressed.

### 3.3.3 Branch Hazard

Branches in ID SHALL stall **one cycle** if the branch depends on an EX load.

### 3.3.4 Structural Hazards

Structural hazards are **forbidden**.
`stall_structural` MUST always equal `1'b0`.

---

## 3.4 Forwarding Unit

Forwarding feeds:

* EX operands (ALU)
* ID operands (branch comparator)

### 3.4.1 Priority

1. EX/MEM
2. MEM/WB
3. Register file

### 3.4.2 Selectors

* `forward_a_sel[1:0]`
* `forward_b_sel[1:0]`

Encoding:

| Sel | Source |
| --- | ------ |
| 00  | RF     |
| 01  | MEM/WB |
| 10  | EX/MEM |

### 3.4.3 Branch Forwarding Rules

Branch comparator forwarding follows the same priority as EX.

### 3.4.4 Forwarding Tables

#### EX operand forwarding:

| Condition                             | Source |
| ------------------------------------- | ------ |
| EX/MEM.rd == ID/EX.rsX & EX/MEM.valid | EX/MEM |
| MEM/WB.rd == ID/EX.rsX & MEM/WB.valid | MEM/WB |
| Otherwise                             | RF     |

Branch forwarding uses the same rules but applies in ID.

---

## 3.5 Stall Logic

```
stall = stall_raw | stall_load_use | stall_branch | stall_other;
```

Flush overrides all stalls.

### 3.5.1 Bubbles Do NOT Stall

Bubble instructions SHALL NOT generate stalls.

### 3.5.2 Kill Priority

Kill > Bubble.

* Kill applies to ID/EX and EX/MEM.
* Kill becomes bubble by MEM/WB.

---

## 3.6 Flush, Redirect, Mispredict

### 3.6.1 Flush Timing

On mispredict or kill from ID:

* Redirect PC **in the same cycle** before IF/ID writes.
* Flush IF, ID, and EX pipeline stages.

### 3.6.2 Store Behavior Under Flush

* Older store commits.
* Younger store canceled.

### 3.6.3 Priority

1. **Flush**
2. **Kill**
3. **Stall**
4. **Normal Operation**

---

## 3.7 Control States

| State  | ctrl_valid | ctrl_bubble | ctrl_kill |
| ------ | ---------- | ----------- | --------- |
| NORMAL | 1          | 0           | 0         |
| BUBBLE | 0          | 1           | 0         |
| KILL   | 0          | 0           | 1         |

Any other combination is illegal → treat as flush + assert.

---

## 3.8 PC Update

* Stall → PC holds.
* Bubble insertion → PC increments normally.
* Kill without flush → PC increments normally.
* Flush → PC redirects before IF/ID.

---

## 3.9 Per-Stage Stall/Flush Table

| Event | IF/ID  | ID/EX  | EX/MEM      | MEM/WB    |
| ----- | ------ | ------ | ----------- | --------- |
| Stall | Hold   | Hold   | No change   | No change |
| Flush | Bubble | Bubble | Bubble      | No change |
| Kill  | Bubble | Bubble | Kill→Bubble | Bubble    |

Flush dominates stall.

---

## 3.10 Pipeline Register Pseudo-Code

### 3.10.1 IF Stage

*(Defined fully in Section 5 — not duplicated here.)*

### 3.10.2 ID/EX Register

*(Defined fully in Section 6.)*

### 3.10.3 EX/MEM Register

```sv
if (flush) begin
  ex_mem_ctrl_valid  = 1'b0;
  ex_mem_ctrl_bubble = 1'b1;
end
else if (stall) begin
  // hold EX/MEM contents
end
else begin
  ex_mem_ctrl_valid  = id_ex_ctrl_valid;
  ex_mem_ctrl_bubble = id_ex_ctrl_bubble;
  ex_mem_ctrl_kill   = id_ex_ctrl_kill;
end
```

### 3.10.4 MEM/WB Register

```sv
if (flush) begin
  mem_wb_ctrl_valid  = 1'b0;
  mem_wb_ctrl_bubble = 1'b1;
end
else begin
  mem_wb_ctrl_valid  = ex_mem_ctrl_valid;
  mem_wb_ctrl_bubble = ex_mem_ctrl_bubble;
end
```

---

## 3.11 Illegal Instruction Handling

Illegal instructions SHALL:

* Set `ctrl_kill=1` in ID
* Become bubbles at EX/MEM
* Flush IF/ID/EX when needed

---

## 3.12 Predictor Interaction (Models 2–4 Only)

Predictor MUST NOT stall pipeline.

### 3.12.1 Reset Behavior

* **Model 3 & Model 4**: predictor state (2-bit counters, GHR) resets to **strongly not-taken**.
* **Model 2**: Always-Taken predictor has **no state**, this rule does NOT apply.

### 3.12.2 Flush Behavior

Flush does **NOT** reset predictor.

### 3.12.3 Update Behavior

Predictor updates occur only in **ID**, using the actual branch outcome (`taken` or `not taken`).

* **Model 2 — Always-Taken**: No update; predictor has no counters or GHR.
* **Model 3 — Two-Bit Dynamic**: Update 2-bit counter for the branch PC index.
* **Model 4 — G-Share**: Update 2-bit counter and shift actual outcome into GHR.

---

## 3.13 Register x0 Enforcement

Register x0 MUST NEVER be written.

Required assertion (for simulation only):

```sv
assert(!(rd_wen && rd == 5'd0));
```

---

## 3.14 Recommended Assertions

In addition to x0 enforcement, the following assertions are recommended:

```sv
assert(!(ctrl_valid && ctrl_bubble));
assert(!(ctrl_valid && ctrl_kill));
assert(!(ctrl_bubble && ctrl_kill));
```

* Assert no DMEM writes when `ctrl_valid=0`.
* Assert no structural stall (`stall_structural` MUST always be 0).
* Assert forwarding does not produce illegal selector values.
* Assert pipeline registers do not contain X-values.

---

## 3.15 Model-Specific Clarifications (Binding)

These rules override general behavior **per model**.

### Model 0 — Non-Forwarding

* Forwarding unit instantiated but disabled.
* `forward_{a,b}_sel = 2'b00` always.
* RAW ALU→ALU hazards stall.
* Load-use stalls until RF writeback.
* Branch comparator receives **no forwarded operands**.
* Predictor disabled.

### Model 1 — Forwarding

* Full EX/MEM and MEM/WB forwarding enabled.
* RAW ALU→ALU hazards do NOT stall.
* Load-use stalls exactly one cycle.
* Branch comparator uses forwarding.
* Predictor disabled.

### Model 2 — Forwarding + Always-Taken

* Forwarding rules same as Model 1.
* Predictor always predicts **TAKEN** for conditional branches.
* Mispredict only when actual outcome is NOT-TAKEN.
* Predictor MUST NOT stall.

### Model 3 — Forwarding + Two-Bit Dynamic

* Forwarding rules same as Model 1.
* 2-bit saturating counters required.
* Prediction = MSB of counter.
* Counter updated in ID.
* Optional BTB allowed.

### Model 4 — Forwarding + G-Share

* Forwarding rules same as Model 1.
* Requires GHR and 2-bit table.
* Index = PC XOR GHR.
* Update in ID.
* Predictor MUST NOT stall.

---

# SECTION 4 — PIPELINE REGISTERS AND INTER-STAGE INTERFACES

This section defines **all pipeline register structures**, **all inter-stage signal bundles**, and the **exact update semantics** for every pipeline boundary in the Milestone-3 RV32I pipeline. Copilot MUST implement every rule in this section exactly as written. No deviations or inferred behavior are permitted.

---

## 4.1 Overview

The processor SHALL instantiate **exactly four** architectural pipeline registers:

1. **IF/ID** — Fetch → Decode
2. **ID/EX** — Decode → Execute
3. **EX/MEM** — Execute → Memory
4. **MEM/WB** — Memory → Writeback

All four pipeline registers SHALL:

* Update only on `posedge i_clk`.
* Reset synchronously to **all zeros** (interpreted as bubbles).
* Obey the global priority: **Flush > Kill > Stall > Normal**.
* Never contain X or undefined values.
* Never infer latches.
* Use mandatory name prefixes: `if_id_`, `id_ex_`, `ex_mem_`, `mem_wb_`.

---

## 4.2 IF/ID Pipeline Register

### 4.2.1 IF/ID Fields

The IF/ID register SHALL contain at minimum:

* `if_id_pc         : logic [31:0]` — fetch PC
* `if_id_instr      : logic [31:0]` — fetched instruction word
* `if_id_ctrl_valid : logic`       — control valid flag
* `if_id_ctrl_bubble: logic`       — bubble flag
* `if_id_ctrl_kill  : logic`       — kill flag

### 4.2.2 IF/ID Update Rules

* **Reset**: all fields = 0; interpreted as a bubble.
* **Flush**: IF/ID becomes a bubble; `if_id_pc = 32'b0`, `if_id_instr = 32'b0`, control = BUBBLE.
* **Stall**: IF/ID holds its previous contents (no change).
* **Normal**: Captures new PC and instruction from IF stage.

---

## 4.3 ID/EX Pipeline Register

### 4.3.1 ID/EX Fields

The ID/EX register SHALL contain:

* `id_ex_pc         : logic [31:0]`
* `id_ex_rs1_val    : logic [31:0]`
* `id_ex_rs2_val    : logic [31:0]`
* `id_ex_rs1        : logic [4:0]`
* `id_ex_rs2        : logic [4:0]`
* `id_ex_rd         : logic [4:0]`
* `id_ex_imm        : logic [31:0]`
* Full control bundle signals with prefix `id_ex_ctrl_*`

ALU operation (`ctrl_alu_op`) SHALL be carried **inside** the control bundle, not as a separate field.

### 4.3.2 ID/EX Update Rules

* **Reset**: all fields = 0; interpreted as bubble.
* **Flush**: set `id_ex_ctrl_valid=0`, `id_ex_ctrl_bubble=1`, zero all side-effecting fields.
* **Stall**: hold previous ID/EX values.
* **Normal**: capture outputs from ID stage.

---

## 4.4 EX/MEM Pipeline Register

### 4.4.1 EX/MEM Fields

The EX/MEM register SHALL contain:

* `ex_mem_pc         : logic [31:0]`
* `ex_mem_alu_result : logic [31:0]`
* `ex_mem_store_data : logic [31:0]` — already forwarded store value
* `ex_mem_rd         : logic [4:0]`
* Full control bundle signals with prefix `ex_mem_ctrl_*`

### 4.4.2 EX/MEM Update Rules

* **Reset**: all fields = 0; interpreted as bubble.
* **Flush**: bubble (`ex_mem_ctrl_valid=0`, `ex_mem_ctrl_bubble=1`).
* **Stall**: EX/MEM holds previous contents.
* **Normal**: capture outputs from EX stage, including forwarded store data.

---

## 4.5 MEM/WB Pipeline Register

### 4.5.1 MEM/WB Fields

The MEM/WB register SHALL contain:

* `mem_wb_pc          : logic [31:0]`
* `mem_wb_rdata       : logic [31:0]`
* `mem_wb_alu_result  : logic [31:0]`
* `mem_wb_rd          : logic [4:0]`
* `mem_wb_addr        : logic [31:0]` (optional debug: effective address)
* Full control bundle signals with prefix `mem_wb_ctrl_*`

### 4.5.2 MEM/WB Update Rules

* **Reset**: all fields = 0; interpreted as bubble.
* **Flush**: bubble (`mem_wb_ctrl_valid=0`, `mem_wb_ctrl_bubble=1`).
* **Normal**: capture outputs from MEM stage; WB does not generate stalls.

---

## 4.6 Inter-Stage Interface Requirements

Copilot MUST ensure:

* All operand values are stable before being latched by the next stage.
* Register indices (`*_rs1`, `*_rs2`, `*_rd`) remain unchanged across stages.
* Control bundle fields propagate unchanged except when modified by flush/kill.
* Bubbles MUST clear all side-effecting control signals (no writes, no memory access).

---

## 4.7 Reset Behavior

All pipeline registers SHALL:

* Reset synchronously to `0` at `i_reset`.
* Represent bubbles in all stages immediately after reset.

---

# SECTION 5 — INSTRUCTION FETCH (IF) STAGE AND IMEM INTERFACE

This section defines the **Instruction Fetch (IF) stage**, the **Program Counter (PC) generation rules**, and the **interface to the instruction memory (IMEM)**. Copilot MUST implement all IF logic and IMEM access exactly as specified here and in the memory system sections.

---

## 5.1 IF Stage Responsibilities

The IF stage SHALL:

* Maintain the **fetch PC register**.
* Generate `pc_plus4 = r_pc + 32'd4` on every cycle.
* Drive the IMEM address port with the current PC.
* Provide `o_pc_frontend` equal to the current fetch PC.
* Cooperate with the branch/predictor logic to select the next PC.
* Obey stall and flush/redirect rules defined in Section 3.

The PC register SHALL reside inside the IF stage and update only on the rising edge of `i_clk`.

---

## 5.2 PC Reset and Sequential Update Rules

### 5.2.1 PC Reset Value

On reset, the PC register (`r_pc`) SHALL be set to a configurable constant:

```systemverilog
localparam logic [31:0] RESET_PC = 32'h0000_0000; // example
```

Copilot MAY change `RESET_PC` only if the test environment explicitly requires a different reset address. Otherwise, `RESET_PC` MUST remain `32'h0000_0000`.

### 5.2.2 Sequential PC Increment

For sequential execution with no taken branch, no mispredict, and no flush, the PC SHALL update as:

```text
pc_next = r_pc + 32'd4
```

No other stride or increment size is allowed.

### 5.2.3 Stall Behavior

When `stall_if = 1` (from hazard/control logic):

* `r_pc` SHALL **hold its current value**.
* No new IMEM address SHALL be issued (the same address may be re-driven).

### 5.2.4 Flush / Redirect Behavior

When `flush = 1` and a redirect PC (`redirect_pc`) is supplied from ID:

* `r_pc` SHALL load `redirect_pc` **immediately in the same cycle**, before IF/ID update.
* Any in-flight instruction at the old PC IS considered flushed and MUST NOT commit.

---

## 5.3 IMEM Interface and Timing

### 5.3.1 IMEM Address and Data

The IF stage SHALL drive:

* `imem_addr : logic [31:0]` — byte address of instruction fetch (PC)
* `imem_req  : logic`        — request valid (optional, see handshake)

IMEM SHALL return:

* `imem_rdata : logic [31:0]` — instruction word
* `imem_valid : logic`         — data valid (optional handshake)

### 5.3.2 IMEM Access Width and Alignment

* IF SHALL always access IMEM as a **32-bit word**, aligned to 4 bytes.
* `r_pc[1:0]` MUST be `2'b00` at all times in legal operation.
* IMEM SHALL ignore `imem_addr[1:0]` (word aligned).

### 5.3.3 IMEM Timing

IMEM is synchronous read with 1-cycle latency:

* IF drives `imem_addr` in cycle N.
* `imem_rdata` becomes valid in cycle N+1.

### 5.3.4 IMEM Ready/Valid Handshake (Optional)

If the implementation chooses to model wait states or external memory:

* `imem_req` and `imem_valid` MAY be implemented.
* IF MUST treat `imem_valid=0` as a stall source for IF/ID.

By default, for the Milestone-3 core:

* IMEM is assumed **always ready** (`imem_valid=1` every cycle after a request).
* No IMEM-caused stalls SHALL occur in the baseline core.

---

## 5.4 Interaction with Branch Predictor and Redirect Logic

### 5.4.1 Next PC Selection

In models with prediction (Models 2–4), IF SHALL select between:

* `pc_plus4` (sequential PC), and
* `pc_pred` (predicted PC from the branch predictor/BTB).

The selection rule:

* If predictor provides `pc_pred_valid=1` → use `pc_pred`.
* Otherwise → use `pc_plus4`.

### 5.4.2 Branch Target Sources

Predictor MAY provide a predicted target from:

* A Branch Target Buffer (BTB), or
* A simple stored target per branch.

ID SHALL resolve the actual branch outcome and target. On mismatch:

* ID asserts `mispredict`.
* IF receives `redirect_pc` from ID.
* IF loads `redirect_pc` into `r_pc` in the same cycle (see 5.2.3).

### 5.4.3 Non-Predictor Models

For Models 0 and 1 (no predictor):

* IF SHALL always use `pc_plus4` unless redirected by a taken branch in ID.
* No `pc_pred` is ever used.

---

## 5.5 o_pc_frontend and IF/ID Consistency

### 5.5.1 o_pc_frontend Source

The top-level `o_pc_frontend` output SHALL be driven as:

* `o_pc_frontend = r_pc;`

That is, it always exposes the **current IF stage PC**, i.e., the address used to fetch the instruction from IMEM.

### 5.5.2 Relationship to if_id_pc

Section 4 defines `if_id_pc`. The following relationship SHALL hold:

* `if_id_pc` = `o_pc_frontend` delayed by exactly **one** cycle in the absence of flush/stall.

When stalls or flushes are active, `if_id_pc` SHALL reflect the held or bubbled contents of IF/ID exactly as specified in Section 4 and Section 3.

---

## 5.6 Illegal Fetch and Alignment Rules

### 5.6.1 Illegal PC Regions

If `r_pc` points into an address range mapped to I/O or unmapped memory (see Section 1 memory map):

* IF MUST NOT issue a normal IMEM read.
* Instead, IF SHALL treat this as an **illegal instruction fetch**.
* IF SHALL inject an illegal instruction indication into the pipeline, which triggers a flush in ID according to Section 3.

### 5.6.2 Misaligned PC

If `r_pc[1:0] != 2'b00` at any time:

* This SHALL be treated as an illegal fetch.
* The pipeline SHALL flush, and the offending instruction MUST NOT commit.

---

## 5.7 IF Internal State and Implementation Constraints

The IF stage SHALL contain at minimum:

* A PC register: `r_pc : logic [31:0]`.
* Combinational logic to compute:

  * `pc_plus4 = r_pc + 32'd4`.
  * `pc_next` selected from {`pc_plus4`, `pc_pred`, `redirect_pc`} according to Section 3 and Section 5 rules.
* Output logic to drive:

  * `imem_addr` from `r_pc`.
  * `o_pc_frontend` from `r_pc`.

The IF stage MAY additionally contain:

* Predictor metadata RAMs or tables.
* A Branch Target Buffer (BTB) for predicted targets.
* A Global History Register (GHR) and related logic (for G-share models).

Implementation constraints:

* No extra pipeline stage may be inserted between IF and ID; IF/ID is the only architectural boundary.
* No combinational loop may exist between IF and any other stage.
* All additional predictor/BTB/GHR state MUST obey the same clock and reset discipline as the rest of the pipeline.

---

## 5.8 Per-Model IF Behavior Clarifications

Although Section 5 is written as a unified specification for all models, Copilot MUST specialize the IF behavior according to the chosen `MODEL` from Section 1.

### 5.8.1 Model 0 — Non-Forwarding Pipeline

* Predictor is **disabled**.
* IF always uses `pc_plus4` unless redirected by ID (`redirect_pc`).
* No BTB, predictor RAMs, or GHR may be instantiated.
* Illegal fetch and misaligned PC rules apply as in 5.6.

### 5.8.2 Model 1 — Forwarding Pipeline

* IF behavior is identical to Model 0.
* No branch predictor is present.
* PC selection is strictly between `pc_plus4` and `redirect_pc`.

### 5.8.3 Model 2 — Forwarding + Always-Taken Predictor

* Forwarding rules apply as defined in Section 3.
* Conceptually, the predictor always predicts TAKEN for conditional branches.
* Implementation MAY:

  * Use a BTB indexed by `r_pc` to fetch predicted targets, or
  * Rely on ID to compute the target and treat "Always-Taken" as a logical policy with redirection.
* Mispredict occurs whenever the actual outcome is NOT-TAKEN.

### 5.8.4 Model 3 — Forwarding + Two-Bit Dynamic Predictor

* Predictor SHALL maintain a 2-bit saturating counter per branch entry.
* Indexing MAY use `r_pc[??:2]` (implementation-defined index bits), but MUST be stable.
* Prediction = MSB of the 2-bit counter.
* IF uses `pc_pred` from this predictor when `pc_pred_valid=1`.
* Counter update occurs in ID when the branch resolves.

### 5.8.5 Model 4 — Forwarding + G-Share Dynamic Predictor

* Predictor SHALL maintain a Global History Register (GHR).
* Predictor table index SHALL be computed as `index = (r_pc >> 2) XOR GHR` (or equivalent bit selection documented in the RTL).
* Each table entry SHALL be a 2-bit saturating counter.
* Prediction = MSB of the selected counter.
* IF uses `pc_pred` when `pc_pred_valid=1`.
* GHR and counter update occur in ID when actual branch outcome is known.

---

# SECTION 6 — INSTRUCTION DECODE (ID), REGISTER FILE, AND IMMEDIATE GENERATOR

This section defines the **Instruction Decode (ID) stage**, the **Register File (RF)**, and the **Immediate Generator (ImmGen)**. All decode behavior, operand sourcing, control-bundle formation, and RF semantics are normative constraints that Copilot MUST follow exactly.

---

## 6.1 Overview of ID Stage Responsibilities

The ID stage SHALL perform all of the following **in a single cycle**, entirely combinational:

1. Decode the fetched instruction.
2. Read register operands from the Register File.
3. Apply forwarding for **branch operands** (only).
4. Generate all immediates (ImmGen).
5. Compute ALU control operation.
6. Compute branch/jump target addresses.
7. Resolve branch conditions (branch decision occurs in ID).
8. Produce the **complete control bundle** for EX/MEM/WB.
9. Populate the ID/EX pipeline register.

ID MUST NOT insert additional cycles or stages.

If the IF/ID entry is a bubble or kill (`if_id_ctrl_valid=0`), ID SHALL:

* Treat the instruction as **non-existent**.
* Drive the ID/EX control bundle as a BUBBLE (no side effects).
* Force branch decision to "not taken".

---

## 6.2 Register File Specification

### 6.2.1 Ports and Structure

The register file SHALL implement:

* **32 registers**, x0–x31.
* **2 combinational read ports**:

  * `rf_rdata1 = RF[rs1]`
  * `rf_rdata2 = RF[rs2]`
* **1 synchronous write port**, written in WB:

  * `RF[rd] <= wb_write_data` on `posedge i_clk`

### 6.2.2 x0 Hardwiring

* Reads from x0 **always return 0**.
* Writes to x0 **are ignored**.
* RF implementation MUST guarantee this without special-case logic in ID.

### 6.2.3 Read Timing

* RF reads MUST be **purely combinational**.
* Values for rs1/rs2 MUST be valid in the **same cycle** decode occurs.
* This is required for branch decision in ID.

### 6.2.4 Write Timing

* Writes occur only in **WB stage**, exactly once per committed instruction.
* Forwarding/bypass logic MUST NOT modify RF contents; RF is only written in WB.

---

## 6.3 Immediate Generator (ImmGen)

### 6.3.1 Implementation Style

ImmGen SHALL be implemented as a **separate combinational module**, instantiated inside ID.

### 6.3.2 Supported Formats

ImmGen MUST generate immediates for all RV32I formats:

* I-type
* S-type
* B-type
* U-type
* J-type
* Load immediates (same as I-type)

### 6.3.3 Functional Requirements

ImmGen SHALL:

* Perform **sign extension** to 32 bits.
* Produce the correct immediate based solely on instruction bits.
* Operate combinationally with no clocked state.

For bubbles/killed instructions (`if_id_ctrl_valid=0`), ID SHALL either:

* Bypass ImmGen entirely and force `id_ex_imm = 32'b0`, or
* Ensure ImmGen output is ignored by downstream bubble control.

---

## 6.4 Branch Decision and Target Computation

### 6.4.1 Branch Comparison

ID SHALL evaluate branch conditions using a **branch comparator module**:

* Inputs: branch operands after branch-only forwarding.
* Output: `branch_taken` (1/0).

Comparison operations include:

* BEQ, BNE
* BLT, BGE
* BLTU, BGEU

If the instruction is a bubble or kill, `branch_taken` MUST be driven as **0** (not taken).

### 6.4.2 Branch Target Generation

ID SHALL compute:

```text
target_pc = if_id_pc + imm_btype
jump_pc   = if_id_pc + imm_jtype
jalr_pc   = (rs1_val + imm_itype) & 32'hFFFF_FFFE
```

All branch/jump targets are computed **only in ID**.

### 6.4.3 Branch Resolution Timing

Branch decision and actual branch target MUST be available **in the same cycle** decode occurs. This drives:

* `redirect_pc`
* `mispredict`
* `flush`

ID SHALL NOT depend on predictor outputs to compute actual branch outcome; predictor is only used by IF for speculation.

---

## 6.5 Operand Forwarding into ID (Branches Only)

### 6.5.1 Forwarding Sources

The ID stage MAY receive forwarded values from:

* EX/MEM stage (highest priority)
* MEM/WB stage

### 6.5.2 Forwarding Rules (Branches)

For branch instructions only:

* If rs1/rs2 matches EX/MEM.rd AND that instruction writes back → forward EX/MEM value.
* Else if matches MEM/WB.rd → forward MEM/WB value.
* Else → use register file values.

Non-branch instructions SHALL NOT use ID-stage forwarding; ALU and other instructions rely on EX-stage forwarding only.

### 6.5.3 Load-to-Branch Hazard

Loads in EX cannot forward into ID this cycle.
Thus:

* Branch depending on a load in EX SHALL stall exactly **1 cycle**.

This matches the global hazard model in Section 3.

---

## 6.6 Decode Control Bundle Formation

ID SHALL generate the **complete unified control bundle** for EX, MEM, and WB.

This includes (non-exhaustive):

* `ctrl_valid`
* `ctrl_bubble`
* `ctrl_kill`
* `ctrl_branch`
* `ctrl_jump`
* `ctrl_mem_read`
* `ctrl_mem_write`
* `ctrl_alu_op`
* `ctrl_wb_en`

Rules:

* `ctrl_valid=1` ONLY for real instructions fetched from memory (including encoded NOP).
* `ctrl_bubble=1` ONLY for **internally inserted bubbles**.
* Bubble control MUST clear all side-effecting bits (no reg write, no mem access).

Control bundle is latched in ID/EX exactly as generated (unless stall/flush). No later stage may overwrite control bits.

---

## 6.7 ID/EX Pipeline Register Inputs

ID SHALL drive the following signals into the ID/EX register:

* `id_ex_pc`
* `id_ex_rs1_val`
* `id_ex_rs2_val`
* `id_ex_rs1`
* `id_ex_rs2`
* `id_ex_rd`
* `id_ex_imm`
* All `id_ex_ctrl_*` control bundle fields

These MUST be valid combinationally during the decode cycle.

---

## 6.8 Flush, Kill, and Stall Behavior in ID

### 6.8.1 Flush

When `flush=1`:

* ID/EX MUST receive a **bubble**.
* All side-effecting control signals MUST be zeroed.
* Any partially decoded instruction in ID is discarded.

### 6.8.2 Stall

When `stall_id=1`:

* ID/EX **holds its previous values**.
* No new decoded instruction may enter ID/EX.

### 6.8.3 Illegal Instruction Handling

If opcode or funct3/funct7 encodings are illegal or unsupported:

* `ctrl_kill=1` for that instruction.
* ID SHALL assert flush into IF/ID and EX as specified in Section 3.
* Illegal encodings MUST map deterministically to a kill/bubble state (no X-propagation).

---

## 6.9 CSR and Exception Rules

* ID SHALL NOT decode or support CSR instructions.
* No exceptions or traps shall be implemented.
* Illegal instructions are handled through **flush + kill** only.

---

## 6.10 ID Pseudo-Code (Informative, Not Synthesizable)

The following pseudo-code illustrates ID behavior each cycle:

```sv
// Pseudo-code, not synthesizable
always @* begin
  // Default: bubble outputs
  id_ex_ctrl_valid  = 1'b0;
  id_ex_ctrl_bubble = 1'b1;
  id_ex_ctrl_kill   = 1'b0;
  id_ex_rs1_val     = 32'b0;
  id_ex_rs2_val     = 32'b0;
  id_ex_imm         = 32'b0;

  if (if_id_ctrl_valid && !flush && !stall_id) begin
    // Decode instruction fields
    decode_fields(if_id_instr, opcode, rd, rs1, rs2, funct3, funct7, imm);

    // Read RF
    rs1_val = rf_read(rs1);
    rs2_val = rf_read(rs2);

    // Apply branch-only forwarding
    if (is_branch) begin
      rs1_val = apply_branch_forwarding_rs1(rs1_val);
      rs2_val = apply_branch_forwarding_rs2(rs2_val);
    end

    // Generate immediates
    imm_val = immgen(if_id_instr);

    // Generate control bundle
    gen_control_bundle(..., ctrl_*);

    // Branch decision
    branch_taken = is_branch ? branch_cmp(rs1_val, rs2_val, funct3) : 1'b0;

    // Drive ID/EX
    id_ex_pc         = if_id_pc;
    id_ex_rs1_val    = rs1_val;
    id_ex_rs2_val    = rs2_val;
    id_ex_imm        = imm_val;
    id_ex_rs1        = rs1;
    id_ex_rs2        = rs2;
    id_ex_rd         = rd;
    id_ex_ctrl_valid = 1'b1;
    id_ex_ctrl_bubble= 1'b0;
  end
end
```

This pseudo-code is illustrative only; Copilot MUST follow the formal rules in Sections 3, 4, and 6.

---

## 6.11 Per-Model ID Behavior Clarifications

Although Section 6 is written as a unified specification for all models, Copilot MUST specialize the ID behavior according to the chosen `MODEL` from Section 1.

### 6.11.1 Model 0 — Non-Forwarding Pipeline

* No operand forwarding into ID.
* Branch comparator ALWAYS uses register file values only.
* Load-to-branch hazards cause **1-cycle stall**.
* No predictor state is updated in ID.

### 6.11.2 Model 1 — Forwarding Pipeline

* Branch-only forwarding into ID is enabled from EX/MEM and MEM/WB.
* Non-branch instructions do NOT use ID-stage forwarding.
* Load-to-branch hazard rule unchanged: 1-cycle stall.

### 6.11.3 Model 2 — Forwarding + Always-Taken Predictor

* Forwarding behavior in ID matches Model 1.
* ID computes actual branch outcome and target.
* Mispredict occurs when actual outcome is NOT-TAKEN.
* ID does not depend on predictor state to compute correctness; predictor is updated conceptually.

### 6.11.4 Model 3 — Forwarding + Two-Bit Dynamic Predictor

* Forwarding behavior in ID matches Model 1.
* ID updates 2-bit predictor counters after computing actual branch result.
* Predictor index and update rules MUST be consistent with Section 5.

### 6.11.5 Model 4 — Forwarding + G-Share Predictor

* Forwarding behavior in ID matches Model 1.
* ID updates both the Global History Register (GHR) and the selected 2-bit counter.
* Index computation and update rules MUST be consistent with Section 5.

---

## 6.12 Summary

The ID stage is a **purely combinational decode engine** with full control generation, operand sourcing (including branch-only forwarding), branch resolution, and immediate generation. It drives the complete ID/EX pipeline register, interacts with hazard and forwarding logic, and asserts flush/redirect for control flow changes.

---

# SECTION 7 — EXECUTE (EX) STAGE, ALU, BRANCH COMPARATOR, AND EFFECTIVE ADDRESS LOGIC

This section defines the **Execute (EX) stage**, including the **ALU**, **operand multiplexers**, **forwarding sources**, and the **effective address computation** for loads and stores. All EX‑stage behavior is strictly combinational and MUST adhere to the stall/flush/kill semantics of Section 3.

---

## 7.1 Overview of EX Stage Responsibilities

The EX stage SHALL perform, in a single combinational cycle:

1. Select ALU operands from rs1/rs2/imm/PC.
2. Apply full ALU control (`ctrl_alu_op`).
3. Compute all RV32I ALU operations.
4. Compute arithmetic effective address for load/store.
5. Apply EX‑stage forwarding for all ALU and LSU operands.
6. Produce ALU result for forwarding (same cycle).
7. Pass results and control bundle to EX/MEM.

EX SHALL NOT contain any sequential logic.

---

## 7.2 ALU Functional Requirements

### 7.2.1 RV32I ALU Operation Set

The ALU SHALL implement the complete set of RV32I operations:

* ADD
* SUB (via ADD + inversion + carry‑in)
* AND, OR, XOR
* SLL, SRL, SRA
* SLT, SLTU

### 7.2.2 SUB Implementation (No `+` Operator)

The ALU SHALL implement all arithmetic using the existing full-adder hierarchy:

* `FA_1bit`
* `FA_4bit`
* `FA_32bit`

For subtraction, the ALU SHALL:

* Invert operand B: `B_sub = ~B_in`.
* Use `FA_32bit` with `Cin = 1'b1`.

Conceptually:

```text
SUB(a, b) = FA_32bit(A = a, B = ~b, Cin = 1'b1).Sum
```

The **SystemVerilog `+` operator MUST NOT be used** for any arithmetic inside the ALU. All 32-bit additions in EX (ADD, SUB, effective address) MUST go through `FA_32bit`.

### 7.2.3 Illegal ALU Control Illegal ALU Control

If `ctrl_alu_op` is invalid:

* ALU result = `32'b0`
* Instruction is treated as **killed** downstream.

---

## 7.3 Operand Selection (ALU Operand A and B)

### 7.3.1 Operand A Multiplexer

Operand A SHALL select from:

* `id_ex_rs1_val`
* `id_ex_pc`
* `32'b0`

### 7.3.2 Operand B Multiplexer

Operand B SHALL select from:

* `id_ex_rs2_val`
* `id_ex_imm`

Selections are controlled exclusively by `ctrl_alu_op` and supporting decode bits.

---

## 7.4 Forwarding into EX Stage

### 7.4.1 Forwarding Sources

In **forwarding models (Models 1–4)**, the EX stage MUST support full forwarding for ALU operands from:

1. **EX/MEM stage** (highest priority)
2. **MEM/WB stage**

In **Model 0 (Non-Forwarding)**, forwarding comparators and muxes MAY be instantiated, but the select lines MUST be forced such that:

* ALU operands always use `id_ex_rs1_val` / `id_ex_rs2_val` (no bypassing).
* Any matches on EX/MEM.rd or MEM/WB.rd are ignored.

### 7.4.2 Forwarding Priority Rules Forwarding Priority Rules

For each ALU operand (A and B):

* If EX/MEM.rd matches id_ex_rsX AND EX/MEM writes → forward EX/MEM.
* Else if MEM/WB.rd matches id_ex_rsX AND MEM/WB writes → forward MEM/WB.
* Else → use `id_ex_rsX_val`.

### 7.4.3 Forwarding Timing

Forwarded ALU results SHALL be considered valid **in the same cycle** as ALU computation.

---

## 7.5 Branch Comparator in EX

The EX stage SHALL **NOT** contain a branch comparator.
All branch comparison logic resides exclusively in the ID stage.

---

## 7.6 Effective Address Computation (Load/Store)

### 7.6.1 EX Responsibilities

The EX stage SHALL compute load/store effective addresses using the `FA_32bit` adder:

```text
effective_addr = FA_32bit(A = id_ex_rs1_val, B = id_ex_imm, Cin = 1'b0).Sum
```

No `+` operator may be used for effective address computation in synthesizable RTL.

### 7.6.2 Forwarding for Store Data

Store data forwarded into EX/MEM SHALL use:

1. EX/MEM (highest priority)
2. MEM/WB
3. Register File values

Store data forwarding MUST follow the same rules as operand forwarding.

---

## 7.7 ALU Control Encoding

### 7.7.1 Encoding Scheme

`ctrl_alu_op` SHALL be a **4-bit binary encoding**. Copilot MUST implement at least the following mapping:

| ctrl_alu_op | Operation | Notes                                                        |
| ----------- | --------- | ------------------------------------------------------------ |
| 4'b0000     | ADD       | Used for ADD, ADDI, address calc, AUIPC, JALR base add       |
| 4'b0001     | SUB       | Used for SUB, branch comparisons (BEQ/BNE/BLT/...) as needed |
| 4'b0010     | AND       | AND, ANDI                                                    |
| 4'b0011     | OR        | OR, ORI                                                      |
| 4'b0100     | XOR       | XOR, XORI                                                    |
| 4'b0101     | SLL       | SLL, SLLI                                                    |
| 4'b0110     | SRL       | SRL, SRLI                                                    |
| 4'b0111     | SRA       | SRA, SRAI                                                    |
| 4'b1000     | SLT       | SLT, SLTI                                                    |
| 4'b1001     | SLTU      | SLTU, SLTIU                                                  |
| others      | RESERVED  | Treated as illegal ALU control (see 7.2.3)                   |

### 7.7.2 Control Generation

`ctrl_alu_op` is generated **in the ID stage** based on opcode/funct3/funct7 and is carried to EX through ID/EX.

EX SHALL NOT re-decode instruction bits; it uses only `ctrl_alu_op` and operands.

### 7.7.3 ALU Behavioral Truth Table (Conceptual)

For each ALU operation, the behavior SHALL be as follows (all 32-bit, no traps on overflow). All additions/subtractions are implemented via `FA_32bit` (no `+` operator in RTL):

* ADD: `result = FA_32bit(A = a, B = b,    Cin = 1'b0).Sum`
* SUB: `result = FA_32bit(A = a, B = ~b,   Cin = 1'b1).Sum`
* AND: `result = a & b`
* OR : `result = a | b`
* XOR: `result = a ^ b`
* SLL: `result = a << b[4:0]`
* SRL: `result = a >> b[4:0]` (logical)
* SRA: `result = signed(a) >>> b[4:0]` (arithmetic)
* SLT: `result = (signed(a) < signed(b)) ? 32'd1 : 32'd0`
* SLTU: `result = (a < b) ? 32'd1 : 32'd0`

Signed comparisons and shifts MUST be implemented using only operators permitted by Section 2. The `+` operator is **forbidden** for arithmetic in EX; `FA_32bit` SHALL be used instead.

---

## 7.8 Bubble / Kill / Flush Behavior in EX

### 7.8.1 Bubble Handling

If ID/EX is a bubble:

* ALU performs a benign operation.
* All EX‑generated side effects are suppressed.
* EX/MEM receives a bubble.

### 7.8.2 Kill Behavior

If ID/EX.ctrl_kill=1:

* EX treats the instruction as invalid.
* ALU result = 0.
* EX/MEM.ctrl_valid=0, ctrl_bubble=1.

### 7.8.3 Flush Behavior

Flush SHALT clear EX/MEM regardless of ALU inputs.

---

## 7.9 No Multi‑Cycle Operations

The EX stage SHALL NOT implement:

* MUL
* DIV
* Any artificial multi‑cycle extension

Only RV32I single‑cycle ALU ops are permitted.

---

## 7.10 Summary

The EX stage is a **fully combinational** stage that selects operands, applies full ALU operations, processes forwarding, computes effective addresses, and passes results to EX/MEM. It adheres strictly to bubble/kill/flush semantics and MUST NOT perform additional decode or multi‑cycle operations.

## 7.11 Per-Model EX Behavior Clarifications

Although Section 7 is written as a unified superspec, Copilot MUST specialize EX behavior depending on the selected `MODEL` in Section 1.

### 7.11.1 Model 0 — Non-Forwarding Pipeline

* EX-stage forwarding is effectively **disabled**.
* ALU operands always come from `id_ex_rs1_val` / `id_ex_rs2_val`.
* Any forwarding comparison logic MUST NOT change operand selection.
* RAW hazards are handled by stalling in ID, not by EX forwarding.

### 7.11.2 Model 1 — Forwarding Pipeline

* Full EX/MEM and MEM/WB forwarding for ALU operands MUST be enabled.
* No stalls for ALU→ALU dependencies (except load-use hazards defined in Section 3).

### 7.11.3 Model 2 — Forwarding + Always-Taken Predictor

* EX forwarding behavior matches Model 1.
* Predictor affects IF only; EX ALU behavior is unchanged.

### 7.11.4 Model 3 — Forwarding + Two-Bit Dynamic Predictor

* EX forwarding behavior matches Model 1.
* Predictor state updates and history handling occur outside EX.

### 7.11.5 Model 4 — Forwarding + G-Share Predictor

* EX forwarding behavior matches Model 1.
* GHR and predictor tables do not alter EX ALU logic.

---

# SECTION 8 — MEM STAGE, LOAD/STORE UNIT (LSU), DMEM, I/O, AND MISALIGNED ACCESSES

This section defines the **MEM stage**, the **Load/Store Unit (LSU)**, the **Data Memory (DMEM) interface**, behavior for **I/O-mapped regions**, and rules for **misaligned and unmapped accesses**. Copilot MUST implement these rules exactly.

---

## 8.1 MEM Stage Responsibilities

The MEM stage SHALL:

* Receive the effective address and store data from EX/MEM.
* Interact with DMEM for loads and stores.
* Interact with I/O-mapped regions (LEDs, HEX, LCD, switches).
* Enforce alignment and address map rules.
* Generate `mem_wb_rdata` and pass ALU result to MEM/WB.
* Never perform new ALU operations or recompute addresses.

MEM SHALL NOT modify the ALU result; it simply routes `ex_mem_alu_result` forward.

---

## 8.2 Effective Address in MEM

The effective address for load/store instructions SHALL be:

* Computed in EX using `FA_32bit` (see Section 7).
* Carried into MEM as `ex_mem_alu_result`.

MEM SHALL treat:

* `addr_effective = ex_mem_alu_result`.

No recomputation of effective address is allowed in MEM.

---

## 8.3 DMEM / LSU Interface and Timing

### 8.3.1 LSU as a Separate Module

MEM SHALL instantiate a dedicated **LSU module** that handles:

* Address decoding (DMEM vs I/O vs unmapped).
* Byte-enable generation.
* DMEM read/write control.
* I/O read/write behavior.
* Misalignment and unmapped-access rules.

### 8.3.2 DMEM Signals

The LSU SHALL drive the following DMEM interface (conceptual):

* `dmem_addr  : logic [31:0]` — byte address (effective address).
* `dmem_wdata : logic [31:0]` — store data (aligned to word boundary).
* `dmem_rdata : logic [31:0]` — loaded word from DMEM.
* `dmem_we    : logic`        — write enable.
* `dmem_be    : logic [3:0]`  — byte enable (one bit per byte).

### 8.3.3 DMEM Timing

DMEM SHALL be synchronous read, 1-cycle latency:

* Cycle N: LSU drives `dmem_addr`, `dmem_we`, `dmem_be`, `dmem_wdata`.
* Cycle N+1: `dmem_rdata` is valid and captured into MEM/WB.

DMEM SHALL NEVER stall. There is no ready/valid handshake in the baseline design.

### 8.3.4 No LSU-Induced Stalls

The LSU SHALL NOT generate any stall signals. All stalls originate from hazards (Section 3), not from DMEM or I/O.

---

## 8.4 Address Decoding: DMEM vs I/O vs Unmapped

### 8.4.1 DMEM Region

The LSU SHALL treat addresses in:

* `0x0000_0000–0x0000_FFFF` as **DMEM**.

Accesses in this range go to DMEM using `dmem_*` signals.

### 8.4.2 I/O Regions

The LSU SHALL decode the following I/O regions (from Section 1):

* `0x1000_0000–0x1000_0FFF` — LEDR output
* `0x1000_1000–0x1000_1FFF` — LEDG output
* `0x1000_2000–0x1000_2FFF` — HEX0–HEX3
* `0x1000_3000–0x1000_3FFF` — HEX4–HEX7
* `0x1000_4000–0x1000_4FFF` — LCD output
* `0x1001_0000–0x1001_0FFF` — Switch input

Stores to these ranges update the corresponding I/O devices.
Loads from these ranges read from the corresponding device.

### 8.4.3 Unmapped Addresses

Any address NOT in DMEM or I/O ranges SHALL be treated as **unmapped**.

* Loads from unmapped addresses SHALL be treated as **illegal accesses** and trigger a pipeline flush.
* Stores to unmapped addresses SHALL be treated as **illegal accesses** and trigger a pipeline flush.

This behavior supersedes any earlier looser rules for unmapped regions.

---

## 8.5 Byte Enables and Access Sizes

### 8.5.1 Byte-Enable Granularity

The LSU SHALL use a 4-bit `dmem_be` to control per-byte writes in a 32-bit word:

* `dmem_be[0]` → lowest byte
* `dmem_be[1]` → byte[15:8]
* `dmem_be[2]` → byte[23:16]
* `dmem_be[3]` → highest byte

### 8.5.2 Supported Access Types

For RV32I load/store mnemonics:

* LB / LBU — byte access
* LH / LHU — halfword access
* LW        — word access
* SB        — byte store
* SH        — halfword store
* SW        — word store

### 8.5.3 Alignment Rules

* Byte accesses (LB/SB) MAY use any address (no alignment constraint).
* Halfword accesses (LH/LHU/SH) MUST have `addr[0] == 1'b0`.
* Word accesses (LW/SW) MUST have `addr[1:0] == 2'b00`.

### 8.5.4 Misaligned Halfword or Word Access

If a halfword or word access violates the alignment rules above:

* The access SHALL be treated as an **illegal memory access**.
* No DMEM or I/O read/write may occur.
* The pipeline SHALL flush according to Section 3.

DMEM align-down tricks SHALL NOT be used for misaligned halfword/word accesses.

---

## 8.6 I/O Access Semantics

### 8.6.1 I/O Write Timing

Stores to I/O-mapped regions SHALL:

* Update internal I/O registers in MEM.
* Drive visible outputs (LEDs, HEX, LCD) on the next clock edge.

From the core’s perspective, I/O writes are **single-cycle** and never stall.

### 8.6.2 I/O Read Timing

Loads from I/O (e.g., switches) SHALL return device values **in the same cycle** MEM performs the access:

* Switch inputs are registered once at the top level (see Section 1).
* LSU reads from these registered values combinationally.
* MEM/WB receives the I/O read data in the same cycle MEM performs the LSU logic, so WB can commit it next cycle.

### 8.6.3 No I/O Stalls

I/O accesses MUST NOT stall the pipeline. All I/O reads/writes complete in a fixed number of cycles as defined above.

---

## 8.7 MEM/WB Interface and Writeback Data

### 8.7.1 Data Passed to MEM/WB

MEM SHALL pass both:

* `mem_wb_alu_result` — unchanged from EX/MEM.
* `mem_wb_rdata`      — from DMEM or I/O.

WB stage SHALL choose the final writeback data based on control bits:

* If `ctrl_mem_read=1` → use `mem_wb_rdata`.
* Else → use `mem_wb_alu_result`.

### 8.7.2 Stores in MEM/WB

Store instructions SHALL propagate through MEM/WB as **bubbles with no writeback**:

* `ctrl_wb_en=0` for stores.
* Stores SHALL NOT write to the register file in WB.

MEM/WB may still carry store metadata (pc, rd, etc.) for debug/tracing.

---

## 8.8 LSU Hazards and Side-Effects

### 8.8.1 No LSU-Induced Stalls

The LSU SHALL NEVER assert any stall signals. All memory and I/O accesses are single-cycle in terms of protocol visibility to MEM and WB.

### 8.8.2 Behavior for Bubbles and Killed Instructions

When `ex_mem_ctrl_valid=0` or `ex_mem_ctrl_kill=1`:

* LSU/DMEM MUST NOT perform any read or write.
* No I/O side effects may occur.
* MEM/WB MUST see a bubble for that entry.

---

## 8.9 Load Data Path and Sign/Zero Extension

### 8.9.1 Raw Data in MEM

MEM SHALL treat `dmem_rdata` as a **raw 32-bit word** and pass it to MEM/WB unmodified.

MEM SHALL NOT perform sign or zero extension.

### 8.9.2 Sign/Zero Extension in WB

WB SHALL:

* Use `mem_wb_rdata` and `mem_wb_addr[1:0]` (byte offset) plus funct3 to select the correct byte/halfword.
* Apply sign extension for LB/LH.
* Apply zero extension for LBU/LHU.
* Pass full 32-bit loaded value to the register file write data.

This isolates all load-format logic to the WB stage.

---

## 8.10 Summary

The MEM stage and LSU provide a **non-stalling, single-cycle protocol** to DMEM and I/O, enforce strict alignment and address map rules, and ensure that misaligned or unmapped accesses are treated as illegal (causing flush) with no side effects. MEM passes raw data and ALU results to WB, where final load selection and sign/zero extension occur.

---

# SECTION 9 — WRITEBACK (WB) STAGE AND COMMIT INTERFACE

This section defines the **Writeback (WB) stage**, the **architectural commit rules**, and all required commit-interface signals (`o_insn_vld`, `o_ctrl`, `o_mispred`, `o_pc_commit`, `o_halt`). Copilot MUST implement every rule in this section exactly.

---

## 9.1 WB Stage Responsibilities

The WB stage SHALL:

* Select the final writeback value (ALU vs load).
* Drive register-file write signals.
* Produce all architectural commit signals.
* Detect HALT commits.
* Integrate with performance counters (cycle, retired, mispred, stall) according to Section 1.

WB SHALL NOT perform any ALU computation or modify the ALU result.

---

## 9.2 Final Writeback Selection

The WB stage SHALL select writeback data as follows:

* If `mem_wb_ctrl_mem_read = 1` → writeback data = `mem_wb_rdata` (after load formatting logic in WB).
* Else → writeback data = `mem_wb_alu_result`.

Store instructions SHALL propagate through MEM/WB but have `ctrl_wb_en = 0`, so RF writes never occur.
Stores still **commit** (they count as retired instructions when they reach WB validly).

---

## 9.3 Register File Write Rules

### 9.3.1 Write Timing

Register-file writes SHALL occur:

* On the **posedge of i_clk**.
* Using signals from MEM/WB.

### 9.3.2 Write Enable Conditions

The RF write-enable (`rf_we`) SHALL assert **only** when:

```sv
(mem_wb_ctrl_valid == 1'b1) &&
(mem_wb_ctrl_wb_en == 1'b1) &&
(mem_wb_rd != 5'd0)
```

All other cases SHALL force `rf_we = 1'b0`.

---

## 9.4 Load Sign/Zero Extension

### 9.4.1 Load Formatting Location

WB SHALL contain ALL sign/zero-extension logic for LB, LBU, LH, LHU, and LW.
MEM SHALL pass raw 32-bit `dmem_rdata` into `mem_wb_rdata`.

### 9.4.2 Load Assumptions

All loads reaching WB SHALL be considered **legal and aligned**, because misaligned accesses are flushed by MEM/LSU (Section 8).

### 9.4.3 Extension Rules

WB SHALL:

* Use `funct3` from the control bundle.
* Use `mem_wb_addr[1:0]` to select byte/halfword.
* Sign-extend LB/LH.
* Zero-extend LBU/LHU.
* Pass the fully extended load value to the register file write data path.

---

## 9.5 Commit Interface Semantics

### 9.5.1 o_pc_commit

`o_pc_commit` SHALL expose:

```sv
o_pc_commit = mem_wb_pc;
```

from the committing instruction.

### 9.5.2 o_insn_vld

`o_insn_vld` SHALL assert **exactly when**:

* The MEM/WB entry is a **real, valid, non-bubble, non-killed instruction**; and
* That instruction is architecturally committing in WB.

This includes:

* ALU operations
* Loads
* Stores
* Branches and jumps

This excludes:

* Bubbles
* Killed/flushed instructions
* Illegal instructions
* Wrong-path instructions due to mispredict

### 9.5.3 o_ctrl

`o_ctrl` SHALL be `1` **only** when the committing instruction is:

* A conditional branch, or
* An unconditional jump (JAL/JALR).

For all other instructions, `o_ctrl = 0`.

### 9.5.4 o_mispred

`o_mispred` SHALL be `1` **only** when all of the following are true:

* The committing instruction in WB is a branch or jump.
* That branch/jump was mispredicted relative to the actual control-flow path.

In all other cases, `o_mispred = 0`.

### 9.5.5 o_halt

A HALT occurs when **a store instruction commits** whose effective address equals:

```sv
32'hFFFF_FFFC
```

HALT SHALL be detected **in WB**, not MEM, because HALT is an architectural commit event.

Once HALT commits:

* PC stops updating.
* No further instructions commit.
* `o_halt` remains high permanently.
* All I/O becomes read-only.
* Pipeline freezes after any in-flight flush completes.

---

## 9.6 Bubble and Kill Handling

### 9.6.1 Bubble Behavior

If `mem_wb_ctrl_valid == 1'b0` OR `mem_wb_ctrl_bubble == 1'b1`:

* `rf_we      = 1'b0`
* `o_insn_vld = 1'b0`
* `o_ctrl     = 1'b0`
* `o_mispred  = 1'b0`
* No architectural state may change.

### 9.6.2 Kill Behavior

If `mem_wb_ctrl_kill == 1'b1` (even if `mem_wb_ctrl_valid` was 1 upstream):

* WB SHALL treat the entry exactly like a bubble.
* No commit, no RF write, no performance counters increment (except cycle counter).

---

## 9.7 Per-Model WB Behavior

All five pipeline models share **identical WB behavior**.
WB is model-independent.

Model differences (forwarding, prediction, etc.) affect IF/ID/EX/MEM handling — NOT WB.

WB SHALL produce commit signals based solely on MEM/WB contents and the control bundle.

---

## 9.8 Performance Counters (Conceptual Integration)

WB interacts conceptually with the performance counters defined in Section 1.

### 9.8.1 Retired Instruction Counter

The **retired instruction counter** SHALL increment **iff**:

```sv
o_insn_vld == 1'b1;
```

That is, each architecturally committed instruction (including stores, branches, and jumps) increments the retired counter by 1.

### 9.8.2 Mispredict Counter

The **mispredict counter** SHALL increment **iff**:

```sv
o_mispred == 1'b1;
```

Mispredicts are counted **at commit time**, not at detection time.

### 9.8.3 Stall Counter

The **stall counter** SHALL increment in any cycle where:

```sv
stall_if == 1'b1 || stall_id == 1'b1;
```

EX/MEM/WB stall conditions (if any) do not directly affect the stall counter.

### 9.8.4 Cycle Counter

The **cycle counter** SHALL increment:

```sv
Every cycle while o_halt == 1'b0;
```

Once HALT has been committed and `o_halt` is high, the cycle counter freezes.

---

# SECTION 10 — BRANCH PREDICTION MODULES (MODELS 2–4)

This section defines the **branch prediction subsystem** used in:

* **Model 2** — Forwarding + Always-Taken Predictor
* **Model 3** — Forwarding + Two-Bit Dynamic Predictor
* **Model 4** — Forwarding + G-share Predictor

Models **0** and **1** SHALL NOT instantiate any active predictor logic. All prediction signals MUST be tied off.

This version applies R1–R4 for precise PC indexing, prediction validity rules, BTB behavior, and JAL/JALR handling.

---

## 10.1 Unified Predictor Interface

A single predictor module SHALL be instantiated, with behavior determined by `MODEL`.

```sv
module branch_predictor (
  input  logic        i_clk,
  input  logic        i_reset,

  // IF-side query
  input  logic [31:0] i_pc_if,
  output logic [31:0] o_pc_pred,
  output logic        o_pc_pred_valid,

  // ID-side update
  input  logic        i_br_resolve,
  input  logic [31:0] i_pc_br,
  input  logic        i_br_taken,
  input  logic [31:0] i_br_target,

  // Model ID
  input  logic [3:0]  i_model_id
);
```

IF SHALL use the predictor output only when `o_pc_pred_valid = 1`.
ID SHALL always override predictor output.

---

## 10.2 Per-Model Behavior Overview

### Model 0 & Model 1

* Predictor disabled.
* `o_pc_pred_valid = 0`.

### Model 2 — Always-Taken

* Predict conditional branches as **taken**.
* JAL/JALR are **not predicted**; handled normally.
* BTB OPTIONAL but recommended; if absent, prediction only indicates taken/not-taken, with redirection occurring in ID.

### Model 3 — Two-Bit Dynamic

* 256-entry table (`index = i_pc_if[9:2]`).
* Prediction valid only when BTB_hit = 1.
* If BTB not used → prediction valid only for direction, with target from ID.

### Model 4 — G-share Dynamic

* 1024-entry table (`pc_index = i_pc_if[11:2]`).
* `index = pc_index XOR GHR`.
* Same BTB rules as Model 3.

---

## 10.3 Prediction Validity Rules (R1)

Dynamic predictors SHALL set:

```
o_pc_pred_valid = BTB_hit;
```

If BTB is **not implemented**:

```
o_pc_pred_valid = 0; // dynamic predictor provides direction only
```

ID WILL still use predictor direction for mispredict detection.

Always-Taken predictor:

* `o_pc_pred_valid = 1` for conditional branches **only**.
* Otherwise 0.

---

## 10.4 Predicted Target Rules (R2)

### If BTB **is implemented** (recommended):

* `o_pc_pred` = `btb_target`.
* Prediction valid only if `btb_hit = 1`.

### If BTB is **not implemented**:

* Predictor SHALL NOT generate a target.
* `o_pc_pred_valid = 0` for Models 3 and 4.
* ID computes all branch targets.

This ensures **no forbidden + operator in IF**.

---

## 10.5 JAL/JALR Prediction Rules (R3)

### WITH BTB

* JAL and JALR entries MAY be stored in BTB.
* If BTB_hit → `o_pc_pred_valid = 1` and target from BTB.
* If no hit → `o_pc_pred_valid = 0`.

### WITHOUT BTB

* JAL/JALR SHALL NOT be predicted.
* They rely solely on ID resolution and redirect.

---

## 10.6 Always-Taken Predictor (Model 2)

### 10.6.1 Prediction Rule

```
If PC holds a conditional branch → predict TAKEN.
Else → no prediction.
```

### 10.6.2 Prediction Validity

```
o_pc_pred_valid = 1 only for branch PCs.
```

### 10.6.3 Prediction Target

* If BTB present → use BTB target.
* If no BTB → ID computes target; IF cannot redirect early.

### 10.6.4 State Update

* No counters.
* BTB MAY be updated.

---

## 10.7 Two-Bit Dynamic Predictor (Model 3)

### 10.7.1 Table Size & Index

* 256 entries.
* `index = i_pc_if[9:2]`.
* No shift operator used.

### 10.7.2 Counter Encoding

```
00 strongly not taken
01 weakly not taken
10 weakly taken
11 strongly taken
```

### 10.7.3 Reset

All counters reset to `2'b01`.

### 10.7.4 Update Rule

On `i_br_resolve=1`:

* Increment toward 11 if taken.
* Decrement toward 00 if not.
* Saturating.

### 10.7.5 Prediction Validity (R1 & R2)

* If BTB present → `o_pc_pred_valid = BTB_hit`.
* If BTB absent → `o_pc_pred_valid = 0`.

---

## 10.8 G-share Predictor (Model 4)

### 10.8.1 Parameters

* 1024-entry table.
* 10-bit GHR.

### 10.8.2 Indexing (R4)

```
pc_index = i_pc_if[11:2];
index    = pc_index XOR GHR;
```

### 10.8.3 Reset

* All counters reset to `2'b01`.
* GHR resets to 0.

### 10.8.4 Update Rule

On branch resolution:

* Update 2-bit counter at derived index.
* Shift actual outcome into GHR.

### 10.8.5 Prediction Validity

Same rule as Model 3:

* `o_pc_pred_valid = BTB_hit` if BTB exists.
* `o_pc_pred_valid = 0` if not.

---

## 10.9 BTB (Optional but Recommended)

### 10.9.1 Size

128 entries.

### 10.9.2 Indexing

`btb_index = i_pc_if[8:2]`.

### 10.9.3 Tagging

* Tag = upper PC bits (`i_pc_if[31:9]`).
* `btb_hit = (stored_tag == i_pc_if[31:9])`.

### 10.9.4 Update

On `i_br_resolve=1`:

* Insert/replace entry for `i_pc_br`.
* Store `i_br_target` and tag.

---

## 10.10 Predictor Integration Rules

### 10.10.1 ID Override

ID ALWAYS overrides predictor output.

### 10.10.2 No Rollback on Flush

Predictor state SHALL NOT roll back.

### 10.10.3 Disabled Models

Models 0 and 1:

```
o_pc_pred_valid = 0;
o_pc_pred       = 32'b0;
```

No tables instantiated.

---

# SECTION 11 — TOP-LEVEL INTEGRATION & MODEL-BASED CONFIGURATION — TOP-LEVEL INTEGRATION & MODEL-BASED CONFIGURATION

This section defines how **all modules from Sections 1–10** connect inside the top-level module `pipelined.sv`. Copilot MUST follow this section precisely when generating the structural RTL.

The purpose of Section 11 is to prevent Copilot from inventing incorrect wiring or missing required modules.

---

## 11.1 Required Source File Names

Copilot MUST generate the following exact filenames under `/00_src/`:

* `pipelined.sv` (top-level)
* `if_stage.sv`
* `id_stage.sv`
* `register_file.sv`
* `immgen.sv`
* `alu.sv`
* `branch_comp.sv`
* `ex_stage.sv`
* `lsu.sv`
* `dmem.sv`
* `mem_stage.sv`
* `wb_stage.sv`
* `hazard_unit.sv`
* `forward_unit.sv`
* `branch_predictor.sv` (Models 2–4 only)

**No additional module files may be created without explicit purpose.**

---

## 11.2 Text-Only Block Diagram (Top-Level Structure)

```
                +-----------------------------+
                |         pipelined           |
                |-----------------------------|
                |  MODEL parameter            |
                |  Top-Level Ports            |
                +--------------+--------------+
                               |
                               v
   +--------+     +--------+     +--------+     +--------+     +--------+
   |  IF    | --> |  ID    | --> |   EX   | --> |  MEM   | --> |   WB   |
   +--------+     +--------+     +--------+     +--------+     +--------+
       |              |              |              |              |
       |              |              |              |              |
   IF/ID Reg     ID/EX Reg      EX/MEM Reg     MEM/WB Reg     Commit Bus
       |
       v
   Branch Predictor (Models 2–4)
```

This block diagram SHALL NOT be omitted.

---

## 11.3 MODEL-Based Feature Matrix

| MODEL | Forwarding | Branch Predictor | Predictor Type |
| ----- | ---------- | ---------------- | -------------- |
| 0     | No         | No               | —              |
| 1     | Yes        | No               | —              |
| 2     | Yes        | Yes              | Always-Taken   |
| 3     | Yes        | Yes              | Two-Bit Dyn.   |
| 4     | Yes        | Yes              | G-share        |

MODEL determines forwarding and prediction behavior *only*.
All other pipeline rules remain identical.

---

## 11.4 Required Internal Signals in `pipelined.sv`

Copilot MUST declare the following internal wires (names fixed):

### IF/ID

* `if_id_pc`
* `if_id_instr`
* `if_id_ctrl_valid`
* `if_id_ctrl_bubble`

### ID/EX

* `id_ex_pc`
* `id_ex_rs1_val`
* `id_ex_rs2_val`
* `id_ex_imm`
* `id_ex_rd`
* `id_ex_ctrl_*`

### EX/MEM

* `ex_mem_alu_result`
* `ex_mem_store_data`
* `ex_mem_rd`
* `ex_mem_ctrl_*`

### MEM/WB

* `mem_wb_alu_result`
* `mem_wb_rdata`
* `mem_wb_rd`
* `mem_wb_ctrl_*`
* `mem_wb_pc`

### Predictor Wiring (Models 2–4 only)

* `pc_pred`
* `pc_pred_valid`

### Stall / Flush

* `stall_if`
* `stall_id`
* `flush`

---

## 11.5 PC Selection Truth Table

| redirect_pc | pc_pred_valid | pc_pred_used | next_pc source |
| ----------- | ------------- | ------------ | -------------- |
| 1           | X             | X            | redirect_pc    |
| 0           | 1             | 1            | pc_pred        |
| 0           | 0             | 0            | pc_plus4       |

This table SHALL be included verbatim.

---

## 11.6 Stall & Flush Propagation Table

| Condition  | IF Stage | IF/ID Reg | ID/EX Reg | EX/MEM | MEM/WB |
| ---------- | -------- | --------- | --------- | ------ | ------ |
| flush=1    | bubble   | bubble    | bubble    | pass   | pass   |
| stall_id=1 | hold     | hold      | hold      | pass   | pass   |
| stall_if=1 | hold PC  | hold      | pass      | pass   | pass   |
| normal     | advance  | write     | write     | write  | write  |

Flush always dominates stall.

---

## 11.7 Integration Pseudocode Skeleton

Copilot MUST follow this structure (non-synthesizable guide):

```sv
module pipelined (...);

  // --------------------------------------------
  // 1. Declarations
  // --------------------------------------------
  logic [31:0] pc_if, pc_pred;
  logic pc_pred_valid;
  logic stall_if, stall_id, flush;
  // plus all pipeline reg wires (Section 11.4)

  // --------------------------------------------
  // 2. Instantiate Predictor (Models 2–4)
  // --------------------------------------------
  branch_predictor u_pred (...);

  // --------------------------------------------
  // 3. IF Stage
  // --------------------------------------------
  if_stage u_if (...);

  // IF/ID register
  if_id_reg u_ifid (...);

  // --------------------------------------------
  // 4. ID Stage + Register File + ImmGen
  // --------------------------------------------
  id_stage u_id (...);
  register_file u_rf (...);
  immgen u_imm (...);

  // ID/EX register
  id_ex_reg u_idex (...);

  // --------------------------------------------
  // 5. EX Stage + ALU
  // --------------------------------------------
  ex_stage u_ex (...);
  alu u_alu (...);

  // EX/MEM register
  ex_mem_reg u_exmem (...);

  // --------------------------------------------
  // 6. MEM Stage + LSU + DMEM
  // --------------------------------------------
  mem_stage u_mem (...);
  lsu u_lsu (...);
  dmem u_dmem (...);

  // MEM/WB register
  mem_wb_reg u_memwb (...);

  // --------------------------------------------
  // 7. WB Stage
  // --------------------------------------------
  wb_stage u_wb (...);

endmodule
```

This skeleton SHALL guide Copilot’s integration structure.

---

