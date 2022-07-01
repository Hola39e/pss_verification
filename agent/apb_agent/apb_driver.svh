class apb_driver extends uvm_driver #(apb_seq_item, apb_seq_item);
    `uvm_component_utils(apb_driver)

    vitual apb_if APB;

    apb_agent_config m_cfg;

    extern function int sel_lookup(logic [31:0] address);
    extern function new (string name = "apb_driver", uvm_component parent = null);
    extern task run_phase(uvm_phase phase);
    extern function void build_phase(uvm_phase phase);
endclass

function apb_driver::new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction

task apb_driver::run_phase(uvm_phase phase)
    apb_seq_item req,rsp;
    int psel_index;

    forever begin
        // need to compare with rkv
        APB.PSEL <= 0;
        APB.PENABLE <= 0;
        APB.PADDR <= 0;
        seq_item_port.get_next_item(req);
        repeat(req.delay)
            @(posedge APB.PCLK);
        psel_index = sel_lookup(req.addr);  // 这里起到的arbiter的作用，选择那个apb slave
        if(psel_index >= 0)begin
            // setup state
            APB.PSEL[psel_index] <= 1;
            APB.PADDR <= req.addr;
            APB.PWDATA <= req.data;
            APB.PWRITE <= req.we;
            @(posedge APB.PCLK);
                APB.PENABLE <= 1'b1;
            while(!APB.PREADY)
                @(posedge APB.CLK);
            if(APB.PWRITE == 0)
                req.data = APB.PRDATA;
        end
        else begin
            `uvm_error("RUNPHASE APBAGENT", $sformatf("[decode]ACCESS to addr %h out of range", req.addr));
            req.error = 1;
        end
        seq_item_port.item_done();
    end

endtask

function void apb_driver::build_phase(uvm_phase phase);
    if (!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg) )
        `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration apb_agent_config from uvm_config_db. Have you set() it?")
endfunction: build_phase

function int apb_driver::sel_lookup(logic[31:0] address);
    for(int i = 0; i<m_cfg.no_select_lines; i++)begin
        if(address >= m_cfg.start_address[i] && (address <= (m_cfg.start_address[i] + m_cfg.range[i])))
            return i;
    end
    return -1;
endfunction
