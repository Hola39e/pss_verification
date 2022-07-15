
class ahb2reg_adapter extends uvm_reg_adapter;
	`uvm_object_utils(ahb2reg_adapter)


	function new(string name = "ahb2reg_adapter");
		super.new(name);
		//provides_responses = 1;
	endfunction

	function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		//USER TODO
		ahb_seq_item t = ahb_seq_item::type_id::create("t");
		t.HWRITE = (rw.kind == UVM_WRITE) ? AHB_WRITE : AHB_READ;
		t.HADDR = rw.addr;
		t.DATA = rw.data;
		return t;
	endfunction
	function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		//USER TODO
		ahb_seq_item t;
		if(!$cast(t, bus_item))begin
			`uvm_fatal("CAST FAILED", "IN the rgm bus2reg")
			return;
		end
		rw.kind = (t.HWRITE == 1) ? UVM_WRITE : UVM_READ;
		rw.addr = t.HADDR;
		rw.data = t.DATA;
		rw.status = UVM_IS_OK;
	endfunction
endclass