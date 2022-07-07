class gpio_rgm_input_read_test extends gpio_rgm_test_base;
	
    `uvm_component_utils(gpio_rgm_input_read_test)

    extern function new(string name = "gpio_rgm_input_read_test", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

function gpio_rgm_input_read_test::new(string name = "gpio_rgm_input_read_test", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void gpio_rgm_input_read_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env_cfg.has_reg_scoreboard = 0;
endfunction: build_phase

task gpio_rgm_input_read_test::run_phase(uvm_phase phase);
    GPI_rgm_input_read_vseq test_seq = GPI_rgm_input_read_vseq::type_id::create("test_seq");
    phase.raise_objection(this, "gpio_input_test");
    test_seq.start(m_env.m_v_sqr);
    #1000ns;
    phase.drop_objection(this, "gpio_input_test");
endtask: run_phase