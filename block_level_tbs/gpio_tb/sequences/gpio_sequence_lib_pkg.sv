package gpio_sequence_lib_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import gpio_agent_pkg::*;

    class gpio_aux_seq extends uvm_sequence #(gpio_seq_item);
        `uvm_object_utils(gpio_aux_seq)

        function new(string name = "gpio_aux_seq");
            super.new(name);
        endfunction

        task body;
            gpio_seq_item aux_pkt = gpio_seq_item::type_id::create("aux_pkt");

            forever begin
                start_item(aux_pkt);
                assert(aux_pkt.randomize() with {use_ext_clk == 0;});
                finish_item(aux_pkt);
            end
        endtask
    endclass
endpackage