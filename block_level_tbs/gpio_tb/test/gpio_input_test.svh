class gpio_input_test extends gpio_test_base;
    `uvm_component_utils(gpio_input_test)

    extern function new(string name = "gpio_input_test", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

function gpio_input_test::new(string name = "gpio_input_test", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void gpio_input_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env_cfg.has_reg_scoreboard = 0;
endfunction: build_phase

task gpio_input_test::run_phase(uvm_phase phase);
    GPI_test_vseq test_seq = GPI_test_vseq::type_id::create("test_seq");
    phase.raise_objection(this, "gpio_input_test");

    test_seq.start(m_env.m_v_sqr);

    #100ns;
    phase.drop_objection(this, "gpio_input_test");
endtask: run_phase