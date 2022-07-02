class apb_coverage_monitor extends uvm_subscriber#(apb_seq_item);
    `uvm_component_utils(apb_coverage_monitor)

    //  Covergroup: cg_apb_cov
    //
    covergroup apb_cov;
        OPCODE: coverpoint analysis_txn.we{
            bins write = {1};
            bins read = {0};
        }
    endgroup: apb_cov

    apb_seq_item analysis_txn;

    extern function new(string name = "apb_coverage_monitor", uvm_component parent = null);
    extern function void write(T t);
    extern function void report_phase(uvm_phase phase);
endclass

function apb_coverage_monitor::new(string name = "apb_coverage_monitor", uvm_component parent = null);
    super.new(name, parent);
    apb_cov = new();
endfunction

function apb_coverage_monitor::write(T t);
    analysis_txn = t;
    apb_cov.sample();
endfunction

function void apb_coverage_monitor::report_phase(uvm_phase phase);
    // Might be a good place to do some reporting on no of analysis transactions sent etc
    
endfunction: report_phase