class ahb_seq extends uvm_sequence #(ahb_seq_item)

    `uvm_object_utils(ahb_seq)
    rand bit[31:0] address;
    rand bit[31:0] data;
    rand bit we;

    extern function new(string name = "ahb_seq");
    extern task body;
endclass

function ahb_seq::new(string name = "ahb_seq");
    super.new(name);
endfunction

task ahb_seq::body();
    ahb_seq_item req;
    begin
        req = ahb_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randmize());
        finish_item(req);
    end
endtask