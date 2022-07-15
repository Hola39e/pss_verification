class bridge_basic_rw_vseq extends uvm_sequence #(ahb_seq_item);

`uvm_object_utils(bridge_basic_rw_vseq)

function new(string name = "bridge_basic_rw_vseq");
  super.new(name);
endfunction

task body;
  ahb_seq_item req = ahb_seq_item::type_id::create("req");

  repeat(10) begin
    start_item(req);
    assert(req.randomize() with {HADDR inside {[0:32'h18], [32'h100:32'h124], [32'h200:32'h210], [32'h300:32'h318]};
                                 HWRITE == AHB_READ;});
    finish_item(req);
    $display("%t: Read %0h from %0h", $time, req.DATA, req.HADDR);
  end
endtask: body

endclass:bridge_basic_rw_vseq