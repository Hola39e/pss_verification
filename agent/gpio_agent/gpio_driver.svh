class gpio_driver extends uvm_driver #(gpio_seq_item, gpio_seq_item);

    `uvm_component_utils(gpio_driver)
    virtual gpio_if GPIO;

    extern function new(string name = "gpio_driver", uvm_component parent = null);
    extern task run_phase(uvm_phase phase);

endclass

function gpio_driver::new(string name = "gpio_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction

task gpio_driver::run_phase;

    gpio_seq_item req, rsp;

    GPIO.ext_clk <= 1'b0;
    forever begin
        seq_item_port.get_next_item(req);
        @(posedge GPIO.clk);
        #1ns;
        foreach(req.use_ext_clk[i])begin
            if(req.use_ext_clk[i] == 0)
                GPIO.gpio[i] <= req.gpio[i];
        end
        repeat(2) @(negedge GPIO.clk);
        
    end
endtask