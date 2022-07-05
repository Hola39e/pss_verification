class ahb_sequencer extends uvm_sequencer #(ahb_seq_item, ahb_seq_item);

    // UVM Factory Registration Macro
    //
    `uvm_component_utils(ahb_sequencer)
    
    // Standard UVM Methods:
    extern function new(string name="ahb_sequencer", uvm_component parent = null);
    
    endclass: ahb_sequencer
    
    function ahb_sequencer::new(string name="ahb_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction