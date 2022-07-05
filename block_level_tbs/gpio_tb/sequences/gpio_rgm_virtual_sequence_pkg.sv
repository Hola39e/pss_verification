
package gpio_rgm_virtual_sequence_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

    import apb_agent_pkg::*;
    import gpio_agent_pkg::*;
    import gpio_env_pkg::*;
    import gpio_bus_sequence_lib_pkg::*;
    import gpio_sequence_lib_pkg::*;	// dut gpio side sequence, used to stimulate the input or output. no reg config
endpackage 