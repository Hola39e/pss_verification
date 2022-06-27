package gpio_register_pkg;

    import uvm_pkg::*;
    `include "uvm_marcos.svh"
    import uvm_register_pkg::*;
    import apb_agent_pkg::*;

    typedef struct packed {logic[31:0] bits;} word_t;
    typedef struct packed {bit [29:0] reserved; bit INTS; bit INTE;} RGPIO_CTRL_t;

    // gpio input register read only
    class rgpio_ro extends uvm_register #(word_t);
        function new(string l_name = "registername", uvm_named_object p = null);
            super.new(l_name, p);
            resetValue = 32'h0;
            register_type = "R0";
            data = 32'h0;
        endfunction
    endclass

    // This is for most of the registers in the GPIO which are 32 bit r/w
    class rgpio_rw extends uvm_register #(word_t);

    function new(string l_name = "registerName",
                 uvm_named_object p = null);
      super.new(l_name, p);
      resetValue = 32'h0;
      register_type = "RW";
      data = 32'h0;
    endfunction
    
    endclass: rgpio_rw
    
    // This is for the control register
    class rgpio_ctrl extends uvm_register #(RGPIO_CTRL_t);
    
    function new(string l_name = "registerName",
                 uvm_named_object p = null);
      super.new(l_name, p);
      resetValue = 32'h0;
      register_type = "RW";
      data = 32'h0;
    endfunction
    
    endclass: rgpio_ctrl

    
endpackage