class uart_agent extends uvm_agent;

    `uvm_component_utils(uart_agent)

    uvm_analysis_port #(uart_seq_item) ap;

    uart_driver m_uart_driver;
    uart_sequencer m_uart_sequencer;
    uart_monitor m_uart_monitor;

    uart_agent_config cfg;

    extern function new (string name = "uart_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass



function uart_agent::new (string name = "uart_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void uart_agent::build_phase(uvm_phase phase);
    ap = new("APB monitor", this);
    m_uart_monitor = uart_monitor::type_id::create("m_uart_monitor", this);
    if(!uvm_config_db#(uart_agent_config)::get(this, "", "uart_agent_config", cfg))
        `uvm_fatal("CONFIG LOAD", "in uart config db");
    if(cfg.ACTIVE)begin
        m_uart_driver = uart_driver::type_id::create("m_uart_driver", this);
        m_uart_sequencer = uart_sequencer::type_id::create("m_uart_sequencer", this);
    end
endfunction

function void uart_agent::connect_phase(uvm_phase phase);
    m_uart_driver.seq_item_port.connect(m_uart_sequencer.seq_item_port);
    $display("UART_ANGENT_CONGFIG using in: %s", cfg);
    m_uart_monitor.sline = cfg.sline;
    if(cfg.ACTIVE)
        m_uart_driver.sline = cfg.sline;
    m_uart_monitor.ap.connect(ap);
endfunction