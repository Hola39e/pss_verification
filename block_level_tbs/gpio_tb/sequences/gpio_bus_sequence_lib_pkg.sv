package gpio_bus_sequence_lib_pkg


    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    import apb_agent_pkg::*;
    import uvm_register_pkg::*;
    //import gpio_register_pkg::*;
    import gpio_env_pkg::*;
    import register_layering_pkg::*;

    class bus_base_sequence extends uvm_sequence #(uvm_sequence_item);
        `uvm_object_utils(bus_base_sequence);
        rand logic [31:0] address;
        rand logic [31:0] seq_data;

        string reg_name = "gpio_reg_file.GPO_reg";

        gpio_env_config m_cfg;
        uvm_register_map gpio_rm;
        register_adapter_base adapter;

        function new(string name = "bus_base_sequence");
            super.new(name);
        endfunction

        task body();
            if(!uvm_config_db #(gpio_env_config)::get(m_sequencer, "", "gpio_env_config", m_cfg))
                `uvm_fatal("CONFIGLOAD", "Cannnot get Config gpio_env_config")
            gpio_rm = m_cfg.gpio_rm;
            adapter = register_adapter_base::type_id::create("adapter", "gpio_bus");
            adapter.m_bus_sequencer = m_sequencer;
        endtask

        task read()
            bit addr_valid;
            register_seq_item register_read = register_seq_item::type_id::create("register_read");

            $cast(register_read.address, gpio_rm.lookup_register_address_by_name(write_reg, addr_valid));
            adapter.read(register_read)
            seq_data = register_read.data;
        endtask

        task write();
            register_seq_item register_write = register_seq_item::type_id::create("register_write");
            bit addr_valid;

            $cast(register_write.address, gpio_rm.lookup_register_address_by_name(write_reg, addr_valid));
            register_write.data = write_data;
            adapter.write(register_write);
        endtask

        task random_write(string write_reg);
            register_seq_item register_write = register_seq_item::type_id::create("register_write");
            bit addr_valid;

            assert(register_write.randomize());
            $cast(register_write.address, gpio_rm.lookup_register_address_by_name(write_reg, addr_valid));
            adapter.write(register_write);
        endtask
    endclass

    
endpackage