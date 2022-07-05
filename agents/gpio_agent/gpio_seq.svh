class gpio_seq extends uvm_sequence #(gpio_seq_item);
    `uvm_object_utils(gpio_seq)

    extern function new(string name = "gpio_seq");
    extern task body;
endclass

function gpio_seq::new(string name = "gpio_seq");
    super.new(name);
endfunction

task gpio_seq::body;
    gpio_seq_item req;

    begin
    req = gpio_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize());
    finish_item(req);
    end

endtask:body