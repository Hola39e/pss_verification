package pss_register_model_pkg;
    import uvm_pkg::*;

    `include "uvm_macros.svh"

    import gpio_register_model_pkg::*;
    import spi_reg_pkg::*;

    class pss_reg_block extends uvm_reg_block;
        `uvm_object_utils(pss_reg_block)

        spi_reg_block spi_reg_blk;
        gpio_reg_block gpio_reg_blk;

        uvm_reg_map pss_reg_blk_map;


        function new(string name = "pss_reg_block");
            super.new(name, UVM_NO_COVERAGE);
        endfunction

        function void build ();
	        pss_reg_blk_map = create_map("pss_reg_blk_map", 'h0, 4, UVM_LITTLE_ENDIAN, 1);
	        default_map = pss_reg_blk_map;
	        
            spi_reg_blk = spi_reg_block::type_id::create("spi_reg_blk");
	        spi_reg_blk.configure(this,"");
	        spi_reg_blk.build();
	        spi_reg_blk.lock_model();
	        pss_reg_blk_map.add_submap(spi_reg_blk.default_map, 16'h0000);
	        
            gpio_reg_blk = gpio_reg_block::type_id::create("gpio_reg_blk");
	        gpio_reg_blk.configure(this, "");
	        gpio_reg_blk.build();
	        gpio_reg_blk.lock_model();
	        pss_reg_blk_map.add_submap(gpio_reg_blk.default_map, 16'h1000);
            lock_model();
        endfunction


    endclass
endpackage