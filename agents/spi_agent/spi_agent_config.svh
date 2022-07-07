//
// Class Description:
//
//
class spi_agent_config extends uvm_object;

// UVM Factory Registration Macro
//
`uvm_object_utils(spi_agent_config)

// Virtual Interface
virtual spi_if SPI;

//------------------------------------------
// Data Members
//------------------------------------------
// Is the agent active or passive
uvm_active_passive_enum active = UVM_ACTIVE;
bit has_functional_coverage = 0;

//------------------------------------------
// Methods
//------------------------------------------
// Standard UVM Methods:
extern function new(string name = "spi_agent_config");

endclass: spi_agent_config

function spi_agent_config::new(string name = "spi_agent_config");
  super.new(name);
endfunction
