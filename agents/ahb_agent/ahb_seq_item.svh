// Questa recording macro:

`define uvm_record_field(NAME,VALUE) \
    $add_attribute(recorder.tr_handle,VALUE,NAME);

class ahb_seq_item extends uvm_sequence_item;

    `uvm_object_utils(ahb_seq_item)

    rand bit[31:0] HADDR;
    rand bit[31:0] DATA;
    rand ahb_rw_e HWRITE;

    ahb_resp_e HRESP;

    constraint addr_align {HADDR[1:0] == 2'b00;};

    extern function new (string name = "ahb_seq_item");
    extern function void do_copy(uvm_object rhs);
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string convert2string();
    extern function void do_print(uvm_printer printer);
    extern function void do_record(uvm_recorder recorder);
endclass

function void ahb_seq_item::do_copy(uvm_object rhs);

    ahb_seq_item item_copy;

    if(!$cast(item_copy, rhs))begin
        `uvm_fatal("do_copy", "cast of object FAILED!");
    end

    super.do_copy();

    HADDR = item_copy.HADDR;
    DATA = item_copy.DATA;
    HWRITE = item_copy.HWRITE;
    HRESP = item_copy.HRESP;
endfunction

function bit ahb_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
    ahb_seq_item rhs_;
    
    if(!$cast(rhs_, rhs)) begin
        `uvm_error("do_copy", "cast of rhs object failed")
        return 0;
    end
    return super.do_compare(rhs, comparer) && HADDR == rhs_.HADDR && DATA == rhs_.DATA &&
        HWRITE == rhs_.HWRITE &&
        HRESP == rhs_.HRESP;
           // <var_name> == rhs_.<var_name>;
endfunction:do_compare

function string ahb_seq_item::convert2string();
    string s;
  
    $sformat(s, "%s\n", super.convert2string());
    // Convert to string function reusing s:
    // $sformat(s, "%s <var_name>\t%0h\n", s, <var_name>);
    $sformat(s, "%s HADDR\t%0h\n DATA\t%0h\n HWRITE\t%s\n HRESP\t%s", s, HADDR, DATA, HWRITE.name(), HRESP.name());
    return s;
  
  endfunction:convert2string
  
  function void ahb_seq_item::do_print(uvm_printer printer);
    if(printer.knobs.sprint == 0) begin
      $display(convert2string());
    end
    else begin
      printer.m_string = convert2string();
    end
  endfunction:do_print
  
  function void ahb_seq_item:: do_record(uvm_recorder recorder);
    super.do_record(recorder);
  
    // Use the record macros to record the item fields:
    //`uvm_record_field("<var_name>", <var_name>)
  endfunction:do_record