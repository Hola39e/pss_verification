class pss_env extends uvm_env;

    `uvm_component_utils(pss_env)

    pss_env_config m_cfg;

    spi_env m_spi_env;
    gpio_env m_gpio_env;
    ahb_agent m_ahb_agent;
    pss_virtual_sequencer m_vsqr;
	

    extern function new(string name = "pss_env", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass

function pss_env::new(string name = "pss_env", uvm_component parent = null);
    super.new(name, parent);
endfunction

// build phase is to connect config and create to env and agents and virtual sqr
function void pss_env::build_phase(uvm_phase phase);
    // from test_base to get
    if (!uvm_config_db #(pss_env_config)::get(this, "", "pss_env_config", m_cfg) )
    `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration pss_env_config from uvm_config_db. Have you set() it?")
    
    // for sub_env to set
    if(m_cfg.has_spi_env) begin
    uvm_config_db #(spi_env_config)::set(this, "m_spi_env*", "spi_env_config", m_cfg.m_spi_env_cfg);
    m_spi_env = spi_env::type_id::create("m_spi_env", this);
    end
    if(m_cfg.has_gpio_env) begin
    uvm_config_db #(gpio_env_config)::set(this, "m_gpio_env*", "gpio_env_config", m_cfg.m_gpio_env_cfg);
    m_gpio_env = gpio_env::type_id::create("m_gpio_env", this);
    end
    if(m_cfg.has_ahb_agent) begin
    uvm_config_db #(ahb_agent_config)::set(this, "m_ahb_agent*", "ahb_agent_config", m_cfg.m_ahb_agent_cfg);
    m_ahb_agent = ahb_agent::type_id::create("m_ahb_agent", this);
    end
    if(m_cfg.has_virtual_sequencer) begin
    m_vsqr = pss_virtual_sequencer::type_id::create("m_vsqr", this);
    end
endfunction: build_phase

// connect phase is connect the virtual sqr to the driver
function void pss_env::connect_phase(uvm_phase phase);
    if(m_cfg.has_virtual_sequencer) begin
    if(m_cfg.has_spi_env) begin
        m_vsqr.spi = m_spi_env.m_spi_agent.m_sequencer;
    end
    if(m_cfg.has_gpio_env) begin
        m_vsqr.gpi = m_gpio_env.m_GPI_agent.m_sequencer;
    end
    if(m_cfg.has_ahb_agent) begin
        m_vsqr.ahb = m_ahb_agent.m_sequencer;
    end
    end
endfunction: connect_phase