//`define uvm_record_field(NAME, VALUE) \
//    $add_attribute(recorder.tr_handle, VALUE, NAME);

class apb_seq_item extends uvm_sequence_item;
    `uvm_object_utils(apb_seq_item)

    rand logic [31:0] addr, data;
    rand logic we;
    rand int delay;

    bit error;

    constraint addr_alignment{
        addr [1:0] == 0;
    }

    constraint delay_bounds{
        delay inside {[1:20]};
    }

    extern function new(string name = "apb_seq_item");
    extern function void do_copy(uvm_object rhs);
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string convert2string();
    extern function void do_print(uvm_printer printer);
    //extern function void do_record(uvm_recorder recorder);
endclass

function apb_seq_item::new(string name = "apb_seq_item");
    super.new(name);
endfunction

function void apb_seq_item::do_copy(uvm_object rhs);
    apb_seq_item rhs_;

    if(!$cast(rhs_, rhs)) begin
    `uvm_fatal("do_copy", "cast of rhs object failed")
    end
    super.do_copy(rhs);
    // Copy over data members:
    addr = rhs_.addr;
    data = rhs_.data;
    we = rhs_.we;
    delay = rhs_.delay;

endfunction:do_copy

function bit apb_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
    apb_seq_item rhs_;

    if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "cast of rhs object failed")
    return 0;
    end
    return super.do_compare(rhs, comparer) &&
        addr == rhs_.addr &&
        data == rhs_.data &&
        we   == rhs_.data;
    // Delay is not relevant to the comparison
endfunction:do_compare

function string apb_seq_item::convert2string();
    string s;

    $sformat(s, "%s\n", super.convert2string());
    // Convert to string function reusing s:
    $sformat(s, "%s\n addr\t%0h\n data\t%0h\n we\t%0b\n delay\t%0d\n", s, addr, data, we, delay);
    return s;

endfunction:convert2string

function void apb_seq_item::do_print(uvm_printer printer);
    if(printer.knobs.sprint == 0) begin
    $display(convert2string());
    end
    else begin
    printer.m_string = convert2string();
    end
endfunction:do_print

//function void apb_seq_item:: do_record(uvm_recorder recorder);
//    super.do_record(recorder);
//
//    // Use the record macros to record the item fields:
//    `uvm_record_field("addr", addr)
//    `uvm_record_field("data", data)
//    `uvm_record_field("we", we)
//    `uvm_record_field("delay", delay)
//endfunction:do_record
