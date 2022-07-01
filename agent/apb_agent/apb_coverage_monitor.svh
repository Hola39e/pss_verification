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
endclass