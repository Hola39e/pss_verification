class uart_driver extends uvm_driver #(uart_seq_item, uart_seq_item);

    `uvm_component_utils(uart_driver)

    virtual serial_if sline;

    uart_seq_item pkt;

    bit clk;
    logic [15:0] divisor;

    extern task clk_gen;
    extern task send_pkts;
    extern task bitPeriod;
    extern task runphase(uvm_phase phase);
endclass

task uart_driver::clk_gen();

    clk = 0;
    divisor = 4;
    // 分频
    forever begin
        repeat(divisor)
            @(posedge sline.clk);
        clk = ~clk;
    end
endtask

task uart_driver::send_pkts;

    integer bitPtr = 0;
    begin
        sline.sdata = 1;
        forever begin
            seq_item_port.get_next_item(pkt);
            divisor = pkt.baud_divisor;

            repeat(pkt.delay) @(posedge clk);
            if(pkt.sbe)begin
                sline.sdata <= 0;
                repeat(pkt.sbe_clks) @(posedge clk);
                sline.sdata <= 1;
                repeat(pkt.sbe_clks) @(posedge clk);
            end

        // start bit
        sline.sdata <= 1'b0;
        bitPtr = 0;
        bitPeriod;
        while(bitPtr < 5)
        begin
            sline.sdata <= pkt.data[bitPtr];
            bitPeriod;
            bitPtr++;
        end
      // Data bits 5 to 7
        if (pkt.lcr[1:0] > 2'b00)
        begin
            sline.sdata <= pkt.data[5];
            bitPeriod;
        end
        if (pkt.lcr[1:0] > 2'b01)
        begin
            sline.sdata <= pkt.data[6];
            bitPeriod;
        end
        if (pkt.lcr[1:0] > 2'b10)
        begin
            sline.sdata <= pkt.data[7];
            bitPeriod;
        end
      // Parity
        if (pkt.lcr[3])
        begin
            sline.sdata <= logic'(calParity(pkt.lcr, pkt.data));
            if (pkt.pe)
                sline.sdata <= ~sline.sdata;
            bitPeriod;
        end
      // Stop bit
        if (!pkt.fe)
            sline.sdata <= 1;
        else
            sline.sdata <= 0;
        bitPeriod;
        if (!pkt.fe)begin
            if (pkt.lcr[2])begin
                if (pkt.lcr[1:0] == 2'b00)begin
                    repeat(8)@(posedge clk);
                end
                else
                bitPeriod;
            end
        end
        else begin
            sline.sdata <= 1;
            bitPeriod;
        end
    end
    seq_item_port.item_done();
    end
endtask

task uart_driver::bitPeriod;
    begin
        repeat(16)
        @(posedge clk);
    end
endtask: bitPeriod

task uart_driver::run_phase(uvm_phase phase);
    fork
        send_pkts;
        clk_gen;
    join
endtask: run_phase