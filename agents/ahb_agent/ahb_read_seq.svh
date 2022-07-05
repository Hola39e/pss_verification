class ahb_read_seq extends uvm_sequence #(ahb_seq_item);

    `uvm_object_utils(ahb_read_seq);

    // members
    rand logic [31:0] addr;
    logic [31:0] data;

    extern function new(string name = "ahb_read_seq");
    extern task body;
endclass

function ahb_read_seq::new(string name = "ahb_read_seq");
    super.new(name);
endfunction

task ahb_read_seq::body();
    ahb_seq_item req = ahb_seq_item::type_id::create("req");

    begin
        start_item(req);
        req.HWRITE = AHB_READ;
        req.HADDR = addr;
        finish_item(req);
        data = req.DATA;
    end
endtask