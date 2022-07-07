set UVM_REGISTER ../../../../uvm_register-2.0
set RTL ../../../rtl
set AGENTS ../../../agents
set TAR_PATH ../..
set TEST gpio_rgm_input_test

vlib work

vlog +acc -incr +incdir+$RTL/gpio/rtl/verilog $RTL/gpio/rtl/verilog/*.v
vlog -incr +incdir+$AGENTS/apb_agent $AGENTS/apb_agent/apb_agent_pkg.sv -suppress 2263
vlog -incr +incdir+../register_model ../register_model/gpio_register_model_pkg.sv -suppress 2263
vlog -incr +incdir+$AGENTS/gpio_agent $AGENTS/gpio_agent/gpio_agent_pkg.sv -suppress 2263
vlog -incr $AGENTS/apb_agent/apb_if.sv -timescale 1ns/10ps -suppress 2263
vlog -incr $AGENTS/gpio_agent/gpio_if.sv -timescale 1ns/10ps -suppress 2263
vlog -incr ../tb/intr_if.sv -timescale 1ns/10ps -suppress 2263
vlog -incr +incdir+../env ../env/gpio_env_pkg.sv -suppress 2263
vlog -incr +incdir+../sequences ../sequences/gpio_sequence_lib_pkg.sv -suppress 2263
vlog -incr +incdir+../sequences ../sequences/gpio_rgm_bus_seq_lib_pkg.sv -suppress 2263
vlog -incr +incdir+../sequences ../sequences/gpio_rgm_virtual_sequence_pkg.sv -suppress 2263
vlog -incr +incdir+../gpio_rgm_test ../gpio_rgm_test/gpio_rgm_test_lib_pkg.sv -suppress 2263
vlog -incr -timescale 1ns/10ps +incdir+$RTL/gpio/rtl/verilog ../tb/top_tb.sv -suppress 2263

vsim -voptargs=+acc top_tb +UVM_TESTNAME=$TEST

