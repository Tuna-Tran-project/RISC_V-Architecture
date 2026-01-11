# RISC-V Processor Implementations

This repository contains two complete RISC-V RV32I processor implementations for the Terasic DE-10 Standard FPGA board, demonstrating different architectural approaches to instruction execution.

---

## 📚 Overview

The repository includes:

1. **[single_cycle/](single_cycle/)** - Single-cycle processor implementation (Milestone 2)
2. **[pipeline_model/](pipeline_model/)** - 5-stage pipelined processor with forwarding and branch prediction (Milestone 3)

Both implementations:
- Support the RISC-V RV32I instruction set (unprivileged, integer only)
- Pass comprehensive ISA validation test suites
- Include BCD stopwatch demonstration programs
- Feature memory-mapped I/O for FPGA peripherals (LEDs, 7-segment displays, switches, LCD)
- Are fully synthesizable for DE-10 Standard FPGA

---

## 🔧 Single-Cycle Model

**Location**: [single_cycle/](single_cycle/)

### Architecture Highlights

- **Execution Model**: One instruction per clock cycle
- **Architecture Type**: Harvard architecture (separate instruction and data memory)
- **Memory Configuration**: 
  - IMEM: 2 KiB
  - DMEM: 2 KiB
- **Clock Frequency**: 25 MHz (for hardware deployment)
- **Performance**: Simple, predictable timing; CPI = 1.0

### Key Features

- ✅ Complete RV32I ISA support (excluding FENCE)
- ✅ Memory-mapped I/O peripherals
- ✅ BCD stopwatch with pause/resume functionality
- ✅ Passes all ISA validation tests (isa_1b, isa_4b)
- ✅ Straightforward design, ideal for learning processor fundamentals

### Design Philosophy

The single-cycle design prioritizes simplicity and clarity. Each instruction completes in exactly one clock cycle, making it easy to understand and debug. This comes at the cost of maximum clock frequency, as the critical path spans the entire instruction execution.

### Typical Use Cases

- Educational purposes and learning RISC-V architecture
- Applications where simplicity is more important than performance
- Debugging and validating instruction behavior
- Reference implementation for comparison

---

## ⚡ Pipelined Model (FWD_AT)

**Location**: [pipeline_model/](pipeline_model/)

### Architecture Highlights

- **Pipeline Stages**: 5 stages (IF → ID → EX → MEM → WB)
- **Hazard Handling**: 
  - Data forwarding (EX→MEM, MEM→WB)
  - Automatic stall insertion for load-use hazards
  - Load-to-jump/branch hazard detection (2-cycle stall)
- **Branch Prediction**: Always-Taken with BTB (Branch Target Buffer)
  - Model ID: `FWD_AT` (`o_model_id = 4'd2`)
  - BTB-based prediction for reduced branch penalties
- **Memory Configuration**:
  - IMEM: 64 KiB
  - DMEM: 32 KiB (0x0000_0000 - 0x0000_7FFF)
- **Special Features**:
  - Misaligned memory access support (2-cycle state machine)
  - Full commit/debug signal exposure for validation
  - Pipeline flush and halt mechanisms

### Performance Metrics

From ISA test suite execution:
- **IPC (Instructions Per Cycle)**: ~0.63
- **Branch Misprediction Rate**: ~93% (due to test-heavy workload)
- **Total Tests Passed**: 40/40 ✅
- **Clock Cycles**: ~7,842 for complete ISA test suite
- **Instructions Executed**: ~4,950

### Key Features

- ✅ 5-stage pipeline with full forwarding paths
- ✅ BTB-based always-taken branch prediction
- ✅ Automatic misaligned memory access handling
- ✅ Comprehensive hazard detection (including load-to-jump hazards)
- ✅ Server-compatible interface with commit signals
- ✅ Pipeline instrumentation (PC tracking, misprediction monitoring)
- ✅ All 40 ISA tests pass

### Design Philosophy

The pipelined design maximizes throughput through instruction-level parallelism. By overlapping the execution of multiple instructions, it achieves higher performance than the single-cycle design. The implementation includes sophisticated hazard detection and data forwarding to maintain correct execution while minimizing pipeline stalls.

### Advanced Features

1. **Data Forwarding**: Results bypass from later stages to earlier stages when dependencies exist
2. **Branch Prediction**: BTB tracks branch/jump targets; predicts "taken" on hit, "not taken" on miss
3. **Misaligned Access**: Transparent 2-cycle handling of unaligned word/halfword operations
4. **Hazard Unit**: Detects and resolves:
   - Load-use hazards (1-cycle stall)
   - Load-to-branch/jump hazards (2-cycle stall)
   - Control hazards (flush on misprediction)

### Typical Use Cases

- High-performance embedded applications
- Real-time signal processing
- Applications requiring better IPC than single-cycle
- Research and development in branch prediction and pipeline optimization

---

## 🎯 Comparison Matrix

| Feature | Single-Cycle | Pipelined (FWD_AT) |
|---------|--------------|-------------------|
| **CPI** | 1.0 (ideal) | ~1.6 (with hazards) |
| **IPC** | 1.0 | ~0.63 (ISA tests) |
| **Clock Frequency** | Lower (longer critical path) | Higher (shorter stages) |
| **Throughput** | 1 inst/cycle | Up to 5 inst/cycle (theoretical) |
| **Complexity** | Low | High |
| **Hazard Handling** | None needed | Forwarding + stalls |
| **Branch Penalty** | None | 0-2 cycles (with prediction) |
| **IMEM Size** | 2 KiB | 64 KiB |
| **DMEM Size** | 2 KiB | 32 KiB |
| **Best For** | Education, simplicity | Performance, realism |
| **Misaligned Access** | Not implemented | Full support |

---

## 🚀 Getting Started

### Prerequisites

- Icarus Verilog (for simulation)
- GTKWave (for waveform viewing)
- Make (for build automation)
- Quartus Prime (for FPGA synthesis and deployment)

### Running Simulations

#### Single-Cycle Model
```bash
cd single_cycle/03_sim
make clean
make create_filelist
make sim
```

#### Pipelined Model
```bash
cd pipeline_model/03_sim
make create_filelist
make sim
```

### Expected Results

Both models should output:
```
TEST PASSED
```

The pipelined model additionally provides detailed performance statistics including IPC, branch misprediction rate, and cycle counts.

---

## 📊 ISA Test Coverage

Both implementations pass comprehensive test suites covering:

- ✅ Arithmetic instructions (ADD, SUB, ADDI, etc.)
- ✅ Logical instructions (AND, OR, XOR, SLL, SRL, SRA, etc.)
- ✅ Load/Store instructions (LW, LH, LB, SW, SH, SB)
- ✅ Branch instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
- ✅ Jump instructions (JAL, JALR)
- ✅ Upper immediate instructions (LUI, AUIPC)
- ✅ Memory-mapped I/O operations
- ✅ Misaligned memory access (pipelined model only)

Total: **40 ISA tests** across both implementations

---

## 🎓 Educational Value

### Learning Path Recommendation

1. **Start with Single-Cycle** ([single_cycle/](single_cycle/))
   - Understand basic processor organization
   - Learn instruction decode and execution flow
   - Study datapath and control unit design
   - Grasp memory-mapped I/O concepts

2. **Progress to Pipelined** ([pipeline_model/](pipeline_model/))
   - Learn pipeline stage organization
   - Understand data hazards and forwarding
   - Study control hazards and branch prediction
   - Explore performance optimization techniques
   - Analyze IPC and pipeline efficiency

---

## 📖 Documentation

Each implementation includes comprehensive documentation:

- **README.md**: Implementation-specific details
- **04_doc/specification.md**: Detailed technical specifications
- **04_doc/de10_pin_assign.qsf**: FPGA pin assignments for DE-10 Standard
- **04_doc/timing_constraints.sdc**: Synthesis timing constraints

---

## 🔬 Demonstration Programs

Both implementations include:

1. **ISA Test Suites**:
   - `isa_1b.hex` - Byte-formatted ISA tests
   - `isa_4b.hex` - Word-formatted ISA tests

2. **BCD Stopwatch**:
   - `stopwatch_fast.hex` - Fast simulation version
   - `stopwatch_hardware.hex` - Real-time hardware version
   - Features: Start/stop, pause/resume, BCD counting on 7-segment displays

---

## 🏆 Key Achievements

- ✅ **100% ISA Test Pass Rate** - All 40 tests pass on both implementations
- ✅ **FPGA-Ready** - Fully synthesizable for Terasic DE-10 Standard
- ✅ **Complete I/O Integration** - Memory-mapped peripherals working in hardware
- ✅ **Performance Analysis** - Detailed IPC and misprediction metrics
- ✅ **Production Quality** - Server-compatible interface with debug signals

---

## 🛠️ Project Structure

```
RISC_V/
├── single_cycle/          # Milestone 2: Single-cycle implementation
│   ├── 00_src/            # RTL source files
│   ├── 01_bench/          # Testbenches
│   ├── 02_test/           # Test programs (hex files, assembly)
│   ├── 03_sim/            # Simulation environment
│   └── 04_doc/            # Documentation and constraints
│   └── README.md          # Short Document for single_cycle
│
├── pipeline_model/            # Documentation and constraints
│
├── pipeline_model/        # Milestone 3: Pipelined implementation
│   ├── 00_src/            # RTL source files (pipeline stages)
│   ├── 01_bench/          # Testbenches with scoreboard
│   ├── 02_test/           # Test programs
│   ├── 03_sim/            # Simulation environment
│   └── 04_doc/            # Specifications and constraints\
│   └── README.md          # Short Document for pipeline_model
│
└── README.md              # This file
```

---

## 📝 License & Attribution

Educational project developed for VLSI design coursework. Implements the RISC-V RV32I ISA as specified by the RISC-V International organization.

---

## 🤝 Contributing

This is an educational project. Both implementations are feature-complete and pass all validation tests.

---

**Note**: For detailed technical specifications, build instructions, and module-level documentation, refer to the README.md files in each respective subdirectory.
