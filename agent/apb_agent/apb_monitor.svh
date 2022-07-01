class apb_monitor extends uvm_component;
    `uvm_conponent_utils(apb_monitor);
    virtual apb_if APB;

    // connect to which psel line slave
    int apb_index = 0;

    uvm_analysis_port #(apb_seq_item) ap;

    extern function new(string name = "apb_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern function void report_phase(uvm_phase phase);
endclass

function apb_monitor::new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction

function void apb_monitor::build_phase(uvm_phase phase);
    ap = new("ap", this);
endfunction: build_phase

task apb_monitor::run_phase(uvm_phase phase)
    apb_seq_item item, cloned_item;

    item = apb_seq_item::type_id::create("item");

    forever begin
        @(posedge APB.PCLK);
        if(APB.PREADY && APB.PSEL[apb_index])begin
            item.addr = APB.PADDR;
            item.we = APB.PWRITE;
            if(APB.PWRITE)
                item.data = APB.PWDATA;
            else
                item.data = APB.PRDATA;
            $cast(cloned_item, item.clone());
            ap.write(cloned_item);
        end
    end
endtask

function void apb_monitor::report_phase(uvm_phase phase);
    // Might be a good place to do some reporting on no of analysis transactions sent etc
    
endfunction: report_phase