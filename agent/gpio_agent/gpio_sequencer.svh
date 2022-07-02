class gpio_sequencer extends uvm_sequencer;
    `uvm_component_utils(gpio_sequencer)

    extern function new(string name = "gpio_sequencer", uvm_component parent = null);
endclass

function gpio_sequencer::new(string name="gpio_sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction