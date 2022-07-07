class apb2reg_adapter extends uvm_reg_adapter;
	`uvm_object_utils(apb2reg_adapter)


	function new(string name = "apb2reg_adapter");
		super.new(name);
		//provides_responses = 1;
	endfunction

	function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		//USER TODO
		apb_seq_item t = apb_seq_item::type_id::create("t");
		t.we = (rw.kind == UVM_WRITE) ? 1 : 0;
		t.addr = rw.addr;
		t.data = rw.data;
		return t;
	endfunction
	function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		//USER TODO
		apb_seq_item t;
		if(!$cast(t, bus_item))begin
			`uvm_fatal("CAST FAILED", "IN the rgm bus2reg")
			return;
		end
		rw.kind = (t.we == 1) ? UVM_WRITE : UVM_READ;
		rw.addr = t.addr;
		rw.data = t.data;
		rw.status = UVM_IS_OK;
	endfunction
endclass