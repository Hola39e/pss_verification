//`define uvm_record_field(NAME,VALUE) \
//    $add_attribute(recoder.tr_handle,VALUE, NAME);

class gpio_seq_item extends uvm_sequence_item;
	`uvm_object_utils(gpio_seq_item)

	rand logic[31:0] gpio;
	rand bit [31:0] use_ext_clk;
	rand bit [31:0] ext_clk_edge;

	bit ext_clk;


	extern function new(string name = "gpio_seq_item");
	extern function void do_copy(uvm_object rhs);
	extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	extern function string convert2string();
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
//extern function void do_record(uvm_recorder recorder);
endclass

function gpio_seq_item::new(string name = "gpio_seq_item");
	super.new(name);
endfunction

function void gpio_seq_item::post_randomize();
	string s;
	s = {s, "AFTER RANDOMIZATION \n"};
	s = {s, "=======================================\n"};
	s = {s, "reg_base_sequence object content is as below: \n"};
	s = {s, super.sprint()};
	s = {s, "\n=======================================\n"};
	`uvm_info(get_type_name(), s, UVM_LOW)
endfunction

function void gpio_seq_item::do_copy(uvm_object rhs);
	gpio_seq_item rhs_;

	// 父类句柄赋值给子类句柄，动态转换
	if(!$cast(rhs_, rhs)) begin
		`uvm_fatal("do_copy", "cast of rhs object failed")
	end
	super.do_copy(rhs);
	// Copy over data members:
	gpio = rhs_.gpio;
	use_ext_clk = rhs_.use_ext_clk;
	ext_clk_edge = rhs_.ext_clk_edge;
	ext_clk = rhs_.ext_clk;

endfunction:do_copy

function bit gpio_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
	gpio_seq_item rhs_;

	if(!$cast(rhs_, rhs)) begin
		`uvm_error("do_copy", "cast of rhs object failed")
		return 0;
	end
	return super.do_compare(rhs, comparer) &&
	gpio == rhs_.gpio &&
	use_ext_clk == rhs_.use_ext_clk &&
	ext_clk_edge == rhs_.ext_clk_edge &&
	ext_clk == ext_clk;

endfunction:do_compare

function string gpio_seq_item::convert2string();
	string s;

	$sformat(s, "%s\n", super.convert2string());
	$sformat(s, "%s GPIO\t%0h\n use_ext_clk\t%0h\n ext_clk_edge\t%0h\n ext_clk\t%0b", s, gpio, use_ext_clk, ext_clk_edge, ext_clk);
	return s;

endfunction:convert2string

function void gpio_seq_item::do_print(uvm_printer printer);
	if(printer.knobs.sprint == 0) begin
		$display(convert2string());
	end
	else begin
		printer.m_string = convert2string();
	end
endfunction:do_print

//function void gpio_seq_item::do_record(uvm_recorder recorder);
//    super.do_record(recorder);
//
//    // Use the record macros to record the item fields:
//    `uvm_record_field("GPIO", gpio)
//    `uvm_record_field("use_ext_clk", use_ext_clk)
//    `uvm_record_field("ext_clk_edge", ext_clk_edge)
//    `uvm_record_field("ext_clk", ext_clk)
//
//endfunction:do_record