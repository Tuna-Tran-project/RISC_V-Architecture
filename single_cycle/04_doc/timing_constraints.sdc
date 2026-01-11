# Timing Constraints for RISC-V Single-Cycle Processor
# DE-10 Standard FPGA - 10 MHz Operation
# Target: wrapper module (top-level)

# Create clock constraint for 50 MHz input clock
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]

# Create clock directly on the divider output register
# Quartus detected this as a clock, so we need to constrain it
create_clock -name {clk_10M} -period 100.000 -waveform { 0.000 50.000 } [get_registers {clock_10M:u_clkdiv|o_clk}]

# Derive clock uncertainty
derive_clock_uncertainty

# Set input delays relative to CLOCK_50 for switches and keys
# Assuming switches/buttons are asynchronous, give them relaxed constraints
set_input_delay -clock {CLOCK_50} -max 5.000 [get_ports {SW[*]}]
set_input_delay -clock {CLOCK_50} -min 0.000 [get_ports {SW[*]}]
set_input_delay -clock {CLOCK_50} -max 5.000 [get_ports {KEY[*]}]
set_input_delay -clock {CLOCK_50} -min 0.000 [get_ports {KEY[*]}]

# Set output delays for displays and LEDs relative to 10 MHz clock
set_output_delay -clock {clk_10M} -max 10.000 [get_ports {LEDR[*]}]
set_output_delay -clock {clk_10M} -min 0.000 [get_ports {LEDR[*]}]
set_output_delay -clock {clk_10M} -max 10.000 [get_ports {HEX0[*]}]
set_output_delay -clock {clk_10M} -min 0.000 [get_ports {HEX0[*]}]
set_output_delay -clock {clk_10M} -max 10.000 [get_ports {HEX1[*]}]
set_output_delay -clock {clk_10M} -min 0.000 [get_ports {HEX1[*]}]
set_output_delay -clock {clk_10M} -max 10.000 [get_ports {HEX2[*]}]
set_output_delay -clock {clk_10M} -min 0.000 [get_ports {HEX2[*]}]
set_output_delay -clock {clk_10M} -max 10.000 [get_ports {HEX3[*]}]
set_output_delay -clock {clk_10M} -min 0.000 [get_ports {HEX3[*]}]
set_output_delay -clock {clk_10M} -max 10.000 [get_ports {HEX4[*]}]
set_output_delay -clock {clk_10M} -min 0.000 [get_ports {HEX4[*]}]
set_output_delay -clock {clk_10M} -max 10.000 [get_ports {HEX5[*]}]
set_output_delay -clock {clk_10M} -min 0.000 [get_ports {HEX5[*]}]

# Set false paths for asynchronous reset (KEY buttons are async)
set_false_path -from [get_ports {KEY[*]}] -to [all_registers]

# Set false paths for switches (treat as asynchronous inputs)
set_false_path -from [get_ports {SW[*]}] -to [all_registers]

# Multi-cycle paths (none for true single-cycle, but good practice)
# If memory is truly async-read, it completes in same cycle

# Timing exceptions for cross-domain signals (if any)

# Report timing after constraints
# Use: report_timing -from [get_clocks i_clk] -to [get_clocks i_clk] -setup -npaths 10
