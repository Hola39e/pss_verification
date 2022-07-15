class pss_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
    `uvm_component_utils(pss_virtual_sequencer)

    gpio_sequencer gpi;
    spi_sequencer spi;
    ahb_sequencer ahb;
    extern function new(string name = "pss_virtual_sequencer", uvm_component parent = null);

endclass: pss_virtual_sequencer

function pss_virtual_sequencer::new(string name = "pss_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction