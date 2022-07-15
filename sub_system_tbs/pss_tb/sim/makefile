BLOCK_TB     ?= ../../../block_level_tbs
RTL          ?= ../../../rtl
AGENTS       ?= ../../../agents
TAR_PATH     ?= ../../../../
TEST         ?= pss_test

all: work rtl build tb run

rtl:
	vlog -incr +incdir+$(RTL)/spi/rtl/verilog $(RTL)/spi/rtl/verilog/*.v
	vlog -incr +incdir+$(RTL)/gpio/rtl/verilog $(RTL)/gpio/rtl/verilog/*.v
	vlog -incr -sv +incdir+$(RTL)/uart/rtl $(RTL)/uart/rtl/*.v
	vlog -incr $(RTL)/icpit/rtl/*.v -timescale 1ns/10ps
	vlog -incr +incdir+$(RTL)/gpio/rtl/verilog $(RTL)/ahb2apb/rtl/*.sv -timescale 1ns/10ps
	vlog -incr +incdir+$(RTL)/gpio/rtl/verilog $(RTL)/pss/rtl/pss.sv -timescale 1ns/10ps
	vlog -incr $(RTL)/pss/rtl/pss_wrapper.sv -timescale 1ns/10ps

tarball: clean tar

work:
	vlib work

build:
	vlog -incr $(AGENTS)/apb_agent/apb_if.sv -timescale 1ns/10ps -suppress 2263
	vlog -incr $(AGENTS)/spi_agent/spi_if.sv -timescale 1ns/10ps -suppress 2263
	vlog -incr $(AGENTS)/gpio_agent/gpio_if.sv -timescale 1ns/10ps -suppress 2263
	vlog -incr $(AGENTS)/ahb_agent/ahb_if.sv -timescale 1ns/10ps -suppress 2263
# vlog -incr $(AGENTS)/modem_agent/modem_if.sv -timescale 1ns/10ps -suppress 2263
# vlog -incr $(AGENTS)/uart_agent/serial_if.sv -timescale 1ns/10ps -suppress 2263
	vlog -incr $(BLOCK_TB)/icpit_tb/tb/icpit_if.sv -timescale 1ns/10ps -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/gpio_tb/register_model $(BLOCK_TB)/gpio_tb/register_model/gpio_register_model_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/spi_tb/uvm_register_model $(BLOCK_TB)/spi_tb/uvm_register_model/spi_reg_pkg.sv -suppress 2263
	vlog -incr +incdir+../register_model ../register_model/pss_register_model.sv -suppress 2263
	vlog -incr +incdir+$(AGENTS)/apb_agent $(AGENTS)/apb_agent/apb_agent_pkg.sv -suppress 2263
	vlog -incr +incdir+$(AGENTS)/spi_agent $(AGENTS)/spi_agent/spi_agent_pkg.sv -suppress 2263
	vlog -incr +incdir+$(AGENTS)/ahb_agent $(AGENTS)/ahb_agent/ahb_agent_pkg.sv -suppress 2263
	vlog -incr +incdir+$(AGENTS)/gpio_agent $(AGENTS)/gpio_agent/gpio_agent_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/spi_tb/env $(BLOCK_TB)/spi_tb/env/spi_env_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/gpio_tb/env $(BLOCK_TB)/gpio_tb/env/gpio_env_pkg.sv -suppress 2263
	vlog -incr +incdir+../env ../env/pss_env_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/gpio_tb/sequences $(BLOCK_TB)/gpio_tb/sequences/gpio_sequence_lib_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/gpio_tb/sequences $(BLOCK_TB)/gpio_tb/sequences/gpio_rgm_bus_seq_lib_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/gpio_tb/sequences $(BLOCK_TB)/gpio_tb/sequences/gpio_rgm_virtual_sequence_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/spi_tb/sequences $(BLOCK_TB)/spi_tb/sequences/spi_bus_sequence_lib_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/spi_tb/sequences $(BLOCK_TB)/spi_tb/sequences/spi_sequence_lib_pkg.sv -suppress 2263
	vlog -incr +incdir+$(BLOCK_TB)/spi_tb/sequences $(BLOCK_TB)/spi_tb/sequences/spi_virtual_seq_lib_pkg.sv -suppress 2263
	vlog -incr +incdir+../sequences ../sequences/pss_vseq_lib_pkg.sv -suppress 2263
	vlog -incr +incdir+../test ../test/pss_test_lib_pkg.sv -suppress 2263

tb:
	vlog -incr -timescale 1ns/10ps ../tb/intr_if.sv -timescale 1ns/10ps
	vlog -incr -timescale 1ns/10ps ../tb/apb_prober.sv -timescale 1ns/10ps
	vlog -incr -timescale 1ns/10ps ../tb/binder.sv -timescale 1ns/10ps
	vlog -incr -timescale 1ns/10ps +incdir+$(RTL)/gpio/rtl/verilog ../tb/top_tb.sv -timescale 1ns/10ps

run:
	vsim -c -do "run -all" top_tb +UVM_TESTNAME="$(TEST)"

clean:
	@rm -rf work transcript *~ vsim.wlf *.log *.tgz
	@find ../../../ -name "*~" -delete



