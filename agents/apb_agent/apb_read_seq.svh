// TODO: seems to randomize here?
class apb_read_seq extends uvm_sequence #(apb_seq_item);

    `uvm_object_utils(apb_read_seq)
    
    rand logic [31:0] addr;
    // this is read seq, so no need to randomize the read data
    logic data;

    extern function new (string name = "apb_read_seq");
    extern task body();
endclass

function apb_read_seq::new(string name = "apb_read_seq");
    super.new(name);
endfunction

task apb_read_seq::body;

    apb_seq_item req = apb_seq_item::type_id::create("req");

    begin
        start_item(req);
        req.we = 0;
        req.addr = addr;
        finish_item(req);
        data = req.data;
    end
endtask