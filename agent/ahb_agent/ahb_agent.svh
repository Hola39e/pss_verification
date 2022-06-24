class ahb_agent extends uvm_component;
    `uvm_component_utils(ahb_agent)

    ahb_agent_config m_cfg;

    uvm_analysis_port #(ahb_seq_item) ap;
    ahb_monitor m_monitor;
    ahb_sequencer m_sequencer;
    ahb_driver m_driver;

    extern function new (string name = "ahb_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
endclass

function ahb_agent::new(string name = "ahb_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void ahb_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", m_cfg))
        `uvm_fatal("CONFIG OBJECT", "Cannot get() config object ahb_agent_config from uvm_config_db. Have you set() it?")
    
endfunction