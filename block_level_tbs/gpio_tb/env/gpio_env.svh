class gpio_env extends uvm_env;
	`uvm_component_utils(gpio_env)

	apb_agent m_apb_agent;
	gpio_agent m_GPO_agent;
	gpio_agent m_GPOE_agent;
	gpio_agent m_GPI_agent;
	gpio_agent m_AUX_agent;
	// gpio_register_coverage m_reg_cov_monitor;
	gpio_virtual_sequencer m_v_sqr;
	gpio_reg_scoreboard m_reg_sb;
	gpio_out_scoreboard m_out_sb;
	gpio_in_scoreboard m_in_sb;
	gpio_env_config m_cfg;

	gpio_reg_block gpio_rgm;
	apb2reg_adapter rgm_adapter;
	uvm_reg_predictor #(apb_seq_item) predictor;

	extern function new(string name = "gpio_env", uvm_component parent = null);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass


function gpio_env::new(string name = "gpio_env", uvm_component parent = null);
	super.new(name, parent);
endfunction

function void gpio_env::build_phase(uvm_phase phase);


	if (!uvm_config_db #(gpio_env_config)::get(this, "", "gpio_env_config", m_cfg) )
		`uvm_fatal("CONFIG_LOAD", "Cannot get() configuration gpio_env_config from uvm_config_db. Have you set() it?")
	if(m_cfg.has_apb_agent) begin
		uvm_config_db #(apb_agent_config)::set(this,"m_apb_agent*", "apb_agent_config", m_cfg.m_apb_agent_cfg);
		m_apb_agent = apb_agent::type_id::create("m_apb_agent", this);
		`uvm_info("ENV BUILD", "config has sent", UVM_LOW)
	end
	if(m_cfg.has_GPO_agent) begin
		uvm_config_db #(gpio_agent_config)::set(this,"m_GPO_agent*", "gpio_agent_config", m_cfg.m_GPO_agent_cfg);
		m_GPO_agent = gpio_agent::type_id::create("m_GPO_agent", this);
	end
	if(m_cfg.has_GPOE_agent) begin
		uvm_config_db #(gpio_agent_config)::set(this,"m_GPOE_agent*", "gpio_agent_config", m_cfg.m_GPOE_agent_cfg);
		m_GPOE_agent = gpio_agent::type_id::create("m_GPOE_agent", this);
	end
	if(m_cfg.has_GPI_agent) begin
		uvm_config_db #(gpio_agent_config)::set(this,"m_GPI_agent*", "gpio_agent_config", m_cfg.m_GPI_agent_cfg);
		m_GPI_agent = gpio_agent::type_id::create("m_GPI_agent", this);
	end
	if(m_cfg.has_AUX_agent) begin
		uvm_config_db #(gpio_agent_config)::set(this,"m_AUX_agent*", "gpio_agent_config", m_cfg.m_AUX_agent_cfg);
		m_AUX_agent = gpio_agent::type_id::create("m_AUX_agent", this);
	end
	if(m_cfg.has_virtual_sequencer) begin
		m_v_sqr = gpio_virtual_sequencer::type_id::create("m_v_sqr", this);
	end
//	if(m_cfg.has_functional_coverage) begin
//		m_reg_cov_monitor = gpio_register_coverage::type_id::create("m_reg_cov_monitor", this);
//	end
	if(m_cfg.has_reg_scoreboard) begin
		m_reg_sb = gpio_reg_scoreboard::type_id::create("m_reg_sb", this);
	end
	if(m_cfg.has_out_scoreboard) begin
		m_out_sb = gpio_out_scoreboard::type_id::create("m_out_sb", this);
	end
	if(m_cfg.has_in_scoreboard) begin
		m_in_sb = gpio_in_scoreboard::type_id::create("m_in_sb", this);
	end

	// config the reg model------------------------------------------------
	gpio_rgm = m_cfg.gpio_rgm;
	rgm_adapter = apb2reg_adapter::type_id::create("rgm_adapter");
	predictor = uvm_reg_predictor#(apb_seq_item)::type_id::create("predictor", this);
	// config the reg model------------------------------------------------

endfunction:build_phase

function void gpio_env::connect_phase(uvm_phase phase);

	// rgm config -------------------------------------------------
	m_cfg.gpio_rgm.gpio_reg_block_map.set_sequencer(m_apb_agent.m_sequencer, rgm_adapter);
	m_apb_agent.m_monitor.ap.connect(predictor.bus_in);
	predictor.map = m_cfg.gpio_rgm.gpio_reg_block_map;
	predictor.adapter = rgm_adapter;

	
	m_cfg.gpio_rgm.gpio_reg_block_map.set_auto_predict(0);
	m_apb_agent.ap.connect(predictor.bus_in);
	m_v_sqr.gpio_rgm = m_cfg.gpio_rgm;
	`uvm_info("RGM in env set", "now go to this", UVM_LOW);
	// rgm config -------------------------------------------------
	
	if(m_cfg.has_virtual_sequencer) begin
		if(m_cfg.has_apb_agent) begin
			m_v_sqr.apb = m_apb_agent.m_sequencer;
		end
		if(m_cfg.has_AUX_agent) begin
			m_v_sqr.aux = m_AUX_agent.m_sequencer;
		end
		if(m_cfg.has_GPI_agent) begin
			m_v_sqr.gpi = m_GPI_agent.m_sequencer;
		end
	end
//	if(m_cfg.has_functional_coverage) begin
//		m_apb_agent.ap.connect(m_reg_cov_monitor.analysis_export);
//	end
	if(m_cfg.has_reg_scoreboard) begin
		m_apb_agent.ap.connect(m_reg_sb.analysis_export);
	end
	if(m_cfg.has_out_scoreboard) begin
		m_apb_agent.ap.connect(m_out_sb.apb_fifo.analysis_export);
		m_GPO_agent.ap.connect(m_out_sb.GPO_fifo.analysis_export);
		m_GPOE_agent.ap.connect(m_out_sb.GPOE_fifo.analysis_export);
		if(m_cfg.has_AUX_agent) begin
			m_AUX_agent.ap.connect(m_out_sb.AUX_fifo.analysis_export);
		end
	end
	if(m_cfg.has_in_scoreboard) begin
		m_apb_agent.ap.connect(m_in_sb.apb.analysis_export);
		m_GPI_agent.ap.connect(m_in_sb.gpi_int.analysis_export);
		if(m_cfg.m_GPI_agent_cfg.monitor_external_clock == 1) begin
			m_GPI_agent.ext_ap.connect(m_in_sb.gpi_ext.analysis_export);
		end
	end
endfunction