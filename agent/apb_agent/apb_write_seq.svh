class apb_write_seq extends uvm_sequence #(apb_seq_item);

    `uvm_object_utils(apb_write_seq)

    rand logic [31:0] addr;
    rand logic [31:0] data;

    extern function new(string name = "apb_write_seq");
    extern task body;
endclass

function apb_write_seq::new(string name = "apb_write_seq");
    super.new(name);
endfunction

task apb_write_seq::body;
    apb_seq_item req = apb_seq_item::type_id::create("req");

    start_item(req);
    req.we = 1;
    req.addr = addr;
    req.data = data;
    finish_item(req);
endtask