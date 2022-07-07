package gpio_env_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Any further package imports:
    import apb_agent_pkg::*;
    import gpio_agent_pkg::*;
    //import uvm_register_pkg::*;
    //import gpio_register_pkg::*;
	import gpio_register_model_pkg::*;

    localparam string s_my_config_id = "gpio_env_config";
    localparam string s_no_config_id = "no config";
    localparam string s_my_config_type_error_id = "config type error";

    `define RGPIO_IN 5'h0
    `define RGPIO_OUT 5'h4
    `define RGPIO_OE 5'h8
    `define RGPIO_INTE 5'hc
    `define RGPIO_PTRIG 5'h10
    `define RGPIO_AUX 5'h14
    `define RGPIO_CTRL 5'h18
    `define RGPIO_INTS 5'h1c
    `define RGPIO_ECLK 5'h20
    `define RGPIO_NEC 5'h24

    `include "gpio_env_config.svh"
    `include "gpio_virtual_sequencer.svh"
    `include "gpio_out_scoreboard.svh"
    `include "gpio_in_scoreboard.svh"
    `include "gpio_reg_scoreboard.svh"
    `include "gpio_env.svh"
endpackage