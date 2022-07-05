package gpio_virtual_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    import apb_agent_pkg::*;
    import gpio_agent_pkg::*;
    import gpio_env_pkg::*;
    import gpio_bus_sequence_lib_pkg::*;
    import gpio_sequence_lib_pkg::*;

    `define INTS 32'h1c

    // interrupt service routine at the apb level
    class gpio_isr extends uvm_sequence #(apb_seq_item);
        `uvm_object_utils(gpio_isr)

        function new(string name = "isr");
            super.new(name);
        endfunction

        task body;

            // 占有总线
            m_sequencer.grab(this); // Exclusive access
            cmd.addr = `INTS;
            cmd.we = 0;
            cmd.delay = 0;
            start_item(cmd);
            finish_item(cmd);
            cmd.we = 1;
            cmd.data = 0;
            start_item(cmd);
            finish_item(cmd);
            m_sequencer.ungrab(this); // Release hold on sequencer
        endtask
    endclass

    class gpio_virtual_sequence_base extends uvm_sequence #(uvm_sequence_item);
        `uvm_object_utils(gpio_virtual_sequence_base)

        function new(string name = "gpio_virtual_sequence_base");
        super.new(name);
        endfunction

        gpio_virtual_sequencer m_v_sqr;
        gpio_env_config m_cfg;

        gpio_sequencer aux;
        gpio_sequencer gpi;
        apb_sequencer apb;

        task body;
            // 获得调用该virtual sequence 的 sqr句柄
            if(!$cast(m_v_sqr, m_sequencer)) begin
                `uvm_fatal("GPIO_VIRTUAL_SEQUENCER", "Cast of m_sequencer to the virtual sequencer failed - this simulation will fail");
            end

            gpi = m_v_sqr.gpi;
            aux = m_v_sqr.aux;
            apb = m_v_sqr.apb;

            if (!uvm_config_db #(gpio_env_config)::get(m_sequencer, "", "gpio_env_config", m_cfg) )
                `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration gpio_env_config from uvm_config_db. Have you set() it?")
        endtask
    endclass

    class reg_test_vseq extends gpio_virtual_sequence_base;
        `uvm_object_utils(reg_test_vseq)

        function new(string name = "reg_test_vseq");
        super.new(name);
        endfunction

        task body;
            check_reset_seq do_reset = check_reset_seq::type_id::create("do_reset");
            gpio_reg_rand reg_check = gpio_reg_rand::type_id::create("reg_check");
            gpio_sync_seq init_gpio = gpio_sync_seq::type_id::create("init_gpio");

            super.body;

            init_gpio.data = 0;
            init_gpio.start(aux);
            init_gpio.start(gpi);
            // Check the reset conditions
            do_reset.start(apb);
            reg_check.iterations = 200;
            reg_check.start(apb);
        endtask
    endclass

// GPIO Output path test
    class GPO_test_vseq extends gpio_virtual_sequence_base;

        `uvm_object_utils(GPO_test_vseq)
        
        function new(string name = "GPO_test_vseq");
        super.new(name);
        endfunction
        
        task body;
        output_test_seq GP_OPs = output_test_seq::type_id::create("GP_OPs");
        gpio_aux_seq AUX_IPs = gpio_aux_seq::type_id::create("AUX_IPs");
        diag_outputs diag = diag_outputs::type_id::create("diag");
        aux_reg_seq AUX_reg = aux_reg_seq::type_id::create("AUX_reg");
        
        // Get the virtual sequencer handles assigned
        super.body();
        
        fork
            begin
            diag.start(apb);
            repeat(200) begin
                fork
                GP_OPs.start(apb);
                AUX_reg.start(apb);
                join
            end
            end
            AUX_IPs.start(aux);
        join_any
        
        endtask: body
        
        endclass: GPO_test_vseq
        
        // GPIO Input path test - including interrupts
    class GPI_test_vseq extends gpio_virtual_sequence_base;
    
    `uvm_object_utils(GPI_test_vseq)
    
    function new(string name = "GPI_test_vseq");
        super.new(name);
    endfunction
    
    task body;
        gpio_isr ISR = gpio_isr::type_id::create("ISR");
        gpio_input_test_seq gpi_input_regs = gpio_input_test_seq::type_id::create("gpi_input_regs");
        gpio_rand_seq gpi_inputs = gpio_rand_seq::type_id::create("gpio_rand_seq");
    
    super.body();
    
    fork
        gpi_inputs.start(gpi); // Forever
        begin // Setting up the GPI associated registers
        gpi_input_regs.iterations = 20000; // Repeat 100 times (Not enough)
        gpi_input_regs.start(apb);
        end
        begin // ISR
        forever begin
            m_cfg.wait_for_interrupt;
            ISR.start(apb);
        end
        end
    join_any
    
    endtask: body
    
    
    endclass: GPI_test_vseq
endpackage