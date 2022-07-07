set WORK_HOME ./
set RTL ../../../rtl
set AGENTS ../../../agents
set TAR_PATH ../..
puts "input the test case name"
set TEST [gets stdin]


vlib work

vlog +incdir+$RTL/spi/rtl/verilog $RTL/spi/rtl/verilog/*.v +acc
vlog +incdir+$AGENTS/apb_agent $AGENTS/apb_agent/apb_agent_pkg.sv
vlog +incdir+$AGENTS/spi_agent $AGENTS/spi_agent/spi_agent_pkg.sv
vlog +incdir+../uvm_register_model ../uvm_register_model/spi_reg_pkg.sv
vlog $AGENTS/apb_agent/apb_if.sv -timescale 1ns/10ps
vlog $AGENTS/spi_agent/spi_if.sv -timescale 1ns/10ps
vlog ../tb/intr_if.sv -timescale 1ns/10ps
vlog +incdir+../env ../env/spi_env_pkg.sv
vlog +incdir+../sequences ../sequences/spi_bus_sequence_lib_pkg.sv
vlog +incdir+../sequences ../sequences/spi_sequence_lib_pkg.sv
vlog +incdir+../sequences ../sequences/spi_virtual_seq_lib_pkg.sv
vlog +incdir+../test ../test/spi_test_lib_pkg.sv
vlog -timescale 1ns/10ps +incdir+$RTL/spi/rtl/verilog ../tb/top_tb.sv

vsim -voptargs=+acc top_tb +UVM_TESTNAME=$TEST
