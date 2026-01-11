# Milestone 2 — Single-Cycle RV32I Core Specification

## 1. Objective

Design and verify a **single-cycle RV32I processor** that is synthesizable, functionally correct, and passes all provided ISA tests. Behavioral and FPGA implementations must be equivalent. The processor is implemented with the ISA RV32I, excluding FENCE instructions. To enable communication between your custom processor (soft-core) and ex-ternal peripherals, some modifications to the standard processor design are necessary. The standard peripherals it must support are LCD, LEDs, and SWITCHes; seven-segment LEDs are optional. In order to accommodate the lecture, for memory, the processor utilizes two identical logic element memory models. One is read-only for the instruction memory, while the other is read-write for the data memory.

---

## 2. Core Architecture

### Features

* **ISA:** RV32I (unprivileged, integer only)
* **Cycle Type:** Single-cycle (1 instruction per instruction)
* **Word Size:** 32 bits
* **Address Width:** ≥16 bits for the extra environment
* **Memory:** IMEM = 2 KiB (basic) / 8 KiB (extra), DMEM = 2 KiB
* **Bus Interfaces:** Harvard-style (separate IMEM/DMEM)

### Address Map

| Region   | Address Range           | Notes                    |
| -------- | ----------------------- | ------------------------ |
| IMEM     | 0x0000_0000–0x0000_07FF | Instruction memory       |
| DMEM     | 0x0000_0000–0x0000_07FF | Data memory              |
| Reserved | ≥ 0x0000_0800           | No aliasing, no stalls   |
| Extra    | Up to 0x0000_7FFF       | Extended sim environment |

### Memory-mapped

| Mapping       | Address                 |
| ------        | ----------------------- |
| Reserved      | 0x1001_1000-0xFFFF_FFFF |
| SW            | 0x1001_0000-0x1001_0FFF |
| Reserved      | 0x1000_5000-0x1000_FFFF |
| LCD           | 0x1000_4000-0x1000_4FFF |
| HEXLEDs (7-4) | 0x1000_3000-0x1000_3FFF |
| HEXLEDs (0-3) | 0x1000_2000-0x1000_2FFF |
| LEDG          | 0x1000_1000-0x1000_1FFF |
| LEDR          | 0x1000_0000-0x1000_0FFF |
| Reserved      | 0x0000_0800-0x0FFF_FFFF |
| MEMORY (2KiB) | 0x0000_0000-0x0000_07FF |


### Top-Level Ports

**Top-level module:** `single_cycle.sv` (or `singlecycle.sv` per PDF specification)

**Port naming:** Can use either convention:
- PDF style: `iclk`, `ireset`, `opcdebug`, `oinsnvld`, `oioledr`, `oioledg`, `oiohex0..7`, `oiolcd`, `iiosw`
- Underscore style: `i_clk`, `i_reset`, `o_pc_debug`, `o_insn_vld`, `o_io_ledr`, `o_io_ledg`, `o_io_hex[0-7]`, `o_io_lcd`, `i_io_sw`

```
i_clk, i_reset, o_pc_debug, o_insn_vld,
o_io_ledr, o_io_ledg, o_io_hex[0–7], o_io_lcd, i_io_sw
```

| Signal name | Width |  Direction | Description |
| --- | --- | --- | --- |
| iclk | 1 | input | Global clock, active on the rising edge. |
| ireset | 1 | input | Global low active reset. |
| opcdebug | 32 | output | Debug program counter. |
| oinsnvld | 1 | output | Instruction valid. |
| oioledr | 32 | output | Output for driving red LEDs. |
| oioledg | 32 | output | Output for driving green LEDs. |
| oiohex0..7 | 7 | output | Output for driving 7-segment LED displays. |
| oiolcd | 32 | output | Output for driving the LCD register. |
| iiosw | 32 | input | Input for switches. |

---

## 3. Module Hierarchy

1. **control_unit (or ControlUnit):** Decode (opcode/funct3/funct7) → control signals.
2. **datapath:** PC, regfile, ALU, branch/next-PC muxes, memory routing.
3. **alu (or ALU):** Logical/arithmetic operations per RV32I (no mul/div).
4. **brc (or BRC):** Branch comparisons (eq/ne/ltu/lt/geu/ge) combinational.
5. **regfile (or register_file):** 32×32-bit; x0 hardwired to 0.
6. **i_mem (or imem):** Async-read / sync-write; `$readmemh` init; retains on reset.
7. **dmem (or d_mem):** Async-read / sync-write; same timing model as IMEM.
8. **lsu (or LSU):** Address/align, byte-enable (`wstrb`), sign/zero-extend loads.
9. **single_cycle (top-level):** Integration + I/O mapping + debug.

---

## 4. Memory Design

### Simulation

* Asynchronous read, synchronous write.
* Preload with `$readmemh`.
* Contents persist across resets.
* Accesses outside valid windows complete as defined no-ops (no stall).

### FPGA

* Infer BRAM (e.g., `(* ramstyle="M10K" *)` or vendor RAM inference).
* Preserve hierarchy to ensure RAM inference.
* Behavior must match the simulation model.

---

## 5. Load-Store Unit (LSU)

| Inst | Alignment       | `wstrb`   | Action       |
| ---- | --------------- | --------- | ------------ |
| SB   | Any             | One byte  | 8-bit write  |
| SH   | addr[0] == 0    | Two bytes | 16-bit write |
| SW   | addr[1:0] == 00 | All bytes | 32-bit write |

Rules:

* Misaligned SH/SW → defined no-op (no trap, no stall).
* One-cycle completion for all stores; correct per-lane masking.
* Loads must sign/zero-extend per `funct3`.

---

## 6. Simulation and Testing (Local iverilog)

### Directory Layout

* **00_src:** RTL source files (**only edit these; do not change others unless a bug is impossible to fix otherwise**).
* **01_bench:** Testbench and helper files.
* **02_test:** ISA test programs (assembly/hex).
* **03_sim:** Simulation Makefile and configuration.
* **04_doc:** Milestone specification and notes (this file).

### Flow

```
make clean
make create_filelist
make sim
```

* Environment: local iverilog/vvp.
* Tests terminate with PASS/FAIL on the terminal.

### Debugging Guidance

* Prefer `$display` instrumentation **inside RTL (00_src)** to trace issues.
* Suggested probes (guard with `ifdef SIM`):

  * PC (`o_pc_debug`) and `o_insn_vld` each cycle.
  * Decoded fields: opcode, funct3, funct7, rs1, rs2, rd, immediates.
  * LSU: effective address, `wstrb`, write data, read data.
  * Branch: compare results, taken flag, next PC.

---

## 7. ISA Validation & Common Issues

### Coverage

* ALU: ADD/SUB, AND/OR/XOR, SLT/SLTU, shifts (immediate/register).
* Control flow: JAL, JALR, BEQ, BNE, BLT/BGE, BLTU/BGEU; correct PC advance.
* Loads/stores: LB/LBU, LH/LHU, LW, SB/SH/SW with correct masking and extension.
* I/O mapped stores: LED/HEX write behavior.

### Debug Quick-Ref

| Symptom            | Likely Cause            | Where to Check         |
| ------------------ | ----------------------- | ---------------------- |
| PC not advancing   | Next-PC mux/enable bug  | control_unit, datapath |
| Wrong load data    | Sign/zero-extend error  | lsu load path          |
| Store corruption   | `wstrb` mask bug        | lsu mask generation    |
| Branch misbehavior | Compare/imm gen error   | brc, immediate decode  |
| Hang after return  | Missing completion path | PC write enable/valid  |

---

## 8. Synthesis Rules

* Keep IMEM/DMEM hierarchical; avoid array flattening.
* Ensure BRAM inference (no DFF-based memory).
* Simulation and synthesis behavior must match.

---

## 9. Compliance Checklist

### RTL Design Rules (00_src only)
✅ No forbidden operators in RTL: `-, <, >, <<, >>, >>>, *, /, %`
✅ No `generate`, `for`, or `function` constructs in RTL (00_src)
✅ No `initial` blocks in RTL (00_src) except IMEM/DMEM for `$readmemh`
✅ No `#delay`, `wait`, or `fork` constructs
✅ All signals `logic` with single drivers
✅ Sequential logic: `always_ff` + nonblocking (`<=`)
✅ Combinational logic: `always_comb` + blocking (`=`), no latches

### Memory and LSU
✅ Async-read / sync-write IMEM & DMEM
✅ IMEM/DMEM use `initial` + `$readmemh` for preload (simulation only)
✅ Memory contents persist across resets (no reset clearing)
✅ Correct LSU byte enables and alignment rules
✅ Misaligned SH/SW → no-op (no trap, no stall)

### Functional Verification
✅ Proper PC advancement; `o_insn_vld` asserted per instruction
✅ No aliasing outside valid memory windows
✅ PASS/FAIL observed for the provided ISA tests
✅ x0 hardwired to zero (read returns 0, writes ignored)

### Synthesis
✅ Keep IMEM/DMEM hierarchical (no array flattening)
✅ Quartus (or equivalent) infers BRAM for memories
✅ Simulation and synthesis behavior match

### Construct Usage Table

| Construct           | RTL (00_src)        | Testbench (01_bench) | IMEM/DMEM (00_src)       | Notes                          |
| ------------------- | ------------------- | -------------------- | ------------------------ | ------------------------------ |
| `initial`           | ❌ Not allowed      | ✅ Allowed           | ✅ Allowed (`$readmemh`) | Simulation preload only        |
| `for`               | ❌ Not allowed      | ✅ Allowed           | ✅ Allowed               | No hardware loops in RTL       |
| `generate`          | ❌ Not allowed      | ✅ Allowed (optional)| ✅ Allowed               | Not for synthesizable RTL      |
| `function`          | ❌ Not allowed      | ✅ Allowed           | ✅ Allowed               | Use `always_comb` instead      |
| `#delay`/`wait`/`fork` | ❌ Not allowed   | ✅ Allowed           | ❌ Not needed            | Simulation control only        |

---

## 10. RTL Design Rules

* All signals `logic` with single drivers.
* **Sequential:** `always_ff` + nonblocking.
* **Combinational:** `always_comb` + blocking; avoid latches.
* Reserved/invalid address accesses must complete without stalls.

---

## 11. Summary

A single-cycle RV32I core that executes each instruction in one cycle, enforces address and I/O maps, implements correct LSU behavior, passes the provided ISA tests under the local iverilog flow, and synthesizes to FPGA with BRAM inference.

**End of Milestone 2 Specification**
