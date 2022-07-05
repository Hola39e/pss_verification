class gpio_agent extends uvm_component;

    `uvm_component_utils(gpio_agent)
    gpio_agent_config m_cfg;

    // use for monitor port
    // monitor
    uvm_analysis_port #(gpio_seq_item) ap;
    uvm_analysis_port #(gpio_seq_item) ext_ap;  

    gpio_monitor   m_monitor;
    gpio_sequencer m_sequencer;
    gpio_driver    m_driver;

    extern function new(string name = "gpio_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass

function gpio_agent::new(string name = "gpio_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void gpio_agent::build_phase(uvm_phase phase);

    if (!uvm_config_db #(gpio_agent_config)::get(this, "", "gpio_agent_config", m_cfg) )
    `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration gpio_agent_config from uvm_config_db. Have you set() it?")
    uvm_config_db #(gpio_agent_config)::set(this, "*","gpio_agent_config",m_cfg);

      // Monitor is always present
    m_monitor = gpio_monitor::type_id::create("m_monitor", this);
    // Only build the driver and sequencer if active
    if(m_cfg.active == UVM_ACTIVE) begin
        m_driver = gpio_driver::type_id::create("m_driver", this);
        m_sequencer = gpio_sequencer::type_id::create("m_sequencer", this);
    end
endfunction

function void gpio_agent::connect_phase(uvm_phase phase);
    m_monitor.GPIO = m_cfg.GPIO;
    ap = m_monitor.ap;
    if(m_cfg.monitor_external_clock == 1) begin
        ext_ap = m_monitor.ext_ap;
    end
    // Only connect the driver and the sequencer if active
    if(m_cfg.active == UVM_ACTIVE) begin
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        m_driver.GPIO = m_cfg.GPIO;
    end
endfunction: connect_phase