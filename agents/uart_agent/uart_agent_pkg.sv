package uart_agent_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    function bit calParity (input logic [7:0] lcr, input logic[7:0] data);
        bit retParity;

        if (lcr[5])begin
            case (lcr[4])
                1'b0: retParity = 1'b1;
                1'b1: retParity = 1'b0;
            endcase
        end
        else begin
            case (lcr[1:0])
                2'b00: retParity = ^data[4:0];
                2'b01: retParity = ^data[5:0];
                2'b10: retParity = ^data[6:0];
                2'b11: retParity = ^data[7:0];  // 偶校验
            endcase
            if (!lcr[4])
              retParity = ~retParity;   // 如果lcr[4]==0 那么取反 就是奇校验
          end
        return retParity;
      endfunction

    `include "uart_seq_item.svh"
    `include "uart_agent_config.svh"
    `include "uart_monitor.svh"
    `include "uart_sequencer.svh";
    `include "uart_driver.svh"
    `include "uart_agent.svh"
endpackage