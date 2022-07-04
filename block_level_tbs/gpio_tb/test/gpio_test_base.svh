class gpio_test_base extends uvm_test;
    `uvm_component_utils(gpio_test_base)

    gpio_env m_env; // The environment class
    gpio_env_config m_env_cfg;
    apb_agent_config m_apb_cfg;
    gpio_agent_config m_GPO_cfg;
    gpio_agent_config m_GPOE_cfg;
    gpio_agent_config m_GPI_cfg;
    gpio_agent_config m_AUX_cfg;
    gpio_register_map gpio_rm;

    extern virtual function void configure_apb_agent(apb_agent_config cfg);

    extern function new(string name = "gpio_test_base", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
endclass

function void gpio_test_base::build_phase(uvm_phase phase);

    // create the config
    m_env_cfg = gpio_env_config::type_id::create("m_env_cfg", this);

    gpio_rm = new("reg_map", null);

    m_env_cfg.gpio_rm = gpio_rm;
    m_apb_cfg = apb_agent_config::type_id::create("m_apb_cfg", this);

    if (!uvm_config_db #(virtual apb_if)::get(this, "", "APB_vif", m_apb_cfg.APB))
    `uvm_fatal("VIF CONFIG", "Cannot get() interface APB_vif from uvm_config_db. Have you set() it?")
    configure_apb_agent(m_apb_cfg);

    m_GPO_cfg = gpio_agent_config::type_id::create("m_GPO_cfg", this);
    if (!uvm_config_db #(virtual gpio_if)::get(this, "", "GPO_vif", m_GPO_cfg.GPIO))
        `uvm_fatal("VIF CONFIG", "Cannot get() interface GPO_vif from uvm_config_db. Have you set() it?")
    m_env_cfg.m_GPO_agent_cfg = m_GPO_cfg;

    m_GPOE_cfg = gpio_agent_config::type_id::create("m_GPOE_cfg", this);
    if (!uvm_config_db #(virtual gpio_if)::get(this, "", "GPOE_vif", m_GPOE_cfg.GPIO))
        `uvm_fatal("VIF CONFIG", "Cannot get() interface GPOE_vif from uvm_config_db. Have you set() it?")
    m_env_cfg.m_GPOE_agent_cfg = m_GPOE_cfg;

    m_GPI_cfg = gpio_agent_config::type_id::create("m_GPI_cfg", this);
    m_GPI_cfg.monitor_external_clock = 1; // Need to monitor the external clock
    if (!uvm_config_db #(virtual gpio_if)::get(this, "", "GPI_vif", m_GPI_cfg.GPIO))
        `uvm_fatal("VIF CONFIG", "Cannot get() interface GPI_vif from uvm_config_db. Have you set() it?")
    m_env_cfg.m_GPI_agent_cfg = m_GPI_cfg;

    m_AUX_cfg = gpio_agent_config::type_id::create("m_AUX_cfg", this);
    if (!uvm_config_db #(virtual gpio_if)::get(this, "", "AUX_vif", m_AUX_cfg.GPIO))
        `uvm_fatal("VIF CONFIG", "Cannot get() interface AUX_vif from uvm_config_db. Have you set() it?")
    m_env_cfg.m_AUX_agent_cfg = m_AUX_cfg;

    // Assign the Interrupt virtual interface to the env config
    if (!uvm_config_db #(virtual intr_if)::get(this, "", "INTR_vif", m_env_cfg.INTR))
        `uvm_fatal("VIF CONFIG", "Cannot get() interface INTR_vif from uvm_config_db. Have you set() it?")
    uvm_config_db #(gpio_env_config)::set(this,"*","gpio_env_config", m_env_cfg);
    
    m_env = gpio_env::type_id::create("m_env", this);
    register_adapter_base::type_id::set_inst_override(apb_register_adapter::get_type(), "gpio_bus.adapter");


endfunction

function gpio_test_base::new(string name = "gpio_test_base", uvm_component parent = null);
    super.new(name, parent);
endfunction

virtual task gpio_test_base::run_phase(uvm_phase phase);

endtask: run_phase

function gpio_test_base::configure_apb_agent(apb_agent_config cfg);
    cfg.active = UVM_ACTIVE;
    cfg.has_functional_coverage = 0;
    cfg.has_scoreboard = 0;

    cfg.no_select_line = 1;
    cfg.start_address[0] = 32'h0;
    cfg.range[0] = 32'h24;
endfunction