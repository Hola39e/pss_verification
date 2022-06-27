class ahb_write_seq extends uvm_sequence #(ahb_seq_item)

    `uvm_object_utils(ahb_write_seq)

    rand logic [31:0] addr;
    rand logic [31:0] data;
    extern function new(string name = "ahb_write_seq");
    extern task body;
endclass

function ahb_write_seq::new(string name = "ahb_write_seq");
    super.new(name);
    endfunction
    
task ahb_write_seq::body;
    ahb_seq_item req = ahb_seq_item::type_id::create("req");

    begin
        start_item(req);
        req.HWRITE = AHB_WRITE;
        req.HADDR = addr;
        req.DATA = data;
        finish_item(req);
    end
endtask