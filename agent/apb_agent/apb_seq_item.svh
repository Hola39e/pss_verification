`define uvm_record_field(NAME, VALUE) \
    $add_attribute(recorder.trhandle, VALUE, NAME);

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
    extern function void do_record(uvm_recorder recorder);
endclass