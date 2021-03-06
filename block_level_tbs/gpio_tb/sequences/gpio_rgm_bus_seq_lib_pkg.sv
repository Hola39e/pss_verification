package gpio_rgm_bus_seq_lib_pkg;
	import uvm_pkg::*;


	import apb_agent_pkg::*;
	//import uvm_register_pkg::*;
	//import gpio_register_pkg::*;
	import gpio_env_pkg::*;
	`include "uvm_macros.svh"
	import gpio_register_model_pkg::*;

	class bus_rgm_base_sequence extends uvm_sequence #(uvm_sequence_item);
		`uvm_object_utils(bus_rgm_base_sequence);
		rand logic [31:0] address;
		rand logic [31:0] seq_data;
		uvm_reg_data_t wr_val;
		uvm_reg_data_t rd_val;
		uvm_reg gpio_regs[$];
		string regs_name[] = '{"RGPIO_IN", "RGPIO_OUT", "RGPIO_OE", "RGPIO_INTE",
			"RGPIO_PTRIG", "RGPIO_AUX", "RGPIO_CTRL", "RGPIO_INTS",
			"RGPIO_ECLK", "RGPIO_NEC"};

		gpio_env_config m_cfg;
		gpio_reg_block gpio_rgm;
		apb2reg_adapter adapter;
		uvm_status_e status;
		string scope_name = "gpio_config_for_seq";


		function new(string name = "bus_base_sequence");
			super.new(name);
		endfunction

		task body();
			if(!uvm_config_db #(gpio_env_config)::get(null, scope_name, "gpio_env_config", m_cfg))
				`uvm_error("SEQ", "cannot get config")
			gpio_rgm = m_cfg.gpio_rgm;
			gpio_rgm.get_registers(gpio_regs);
		endtask

		task read(string read_reg);
			uvm_reg_data_t data;
			gpio_rgm.read_reg_by_name(status, read_reg, data);
		endtask

		task random_write(string write_reg);
			wr_val = $urandom_range(0, 32'hFFFF_FFFF);
			gpio_rgm.write_reg_by_name(status, write_reg, wr_val);
			`uvm_info("REG", $sformatf("RGPIO_%s write to %0h",write_reg , wr_val), UVM_LOW)
		endtask

	endclass

	class check_reset_seq extends bus_rgm_base_sequence;

		`uvm_object_utils(check_reset_seq)

		uvm_reg_data_t data ;

		uvm_reg_data_t ref_data;
		function new(string name = "check_reset_seq");
			super.new(name);
		endfunction

		task body;
			int errors;
			super.body;
			errors = 0;
			gpio_regs.shuffle();
			foreach(gpio_regs[i]) begin
				ref_data = gpio_regs[i].get_reset();    // get reset value
				gpio_regs[i].read(status, data, .parent(this));
				if(ref_data != data) begin
					`uvm_error("REG_TEST_SEQ:", $sformatf("Reset read error for %s: Expected: %0h Actual: %0h", gpio_regs[i].get_name(), ref_data, data))
					errors++;
				end
				else
					`uvm_info("SEQ", "RESET PASS", UVM_LOW);
			end
		endtask: body
	endclass
	class gpio_rgm_input_test_seq extends bus_rgm_base_sequence;

		`uvm_object_utils(gpio_rgm_input_test_seq)

		rand int iterations;




		function new(string name = "gpio_rgm_input_test_seq");
			super.new("name");
		endfunction

		task body;
			wr_val = $urandom_range(0, 32'hFFFF_FFFF);
			super.body();
			repeat(20) begin
				wr_val = $urandom_range(0, 32'hFFFF_FFFF);
				gpio_rgm.RGPIO_IN.write(status, wr_val);
			end
			gpio_rgm.RGPIO_ECLK.write(status, 32'hFFFF_FFFF);

			repeat(20) begin
				wr_val = $urandom_range(0, 32'hFFFF_FFFF);
				gpio_rgm.RGPIO_IN.write(status, wr_val);
			end
			gpio_rgm.RGPIO_NEC.write(status, 32'hFFFF_FFFF);

			repeat(20) begin
				wr_val = $urandom_range(0, 32'hFFFF_FFFF);
				gpio_rgm.RGPIO_IN.write(status, wr_val);
			end
			gpio_rgm.RGPIO_INTE.write(status, 32'hFFFF_FFFF);

			repeat(20) begin
				gpio_rgm.RGPIO_INTS.read(status, rd_val);
			end
			gpio_rgm.RGPIO_CTRL.write(status, 32'h1);

			repeat(20) begin
				wr_val = $urandom_range(0, 32'hFFFF_FFFF);
				gpio_rgm.RGPIO_INTS.write(status, wr_val);
			end
			gpio_rgm.RGPIO_PTRIG.write(status, 32'hFFFF_FFFF);

			repeat(20) begin
				gpio_rgm.RGPIO_INTS.read(status, rd_val);
			end

			repeat(iterations) begin
				gpio_regs.shuffle();
				randcase
					10:gpio_regs[0].write(status, wr_val, .parent(this));
					1:gpio_regs[0].read(status, rd_val, .parent(this));
				endcase
			end
		endtask: body
	endclass: gpio_rgm_input_test_seq

	class output_test_seq extends bus_rgm_base_sequence;

		`uvm_object_utils(output_test_seq)

		function new(string name = "output_test_seq");
			super.new(name);
		endfunction

		string output_regs[] = '{"RGPIO_OUT", "RGPIO_OE"};

		task body;
			super.body();
			
			repeat(1)begin
				output_regs.shuffle();
				random_write(output_regs[0]);
				gpio_rgm.read_reg_by_name(status, output_regs[0], rd_val);
				`uvm_info("REG", $sformatf("REG:: %s read back to %0h",output_regs[0] , rd_val), UVM_LOW)
			end
		endtask: body

	endclass: output_test_seq

	class aux_reg_seq extends bus_rgm_base_sequence;

		`uvm_object_utils(aux_reg_seq)

		function new(string name = "aux_reg_seq");
			super.new(name);
		endfunction

		task body;
			super.body();
			random_write("RGPIO_AUX");
		endtask: body
	endclass: aux_reg_seq

	class diag_outputs extends bus_rgm_base_sequence;

		`uvm_object_utils(diag_outputs)

		function new(string name = "diag_outputs");
			super.new(name);
		endfunction

		task body;
			super.body();
			gpio_rgm.RGPIO_OUT.write(status, 32'haaaa_aaaa);
			gpio_rgm.RGPIO_OUT.write(status, 32'h5555_5555);
			#100ns;
			gpio_rgm.RGPIO_AUX.write(status, 32'hFFFF_FFFF);
		endtask: body
	endclass: diag_outputs
endpackage 