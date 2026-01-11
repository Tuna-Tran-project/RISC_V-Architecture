# RISC-V Single-Cycle Processor - Milestone 2

A complete RISC-V RV32I single-cycle processor implementation designed for the Terasic DE-10 Standard FPGA board. This project follows the Milestone 2 specification and includes a BCD stopwatch demonstration.

---

## 🎯 Project Overview

This project implements a **single-cycle RISC-V processor** with Harvard architecture that executes RV32I instructions (excluding FENCE) in one clock cycle. The processor includes memory-mapped I/O for peripherals and passes all ISA validation tests.

### Key Features

- **ISA**: RISC-V RV32I (unprivileged, integer only)
- **Architecture**: Single-cycle, Harvard (separate IMEM/DMEM)
- **Memory**: IMEM = 2 KiB, DMEM = 2 KiB
- **I/O**: Memory-mapped LEDs, switches, 7-segment displays, LCD
- **Demonstration**: BCD stopwatch with pause/resume functionality
- **Validation**: Passes ISA test suites (isa_1b.hex, isa_4b.hex)

---

## 📁 Project Structure

```
riscv/
├── 00_src/              # RTL source files (SystemVerilog)
│   ├── single_cycle.sv  # Top-level processor module
│   ├── control_unit.sv  # Instruction decoder
│   ├── alu.sv           # Arithmetic logic unit
│   ├── brc.sv           # Branch comparator
│   ├── regfile.sv       # 32× 32-bit register file
│   ├── i_mem.sv         # Instruction memory (2 KiB)
│   ├── dmem.sv          # Data memory (2 KiB)
│   ├── lsu.sv           # Load-store unit
│   ├── imm_gen.sv       # Immediate generator
│   └── PC.sv            # Program counter
│
├── 01_bench/            # Testbenches
│   ├── tbench.sv        # Main ISA testbench
│   ├── tb_hexled.sv     # HEXLED stopwatch testbench
│   ├── driver.sv        # Test driver
│   └── scoreboard.sv    # Test validation
│
├── 02_test/             # Test programs
│   ├── stopwatch.s              # BCD stopwatch source (fast)
│   ├── stopwatch_fast.hex       # Simulation version (fast delay)
│   ├── stopwatch_hardware.s     # BCD stopwatch source (hardware)
│   ├── stopwatch_hardware.hex   # Hardware version (real-time delay)
│   ├── isa_1b.hex               # ISA validation test 1
│   └── isa_4b.hex               # ISA validation test 2
│
├── 03_sim/              # Simulation environment
│   ├── run_hexled_test.sh   # Stopwatch test script
│   ├── flist                # ISA test file list
│   ├── flist_hexled         # HEXLED test file list
│   └── makefile             # Build automation
│
└── 04_doc/              # Documentation
    ├── milestone-2.md           # Project specification
    ├── de10_pin_assign.qsf      # FPGA pin assignments
    └── timing_constraints.sdc   # Timing constraints
```

---

## 🚀 Quick Start

### Running ISA Tests

```bash
cd 03_sim
make clean
make create_filelist
make sim
```

Expected output: `TEST PASSED`

### Running Stopwatch Demonstration

```bash
cd 03_sim
./run_hexled_test.sh
```

Expected output: All 10 tests passing with ✅ indicators

---

## 🏗️ Core Architecture

### Module Hierarchy (per Milestone 2)

1. **single_cycle** - Top-level integration
2. **control_unit** - Instruction decoder
3. **alu** - Arithmetic/logical operations
4. **brc** - Branch comparator
5. **regfile** - 32× 32-bit registers (x0 = 0)
6. **i_mem** - Instruction memory
7. **dmem** - Data memory
8. **lsu** - Load-store unit
9. **imm_gen** - Immediate generator
10. **PC** - Program counter

### Top-Level Ports

```systemverilog
module single_cycle(
    input  logic        i_clk,        // Clock
    input  logic        i_reset,      // Reset (active-low)
    input  logic [31:0] i_io_sw,      // Switches
    output logic [31:0] o_pc_debug,   // Debug PC
    output logic        o_insn_vld,   // Instruction valid
    output logic [31:0] o_io_ledr,    // Red LEDs
    output logic [31:0] o_io_ledg,    // Green LEDs
    output logic [6:0]  o_io_hex0,    // 7-segment displays
    output logic [6:0]  o_io_hex1,
    output logic [6:0]  o_io_hex2,
    output logic [6:0]  o_io_hex3,
    output logic [6:0]  o_io_hex4,
    output logic [6:0]  o_io_hex5,
    output logic [6:0]  o_io_hex6,
    output logic [6:0]  o_io_hex7,
    output logic [31:0] o_io_lcd      // LCD
);
```

### Memory Map (per Milestone 2)

| Region        | Address Range           | Description              |
|---------------|-------------------------|--------------------------|
| IMEM          | 0x0000_0000–0x0000_07FF | Instruction memory (2KB) |
| DMEM          | 0x0000_0000–0x0000_07FF | Data memory (2KB)        |
| LEDR          | 0x1000_0000–0x1000_0FFF | Red LEDs                 |
| LEDG          | 0x1000_1000–0x1000_1FFF | Green LEDs               |
| HEXLEDs (0-3) | 0x1000_2000–0x1000_2FFF | 7-segment displays 0-3   |
| HEXLEDs (4-7) | 0x1000_3000–0x1000_3FFF | 7-segment displays 4-7   |
| LCD           | 0x1000_4000–0x1000_4FFF | LCD register             |
| SW            | 0x1001_0000–0x1001_0FFF | Switch inputs            |

---

## 🎮 Stopwatch Demonstration

### Display Format

- **Digits**: HEX5-HEX0 (6 digits)
- **Range**: 000000 to 999999
- **Encoding**: BCD (Binary-Coded Decimal)
- **7-Segment**: Active-low encoding

### Controls

| Control   | Function      | Description                    |
|-----------|---------------|--------------------------------|
| **SW[0]** | Pause/Resume  | 1 = Pause, 0 = Resume counting |
| **Reset** | System Reset  | Resets display to 000000       |

### 7-Segment Encoding (Active-Low)

| Digit | HEX Code |
|-------|----------|
| 0     | 0x40     |
| 1     | 0x79     |
| 2     | 0x24     |
| 3     | 0x30     |
| 4     | 0x19     |
| 5     | 0x12     |
| 6     | 0x02     |
| 7     | 0x78     |
| 8     | 0x00     |
| 9     | 0x10     |
| Blank | 0x7F     |

---

## 🔧 Test Programs

### ISA Validation Tests

1. **isa_1b.hex** - Basic instruction test suite
2. **isa_4b.hex** - Extended instruction test suite

These validate:
- ALU operations: ADD/SUB, AND/OR/XOR, SLT/SLTU, shifts
- Control flow: JAL, JALR, branches
- Load/Store: LB/LBU, LH/LHU, LW, SB/SH/SW
- Immediate operations: ADDI, ANDI, ORI, XORI, SLTI, SLTIU
- Upper immediates: LUI, AUIPC

### Stopwatch Programs

**Two versions available:**

#### 1. Simulation Version (Fast)
- **Files**: `stopwatch.s`, `stopwatch_fast.hex`
- **Delay**: 10 cycles per increment
- **Purpose**: Quick testbench validation
- **Update Rate**: ~83 cycles per count
- **Usage**: `./run_hexled_test.sh`
- **Best for**: Simulation and testing

#### 2. Hardware Version (Real-time)
- **Files**: `stopwatch_hardware.s`, `stopwatch_hardware.hex`
- **Delay**: 10,000,000 cycles (nested loops: 1000 × 10000)
- **Purpose**: Real FPGA deployment
- **Update Rate**: ~2 seconds per count at 10 MHz
- **Usage**: Quartus synthesis → DE-10 board
- **Best for**: Visible real-time counting on hardware

**Both versions include:**
- Same BCD format (MM:SS:CC: 00:00:00 to 99:59:99)
- Same pause/resume on SW[0]
- Same 7-segment encoding
- Same rollover logic
- Only difference: delay loop timing

### Stopwatch Test (tb_hexled.sv)

10 comprehensive test categories:
1. Reset Test
2. Basic Counting
3. BCD Encoding
4. Display Codes
5. Counter Increment
6. Rollover Test
7. Memory I/O
8. Pause Functionality
9. Resume Functionality
10. Edge Cases

---

## 🛠️ Build Instructions

### Prerequisites

- **iverilog** - Verilog simulation
- **vvp** - Verilog runtime
- **RISC-V toolchain** (optional, for modifying stopwatch):
  - `riscv64-unknown-elf-as`
  - `riscv64-unknown-elf-objcopy`

### Simulation Workflow

```bash
cd 03_sim
make clean
make create_filelist
make sim                   # Run ISA tests
./run_hexled_test.sh       # Run stopwatch test
```

### Modifying the Stopwatch

**For simulation version (fast):**
```bash
cd 02_test
vim stopwatch.s

# Assemble
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o stopwatch.o stopwatch.s
riscv64-unknown-elf-objcopy -O binary stopwatch.o stopwatch.bin
hexdump -v -e '1/4 "%08x\n"' stopwatch.bin > stopwatch_fast.hex

# Test
cd ../03_sim
./run_hexled_test.sh
```

**For hardware version (real-time):**
```bash
cd 02_test
vim stopwatch_hardware.s

# Assemble
riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 -o stopwatch_hardware.o stopwatch_hardware.s
riscv64-unknown-elf-objcopy -O binary stopwatch_hardware.o stopwatch_hardware.bin
hexdump -v -e '1/4 "%08x\n"' stopwatch_hardware.bin > stopwatch_hardware.hex

# Deploy to FPGA
# 1. Update i_mem.sv to load stopwatch_hardware.hex
# 2. Synthesize with Quartus
# 3. Program DE-10 board
```

### Hardware Deployment

To deploy the hardware stopwatch to the DE-10 FPGA:

1. **Update instruction memory** in your RTL to load `stopwatch_hardware.hex`
2. **Synthesize** the design with Quartus Prime
3. **Generate** programming file (.sof)
4. **Program** the DE-10 board via USB Blaster
5. **Observe** real-time counting on 7-segment displays
6. **Use SW[0]** to pause/resume the counter

---

## 📋 Design Compliance

### RTL Design Rules ✅

- ✅ No forbidden operators
- ✅ No `generate`, `for`, or `function` in RTL
- ✅ No `initial` blocks except IMEM/DMEM `$readmemh`
- ✅ All signals `logic` with single drivers
- ✅ Sequential: `always_ff` + nonblocking (`<=`)
- ✅ Combinational: `always_comb` + blocking (`=`)

### Memory Implementation ✅

- ✅ Asynchronous read, synchronous write
- ✅ Preloaded with `$readmemh`
- ✅ Contents persist across resets
- ✅ Hierarchical structure for BRAM inference

### Functional Validation ✅

- ✅ Proper PC advancement
- ✅ `o_insn_vld` asserted per instruction
- ✅ x0 hardwired to zero
- ✅ All ISA tests pass

### LSU Compliance ✅

| Instruction | Alignment     | Write Strobe | Behavior    |
|-------------|---------------|--------------|-------------|
| SB          | Any           | 1 byte       | 8-bit write |
| SH          | addr[0] == 0  | 2 bytes      | 16-bit write|
| SW          | addr[1:0]==00 | 4 bytes      | 32-bit write|

Misaligned SH/SW → defined no-op (no trap, no stall)

---

## 🐛 Debugging

### Debug Outputs

- `o_pc_debug` - Current program counter
- `o_insn_vld` - Instruction valid signal

### Common Issues

| Symptom              | Likely Cause            | Check Module   |
|----------------------|-------------------------|----------------|
| PC not advancing     | Next-PC mux/enable bug  | control_unit   |
| Wrong load data      | Sign/zero-extend error  | lsu            |
| Store corruption     | `wstrb` mask bug        | lsu            |
| Branch misbehavior   | Compare/immediate error | brc, imm_gen   |
| Display not updating | Memory map address error| single_cycle   |

---

## 📚 Documentation

- **`04_doc/milestone-2.md`** - Complete project specification
- **`04_doc/de10_pin_assign.qsf`** - FPGA pin assignments
- **`04_doc/timing_constraints.sdc`** - Timing constraints

---

## 🎓 References

- [RISC-V ISA Specification](https://riscv.org/technical/specifications/)
- [RISC-V Assembly Manual](https://github.com/riscv-non-isa/riscv-asm-manual)
- [DE-10 Standard Manual](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=165&No=1081)

---

## 📝 License

Educational project for Milestone 2 of a computer architecture course.

---

**Project Status**: ✅ Complete and Verified  
- All ISA tests passing
- Stopwatch demonstration functional
- Fully compliant with Milestone 2 specification
