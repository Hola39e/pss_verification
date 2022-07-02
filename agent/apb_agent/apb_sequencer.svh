class apb_sequencer extends uvm_seqeuncer #(apb_seq_item, apb_seq_item);

    `uvm_component_utils(apb_sequencer)
    extern function new(string name="apb_sequencer", uvm_component parent = null);
endclass

function apb_sequencer::new(string name="apb_sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction
