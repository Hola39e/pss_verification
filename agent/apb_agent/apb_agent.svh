class apb_agent extends uvm_conponent;

    `uvm_component_utils(apb_agent)

    apb_agent_config m_cfg;

    uvm_analysis_port #(apb_seq_item) ap;
    apb_monitor m_monitor;
    apb_sequencer m_sequencer;
    apb_driver m_driver;
    apb_coverage_monitor m_fcov_monitor;

    extern function new(string name = "apb_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass

function apb_agent::new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void apb_agent::build_phase(uvm_phase phase);
    if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config",m_cfg));
        `uvm_fatal("CONFIGLOAD", "apb_agent get config failed")

    m_monitor = apb_monitor::type_id::create("m_monitor", this);

    if(m_cfg.active == UVM_ACTIVE)begin
        m_driver = apb_driver::type_id::create("m_driver", this);
        m_sequencer = apb_sequencer::type_id::create("m_sequencer", this);
    end

    if(m_cfg.has_functional_coverage)begin
        m_fcov_monitor = apb_coverage_monitor::type_id::create("m_fcov_monitor", this);
    end
endfunction

function void apb_agent::connect_phase(uvm_phase phase)
    // 传递vif 句柄
    m_monitor.APB = m_cfg.APB;
    // 传递index
    m_monitor.apb_index = m_cfg.apb_index;

    // 链接port
    ap = m_monitor.ap;

    if(m_cfg.active == UVM_ACTIVE)begin
        // driver.seq_item_port to sequencer seq_item_export
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end

    if(m_cfg.has_functional_coverage)begin
        m_monitor.ap.connect(m_fcov_monitor.analysis_export);
    end
endfunction