class uart_seq_item extends uvm_sequence_item;

    rand int delay;
    rand bit sbe;
    rand int sbe_clks;
    rand logic[7:0] data;
    rand bit fe;
    rand logic [7:0] lcr;
    rand bit pr;
    rand logic [15:0] baud_divisor;

    constraint BR_DIVEDE {baud_divisor == 16'h02;}

    
endclass