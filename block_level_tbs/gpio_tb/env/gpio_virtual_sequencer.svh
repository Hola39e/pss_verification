class gpio_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(gpio_virtual_sequencer)

    gpio_sequencer gpi;
    gpio_sequencer aux;
    apb_sequencer apb;

    extern function new(string name = "gpio_virtual_sequencer", uvm_component parent = null);
endclass

function gpio_virtual_sequencer::new(string name = "gpio_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction
