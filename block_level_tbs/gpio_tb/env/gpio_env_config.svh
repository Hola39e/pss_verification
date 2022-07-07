class gpio_env_config extends uvm_object;
    localparam string s_my_config_id = "gpio_env_config";
    localparam string s_no_config_id = "no config";
    localparam string s_my_config_type_error_id = "config type error";

    `uvm_object_utils(gpio_env_config)

    bit has_apb_agent = 1;
    bit has_GPO_agent = 1;
    bit has_GPOE_agent = 1;
    bit has_GPI_agent = 1;
    bit has_AUX_agent = 1;
    bit has_scoreboard = 1;
    bit has_functional_coverage = 1;
    bit has_virtual_sequencer = 1;
    bit has_reg_scoreboard = 1;
    bit has_out_scoreboard = 1;
    bit has_in_scoreboard = 1;

    apb_agent_config m_apb_agent_cfg;
    gpio_agent_config m_GPO_agent_cfg;
    gpio_agent_config m_GPOE_agent_cfg;
    gpio_agent_config m_GPI_agent_cfg;
    gpio_agent_config m_AUX_agent_cfg;

    // interrupt interface
    virtual intr_if INTR;

    //uvm_register_map gpio_rm;
	
	gpio_reg_block gpio_rgm;

    extern task wait_for_interrupt;
    extern static function gpio_env_config get_config( uvm_component c);
    // Standard UVM Methods:
    extern function new(string name = "gpio_env_config");
endclass

function gpio_env_config::new(string name = "gpio_env_config");
    super.new(name);
endfunction

function gpio_env_config gpio_env_config::get_config( uvm_component c );
    gpio_env_config t;

    if (!uvm_config_db #(gpio_env_config)::get(c, "", s_my_config_id, t) )
        `uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))

    return t;
endfunction

task gpio_env_config::wait_for_interrupt;
    @(posedge INTR.IRQ);
endtask: wait_for_interrupt
