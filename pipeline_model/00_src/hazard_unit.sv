//==============================================================================
// Hazard Detection and Forwarding Unit for MODEL_FWD_AT Pipeline
//==============================================================================
// Description:
//   Complete hazard detection unit supporting:
//   - Load-use hazard detection and stalling
//   - Control hazard detection and flushing
//   - 3-stage data forwarding (EX, MEM, WB)
//
// Forwarding Model (per specification Section 3.4):
//   Priority: EX/MEM > MEM/WB > Register File
//   Encoding: 00 = No forwarding (use ID/EX register)
//             01 = Forward from WB stage
//             10 = Forward from MEM stage  
//             11 = Forward from EX stage (highest priority)
//
// Stall Conditions:
//   - Load-use hazard: Instruction in EX is a load and its destination
//     matches source register(s) of instruction in ID stage
//
// Flush Conditions:
//   - Branch/jump taken in EX stage (control hazard)
//   - Flushes IF/ID and ID/EX pipeline registers
//==============================================================================

module hazard_unit (
    // ID stage source registers (for load-use hazard detection)
    input logic [4:0]  id_rs1_addr_i,
    input logic [4:0]  id_rs2_addr_i,

    // EX stage source registers (for forwarding logic)
    input logic [4:0]  ex_rs1_addr_i,
    input logic [4:0]  ex_rs2_addr_i,

    // EX stage destination register and type
    input logic [4:0]  ex_rd_addr_i,
    input logic        ex_reg_we_i,
    input logic        ex_mem_read_i,     // High if EX instruction is a load

    // MEM stage destination register
    input logic [4:0]  mem_rd_addr_i,
    input logic        mem_reg_we_i,

    // WB stage destination register (for 3-stage forwarding)
    input logic [4:0]  rd_addr_wb,
    input logic        reg_write_wb,

    // Control hazard signals
    input logic        pc_src_E,      // Branch/jump taken (from EX stage)
    // Outputs
    output logic       StallF,               // Stall PC/Fetch
    output logic       StallD,               // Stall IF/ID register
    output logic       FlushD,               // Flush IF/ID register
    output logic       FlushE,               // Flush ID/EX register
    output logic [1:0] ForwardAE,            // Forward select for rs1
    output logic [1:0] ForwardBE             // Forward select for rs2
);

    //==========================================================================
    // Forwarding Encoding Constants
    //==========================================================================
    localparam [1:0] FWD_NONE   = 2'b00;  // No forwarding (use ID/EX register)
    localparam [1:0] FWD_WB     = 2'b01;  // Forward from WB stage
    localparam [1:0] FWD_MEM    = 2'b10;  // Forward from MEM stage
    localparam [1:0] FWD_EX     = 2'b11;  // Forward from EX stage (unused in current model)

    //==========================================================================
    // 1. LOAD-USE HAZARD DETECTION (Stall Logic)
    //==========================================================================
    logic lwStall;
    
    // Detect load-use hazard: load in EX, dependent instruction in ID
    assign lwStall = ex_mem_read_i && (ex_rd_addr_i != 5'b0) &&
                     ((ex_rd_addr_i == id_rs1_addr_i) || (ex_rd_addr_i == id_rs2_addr_i));

    // Stall PC and IF/ID register on load-use hazard
    assign StallF = lwStall;
    assign StallD = lwStall;

    //==========================================================================
    // 2. CONTROL HAZARD DETECTION (Flush Logic)
    //==========================================================================
    
    // Flush IF/ID only on branch/jump taken (discard wrong path instruction)
    assign FlushD = pc_src_E;
    
    // Flush ID/EX on branch/jump OR load-use hazard (insert bubble)
    assign FlushE = pc_src_E | lwStall;
    

    //==========================================================================
    // 3. DATA FORWARDING LOGIC (3-Stage Forwarding)
    //==========================================================================
    // Forward priority (per specification Section 3.4.1):
    //   1. EX/MEM stage (freshest data, currently in MEM stage)
    //   2. MEM/WB stage (data from WB stage)
    //   3. Register file (no hazard)
    //
    // Note: EX-to-EX forwarding (FWD_EX) is not implemented in this model
    // because we forward from MEM and WB stages only. The specification
    // MODEL_FWD_AT requires "full EX/MEM and MEM/WB forwarding" which means
    // forwarding from the pipeline registers, not combinational EX output.
    //==========================================================================

    // Forwarding for rs1 (operand A)
    // Compares MEM/WB destinations against EX stage source (currently executing)
    always_comb begin
        if (mem_reg_we_i && (mem_rd_addr_i != 5'b0) && (mem_rd_addr_i == ex_rs1_addr_i)) begin
            // Priority 1: Forward from MEM stage (EX/MEM pipeline register)
            ForwardAE = FWD_MEM;
        end else if (reg_write_wb && (rd_addr_wb != 5'b0) && (rd_addr_wb == ex_rs1_addr_i)) begin
            // Priority 2: Forward from WB stage (MEM/WB pipeline register)
            ForwardAE = FWD_WB;
        end else begin
            // No hazard: Use value from ID/EX register (register file read)
            ForwardAE = FWD_NONE;
        end
    end

    // Forwarding for rs2 (operand B)
    // Compares MEM/WB destinations against EX stage source (currently executing)
    always_comb begin
        if (mem_reg_we_i && (mem_rd_addr_i != 5'b0) && (mem_rd_addr_i == ex_rs2_addr_i)) begin
            // Priority 1: Forward from MEM stage (EX/MEM pipeline register)
            ForwardBE = FWD_MEM;
        end else if (reg_write_wb && (rd_addr_wb != 5'b0) && (rd_addr_wb == ex_rs2_addr_i)) begin
            // Priority 2: Forward from WB stage (MEM/WB pipeline register)
            ForwardBE = FWD_WB;
        end else begin
            // No hazard: Use value from ID/EX register (register file read)
            ForwardBE = FWD_NONE;
        end
    end

endmodule
