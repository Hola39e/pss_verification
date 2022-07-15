package ahb_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //import register_layering_pkg::*;

    typedef enum bit {AHB_READ, AHB_WRITE} ahb_rw_e;
    typedef enum bit [1:0] {AHB_IDLE = 0, AHB_BUSY = 1, AHB_NON_SEQ = 2, AHB_SEQ = 3} trans_e;
    typedef enum bit [2:0] {AHB_SINGLE = 0} ahb_burst_e;
    typedef enum bit [1:0] {AHB_OKAY = 0, AHB_ERROR = 1, AHB_RETRY = 2, AHB_SPLIT = 3} ahb_resp_e; 

    `include "ahb_seq_item.svh"
    `include "ahb_agent_config.svh"
    `include "ahb_driver.svh"
    `include "ahb_monitor.svh"
    `include "ahb_sequencer.svh"
    `include "ahb_agent.svh"

    // Utility Sequences
    `include "ahb_seq.svh"
    `include "ahb_write_seq.svh"
    `include "ahb_read_seq.svh"
    `include "ahb_register_adapter.svh"
    //`include "ahb_register_adapter.svh"
endpackage
