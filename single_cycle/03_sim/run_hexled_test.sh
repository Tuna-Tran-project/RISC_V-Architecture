#!/bin/bash
# Script to run HEXLED testbench with counter_v3_fast.hex (fast simulation version)

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║           HEXLED (7-Segment Display) Test Runner                ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Use fast version by default, allow override with argument
COUNTER_FILE="${1:-counter_v3_fast.hex}"

# Check if counter file exists
if [ ! -f "../02_test/$COUNTER_FILE" ]; then
    echo "❌ ERROR: $COUNTER_FILE not found in 02_test/"
    echo "   Available versions:"
    echo "     - counter_v3_fast.hex (fast simulation, ~1 sec)"
    echo "     - counter_v3.hex (hardware timing, ~30 min simulation)"
    exit 1
fi

echo "Using: $COUNTER_FILE"
echo ""

# Backup current i_mem.sv
echo "[1/5] Backing up i_mem.sv..."
cp ../00_src/i_mem.sv ../00_src/i_mem.sv.bak

# Temporarily modify i_mem.sv to load the counter hex file
echo "[2/5] Configuring i_mem.sv to load $COUNTER_FILE..."
sed -i "s|../02_test/isa_4b.hex|../02_test/$COUNTER_FILE|g" ../00_src/i_mem.sv

# Compile and run test
echo "[3/5] Compiling testbench..."
iverilog -g2012 -I../01_bench -o sim_hexled.vvp \
    ../01_bench/tb_hexled.sv \
    ../00_src/*.sv 2>&1 | tee compile_hexled.log

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "[4/5] Running HEXLED test..."
    vvp sim_hexled.vvp 2>&1 | tee sim_hexled.log
    TEST_RESULT=$?
else
    echo "❌ Compilation failed, check compile_hexled.log"
    TEST_RESULT=1
fi

# Restore original i_mem.sv
echo "[5/5] Restoring i_mem.sv..."
mv ../00_src/i_mem.sv.bak ../00_src/i_mem.sv

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $TEST_RESULT -eq 0 ]; then
    echo "✅ Test completed successfully"
    echo "   Review results in: sim_hexled.log"
else
    echo "❌ Test encountered errors"
    echo "   Check: compile_hexled.log and sim_hexled.log"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit $TEST_RESULT
