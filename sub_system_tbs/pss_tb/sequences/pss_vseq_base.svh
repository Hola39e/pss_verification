class pss_vseq_base extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(pss_vseq_base)

    function new(string name = "pss_vseq_base");
        super.new(name);
    endfunction
    
    pss_virtual_sequencer vsqr;
    ahb_sequencer ahb;
    spi_sequencer spi;
    gpio_sequencer gpi;

    pss_env_config m_cfg;

    task body;
        // Setting up the sequencers
        if(!$cast(vsqr, m_sequencer)) begin
        `uvm_fatal("PSS_VIRTUAL_SEQUENCER", "Cast of m_sequencer to the virtual sequencer failed - this simulation will fail");
        end
        ahb = vsqr.ahb;
        spi = vsqr.spi;
        gpi = vsqr.gpi;
    
        // Useful to get to the interrupt line ...
        if (!uvm_config_db #(pss_env_config)::get(m_sequencer, "", "pss_env_config", m_cfg) )
        `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration pss_env_config from uvm_config_db. Have you set() it?")
    endtask: body
endclass