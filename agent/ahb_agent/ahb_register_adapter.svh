class ahb_register_adapter extends register_adpter_base;

    `uvm_object_utils (ahb_register_adapter)

    function new(string name = "ahb_register_adapter");
        super.new(name);
    endfunction


    // reg item to bus 
    task read(inout register_seq_item req);
        ahb_read_seq read_seq = ahb_read_seq::type_id::create("read_seq");

        read_seq.addr = req.address;
        read_seq.start(m_bus_sequencer);
        req.data = read_seq.data;
    endtask

    task wirte(register_seq_item req);
        ahb_write_seq write_seq = ahb_write_seq::type_id::create("write_seq");

        write_seq.addr = req.address;
        write_seq.data = req.data;
        write_seq.start(m_bus_sequencer);
    endtask
endclass