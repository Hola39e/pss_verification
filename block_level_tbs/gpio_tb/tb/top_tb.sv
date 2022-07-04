module top_tb;

    `include "gpio_defines.v"
    `include "timescale.v"

    import uvm_pkg::*;
    import gpio_test_lib_pkg::*;

    logic PCLK;
    logic PRESETn;

    apb_if APB(PCLK, PRESETn);   // APB interface
    gpio_if GPO();  // GPO Output
    gpio_if GPOE(); // GPO Output Enable
    gpio_if GPI();  // GPI Input
    gpio_if AUX();  // GPO Auxillary Input
    intr_if INTR();   // Interrupt

    gpio_top DUT(
  // APB Interface:
    .PCLK(PCLK),
    .PRESETN(PRESETn),
    .PSEL(APB.PSEL[0]),
    .PADDR(APB.PADDR[7:0]),
    .PWDATA(APB.PWDATA),
    .PRDATA(APB.PRDATA),
    .PENABLE(APB.PENABLE),
    .PREADY(APB.PREADY),
    .PSLVERR(),
    .PWRITE(APB.PWRITE),

    // Interrupt output
    .IRQ(INTR.IRQ),

    `ifdef GPIO_AUX_IMPLEMENT
    // Auxiliary inputs interface
    .aux_i(AUX.gpio),
    `endif //  GPIO_AUX_IMPLEMENT

    // External GPIO Interface
    .ext_pad_i(GPI.gpio),
    .ext_pad_o(GPO.gpio),
    .ext_padoe_o(GPOE.gpio)
    `ifdef GPIO_CLKPAD
    , .clk_pad_i(GPI.ext_clk)
    `endif
    );

    initial begin
        uvm_config_db #(virtual apb_if) ::set(null,"uvm_test_top","APB_vif" , APB);
        uvm_config_db #(virtual gpio_if)::set(null,"uvm_test_top","GPO_vif" , GPO);
        uvm_config_db #(virtual gpio_if)::set(null,"uvm_test_top","GPOE_vif", GPOE);
        uvm_config_db #(virtual gpio_if)::set(null,"uvm_test_top","GPI_vif" , GPI);
        uvm_config_db #(virtual gpio_if)::set(null,"uvm_test_top","AUX_vif" , AUX);
        uvm_config_db #(virtual intr_if)::set(null,"uvm_test_top","INTR_vif", INTR);
        run_test();
        $finish;
    end

    initial begin
        PCLK = 0;
        PRESETn = 0;
        repeat(8) begin
            #10ns PCLK = ~PCLK;
        end
        PRESETn = 1;
        forever begin
            #10ns PCLK = ~PCLK;
        end
    end

    assign GPO.clk = PCLK;
    assign GPOE.clk = PCLK;
    assign AUX.clk = PCLK;
    assign GPI.clk = PCLK;
endmodule