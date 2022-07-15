
class pss_test_base extends uvm_test;

    `uvm_component_utils(pss_test_base)

    pss_env m_env;
    pss_env_config m_env_cfg;
    spi_env_config m_spi_env_cfg;
    gpio_env_config m_gpio_env_cfg;
    //uart_env_config m_uart_env_cfg;
    apb_agent_config m_spi_apb_agent_cfg;
    apb_agent_config m_gpio_apb_agent_cfg;
    ahb_agent_config m_ahb_agent_cfg;
    spi_agent_config m_spi_agent_cfg;
    gpio_agent_config m_GPO_agent_cfg;
    gpio_agent_config m_GPI_agent_cfg;
    gpio_agent_config m_GPOE_agent_cfg;
	
	// reg model -----------------------
	apb2reg_adapter apb_adapter;
	pss_reg_block pss_rgm;
	ahb2reg_adapter ahb_adapter;
	

    extern function new(string name = "spi_test_base", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual function void configure_apb_agent(apb_agent_config cfg, int index, 
                    logic[31:0] start_address, logic[31:0] range);

endclass

function pss_test_base::new(string name = "spi_test_base", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void pss_test_base::build_phase(uvm_phase phase);
    m_env_cfg = pss_env_config::type_id::create("m_env_cfg");
    // Register map - Keep reg_map a generic name for vertical reuse reasons
	pss_rgm = pss_reg_block::type_id::create("pss_rgm", this);
	pss_rgm.configure(null, "");
	pss_rgm.build();
	pss_rgm.lock_model();
	pss_rgm.reset();
	apb_adapter = new("apb_adapter");
	ahb_adapter = new("ahb_adapter");
	
	m_env_cfg.pss_rgm = pss_rgm;
    // SPI Sub-env configuration:
    m_spi_env_cfg = spi_env_config::type_id::create("m_spi_env_cfg");
    // apb agent in the SPI env:
    m_spi_env_cfg.has_apb_agent = 1;
    m_spi_apb_agent_cfg = apb_agent_config::type_id::create("m_spi_apb_agent_cfg");
    configure_apb_agent(m_spi_apb_agent_cfg, 0, 32'h0, 32'h18);
    if (!uvm_config_db #(virtual apb_if)::get(this, "", "APB_vif", m_spi_apb_agent_cfg.APB))
      `uvm_fatal("VIF CONFIG", "Cannot get() interface APB_vif from uvm_config_db. Have you set() it?")
    m_spi_env_cfg.m_apb_agent_cfg = m_spi_apb_agent_cfg;
    // SPI agent:
    m_spi_agent_cfg = spi_agent_config::type_id::create("m_spi_agent_cfg");
    if (!uvm_config_db #(virtual spi_if)::get(this, "", "SPI_vif", m_spi_agent_cfg.SPI))
      `uvm_fatal("VIF CONFIG", "Cannot get() interface APB_vif from uvm_config_db. Have you set() it?")
    m_spi_env_cfg.m_spi_agent_cfg = m_spi_agent_cfg;
    m_env_cfg.m_spi_env_cfg = m_spi_env_cfg;
    uvm_config_db #(spi_env_config)::set(this, "*", "spi_env_config", m_spi_env_cfg);
    // GPIO env configuration:
    m_gpio_env_cfg = gpio_env_config::type_id::create("m_gpio_env_cfg");
    m_gpio_env_cfg.has_apb_agent = 1; // APB agent used
    m_gpio_apb_agent_cfg = apb_agent_config::type_id::create("m_gpio_apb_agent_cfg");
    configure_apb_agent(m_gpio_apb_agent_cfg, 1, 32'h100, 32'h124);
    if (!uvm_config_db #(virtual apb_if)::get(this, "", "APB_vif", m_gpio_apb_agent_cfg.APB))
      `uvm_fatal("VIF CONFIG", "Cannot get() interface APB_vif from uvm_config_db. Have you set() it?")
    m_gpio_env_cfg.m_apb_agent_cfg = m_gpio_apb_agent_cfg;
    m_gpio_env_cfg.has_functional_coverage = 1; // Register coverage no longer valid
    // GPO agent
    m_GPO_agent_cfg = gpio_agent_config::type_id::create("m_GPO_agent_cfg");
    if (!uvm_config_db #(virtual gpio_if)::get(this, "", "GPO_vif", m_GPO_agent_cfg.GPIO))
      `uvm_fatal("VIF CONFIG", "Cannot get() interface APB_vif from uvm_config_db. Have you set() it?")
    m_GPO_agent_cfg.active = UVM_PASSIVE; // Only monitors
    m_gpio_env_cfg.m_GPO_agent_cfg = m_GPO_agent_cfg;
    // GPOE agent
    m_GPOE_agent_cfg = gpio_agent_config::type_id::create("m_GPOE_agent_cfg");
    if (!uvm_config_db #(virtual gpio_if)::get(this, "", "GPOE_vif", m_GPOE_agent_cfg.GPIO))
      `uvm_fatal("VIF CONFIG", "Cannot get() interface GPOE_vif from uvm_config_db. Have you set() it?")
    m_GPOE_agent_cfg.active = UVM_PASSIVE; // Only monitors
    m_gpio_env_cfg.m_GPOE_agent_cfg = m_GPOE_agent_cfg;
    // GPI agent - active (default)
    m_GPI_agent_cfg = gpio_agent_config::type_id::create("m_GPI_agent_cfg");
    if (!uvm_config_db #(virtual gpio_if)::get(this, "", "GPI_vif", m_GPI_agent_cfg.GPIO))
      `uvm_fatal("VIF CONFIG", "Cannot get() interface GPI_vif from uvm_config_db. Have you set() it?")
    m_gpio_env_cfg.m_GPI_agent_cfg = m_GPI_agent_cfg;
    // GPIO Aux agent not present
    m_gpio_env_cfg.has_AUX_agent = 0;
    m_gpio_env_cfg.has_functional_coverage = 1;
    m_gpio_env_cfg.has_virtual_sequencer = 0;
    m_gpio_env_cfg.has_reg_scoreboard = 0;
    m_gpio_env_cfg.has_out_scoreboard = 1;
    m_gpio_env_cfg.has_in_scoreboard = 1;
    m_env_cfg.m_gpio_env_cfg = m_gpio_env_cfg;
    uvm_config_db #(gpio_env_config)::set(this, "*", "gpio_env_config", m_gpio_env_cfg);
    // AHB Agent
    m_ahb_agent_cfg = ahb_agent_config::type_id::create("m_ahb_agent_cfg");
    if (!uvm_config_db #(virtual ahb_if)::get(this, "", "AHB_vif", m_ahb_agent_cfg.AHB))
      `uvm_fatal("VIF CONFIG", "Cannot get() interface AHB_vif from uvm_config_db. Have you set() it?")
    m_env_cfg.m_ahb_agent_cfg = m_ahb_agent_cfg;
    // Add in interrupt line
    if (!uvm_config_db #(virtual icpit_if)::get(this, "", "ICPIT_vif", m_env_cfg.ICPIT))
      `uvm_fatal("VIF CONFIG", "Cannot get() interface ICPIT_vif from uvm_config_db. Have you set() it?")
    uvm_config_db #(pss_env_config)::set(this, "*", "pss_env_config", m_env_cfg);
    m_env = pss_env::type_id::create("m_env", this);
    // Override for register adapters:
    
endfunction: build_phase

function void pss_test_base::configure_apb_agent(apb_agent_config cfg, int index, logic[31:0] start_address, logic[31:0] range);
    cfg.active = UVM_PASSIVE;
    cfg.has_functional_coverage = 0;
    cfg.has_scoreboard = 0;
    cfg.no_select_lines = 1;
    cfg.apb_index = index;
    cfg.start_address[0] = start_address;
    cfg.range[0] = range;
  endfunction: configure_apb_agent