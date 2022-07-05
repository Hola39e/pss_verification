class gpio_driver extends uvm_driver #(gpio_seq_item, gpio_seq_item);

    `uvm_component_utils(gpio_driver)
    virtual gpio_if GPIO;

    extern function new(string name = "gpio_driver", uvm_component parent = null);
    extern task run_phase(uvm_phase phase);

endclass

function gpio_driver::new(string name = "gpio_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction

task gpio_driver::run_phase(uvm_phase phase);
    gpio_seq_item req;
    gpio_seq_item rsp;

    GPIO.ext_clk <= 0;
    forever begin
    seq_item_port.get_next_item(req);
    @(posedge GPIO.clk);
    #1ns;
    foreach(req.use_ext_clk[i]) begin
        if(req.use_ext_clk[i] == 0) begin
        GPIO.gpio[i] <= req.gpio[i];
        end
    end
    repeat(2)
        @(negedge GPIO.clk);
    foreach(req.use_ext_clk[i]) begin
        if(req.use_ext_clk[i] == 1) begin
        if(req.ext_clk_edge[i] == 1) begin
            GPIO.gpio[i] <= req.gpio[i];
        end
        end
    end
    repeat(2)
        @(negedge GPIO.clk);
    GPIO.ext_clk <= 1;
    repeat(5)
        @(negedge GPIO.clk);
    foreach(req.use_ext_clk[i]) begin
        if(req.use_ext_clk[i] == 1) begin
        if(req.ext_clk_edge[i] == 0) begin
            GPIO.gpio[i] <= req.gpio[i];
        end
        end
    end
    repeat(5)
        @(negedge GPIO.clk);
    GPIO.ext_clk <= 0;
    repeat(5)
        @(negedge GPIO.clk);
    seq_item_port.item_done();
    end

endtask: run_phase