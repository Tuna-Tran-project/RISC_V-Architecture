# Author: Hai Cao
# Copyright 2024

.PHONY: sim
sim:
	@echo "-> Compiling with iverilog"
	@iverilog -g2012 -I../01_bench -o sim.vvp -c flist 2>&1 | tee compile.log
	@echo "-> Running simulation"
	@vvp sim.vvp 2>&1 | tee sim.log

.PHONY: wave
wave:
	@gtkwave dump.vcd &


.PHONY: gui
gui:
	@echo "-> Compiling with iverilog"
	@iverilog -g2012 -I../01_bench -o sim.vvp -c flist
	@echo "-> Running simulation with waveform"
	@vvp sim.vvp
	@gtkwave dump.vcd &


.PHONY: hexled
hexled:
	@echo "-> Testing HEXLED outputs with counter_v3.hex"
	@echo "-> Compiling with iverilog"
	@iverilog -g2012 -I../01_bench -o sim_hexled.vvp \
		../01_bench/tb_hexled.sv \
		../00_src/*.sv 2>&1 | tee compile_hexled.log
	@echo "-> Running HEXLED test"
	@vvp sim_hexled.vvp 2>&1 | tee sim_hexled.log
	@echo "-> HEXLED test complete, check sim_hexled.log"

.PHONY: clean
clean:
	@echo "-> CLEAN"
	@rm -rf x* *.vcd *.shm *.log *.vvp



.PHONY: create_filelist
create_filelist:
	@rm -f flist
	@echo "# =============== Included testbench files ==============="
	@find ./../01_bench \( -name "*.sv" -o -name "*.v" -o -name "*.svh" -o -name "*.vh" \) -exec echo "Included file:" {} \;
	@echo "# =============== Included source code files ==============="
	@find ./../00_src \( -name "*.sv" -o -name "*.v" -o -name "*.svh" -o -name "*.vh" \) -exec echo "Included file:" {} \;

	@echo "# TESTBENCH FILES" >> flist
	@find ./../01_bench \( -name "*.sv" -o -name "*.v" \) >> flist
	@echo "# SOURCE CODE FILES" >> flist
	@find ./../00_src \( -name "*.sv" -o -name "*.v" \)  >> flist








