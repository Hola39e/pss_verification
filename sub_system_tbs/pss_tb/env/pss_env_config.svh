class pss_env_config extends uvm_object;

	localparam string s_my_config_id = "pss_env_config";
	localparam string s_no_config_id = "no config";
	localparam string s_my_config_type_error_id = "config type error";

	// UVM Factory Registration Macro
	//
	`uvm_object_utils(pss_env_config)
	bit has_spi_env = 1;
	bit has_gpio_env = 1;
	bit has_virtual_sequencer = 1;
	bit has_ahb_agent = 1;
	spi_env_config m_spi_env_cfg;
	gpio_env_config m_gpio_env_cfg;
	ahb_agent_config m_ahb_agent_cfg;
	virtual icpit_if ICPIT;
	pss_reg_block pss_rgm;

// ------------------------- register model handle -----------------------


// ------------------------- register model handle -----------------------

	extern static function pss_env_config get_config( uvm_component c);
	extern task wait_for_interrupt;
	extern function bit is_interrupt_cleared();
	extern function new(string name = "pss_env_config");
endclass: pss_env_config

function pss_env_config::new(string name = "pss_env_config");
  super.new(name);
endfunction

function pss_env_config pss_env_config::get_config( uvm_component c );
	pss_env_config t;

	if (!uvm_config_db #(pss_env_config)::get(c, "", s_my_config_id, t) )
		`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))

	return t;
endfunction

task pss_env_config::wait_for_interrupt;
	@(posedge ICPIT.IRQ);
endtask: wait_for_interrupt

function bit pss_env_config::is_interrupt_cleared();
	if(ICPIT.IRQ == 0)
		return 1;
	else
		return 0;
endfunction: is_interrupt_cleared