package gpio_rgm_virtual_sequence_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import apb_agent_pkg::*;
	import gpio_agent_pkg::*;
	import gpio_env_pkg::*;
	import gpio_rgm_bus_seq_lib_pkg::*;
	import gpio_sequence_lib_pkg::*;    // dut gpio side sequence, used to stimulate the input or output. no reg config

		`define INTS 32'h1c

	// interrupt service routine at the apb level
	class gpio_isr extends uvm_sequence #(apb_seq_item);
		`uvm_object_utils(gpio_isr)

		function new(string name = "isr");
			super.new(name);
		endfunction

		task body;
			apb_seq_item cmd = apb_seq_item::type_id::create("cmd");
			// 占有总线
			m_sequencer.grab(this); // Exclusive access
			cmd.addr = `INTS;
			cmd.we = 0;
			cmd.delay = 0;
			start_item(cmd);
			finish_item(cmd);
			cmd.we = 1;
			cmd.data = 0;
			start_item(cmd);
			finish_item(cmd);
			m_sequencer.ungrab(this); // Release hold on sequencer
		endtask
	endclass


	class gpio_rgm_virtual_sequence_base extends uvm_sequence #(uvm_sequence_item);
		`uvm_object_utils(gpio_rgm_virtual_sequence_base)

		function new(string name = "gpio_rgm_virtual_sequence_base");
			super.new(name);
		endfunction

		gpio_virtual_sequencer m_v_sqr;
		gpio_env_config m_cfg;

		gpio_sequencer aux;
		gpio_sequencer gpi;
		apb_sequencer apb;

		task body;
			// 获得调用该virtual sequence 的 sqr句柄
			if(!$cast(m_v_sqr, m_sequencer)) begin
				`uvm_fatal("GPIO_VIRTUAL_SEQUENCER", "Cast of m_sequencer to the virtual sequencer failed - this simulation will fail");
			end

			gpi = m_v_sqr.gpi;
			aux = m_v_sqr.aux;
			apb = m_v_sqr.apb;

			if (!uvm_config_db #(gpio_env_config)::get(m_sequencer, "", "gpio_env_config", m_cfg) )
				`uvm_fatal("CONFIG_LOAD", "Cannot get() configuration gpio_env_config from uvm_config_db. Have you set() it?")
		endtask

	endclass

	class GPI_rgm_check_reset_test_vseq extends gpio_rgm_virtual_sequence_base;

		`uvm_object_utils(GPI_rgm_check_reset_test_vseq)
		uvm_status_e status;
		function new(string name = "GPI_rgm_check_reset_test_vseq");
			super.new(name);
		endfunction

		task body;
			//gpio_input_test_seq gpi_input_regs = gpio_input_test_seq::type_id::create("gpi_input_regs");
			gpio_rand_seq gpi_inputs = gpio_rand_seq::type_id::create("gpio_rand_seq");
			check_reset_seq gpi_reg_reset_check = check_reset_seq::type_id::create("gpi_reg_reset_check");
			super.body();
			fork
				begin
					gpi_reg_reset_check.start(m_v_sqr.apb);
					`uvm_info("SEQ","run sequence over", UVM_LOW);
				end
			//gpi_inputs.start(gpi); // Forever
			join_none

		endtask: body

	endclass

	class GPI_rgm_input_read_vseq extends gpio_rgm_virtual_sequence_base;

		`uvm_object_utils(GPI_rgm_input_read_vseq)
		uvm_status_e status;
		function new(string name = "GPI_rgm_input_read_vseq");
			super.new(name);
		endfunction

		task body;
			//gpio_input_test_seq gpi_input_regs = gpio_input_test_seq::type_id::create("gpi_input_regs");
			gpio_rand_seq gpi_inputs = gpio_rand_seq::type_id::create("gpio_rand_seq");
			check_reset_seq gpi_reg_reset_check = check_reset_seq::type_id::create("gpi_reg_reset_check");
        	gpio_rgm_input_test_seq gpi_input_regs = gpio_rgm_input_test_seq::type_id::create("gpi_input_regs");
			gpio_isr ISR = gpio_isr::type_id::create("ISR");
			super.body();
			gpi_reg_reset_check.start(apb);
			`uvm_info("SEQ","run sequence over", UVM_LOW);
			fork
				begin
					gpi_input_regs.iterations = 2000;
					gpi_input_regs.start(apb);
				end
				gpi_inputs.start(gpi); // Forever
				begin // ISR
					forever begin
						m_cfg.wait_for_interrupt;
						ISR.start(apb);
					end
				end
			join_none

		endtask: body

	endclass
endpackage 