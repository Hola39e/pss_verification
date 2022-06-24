class ahb_agent_config extends uvm_object;
    `uvm_object_utils(ahb_agent_config)

    virtual ahb_if AHB;

    uvm_active_passive_enum active = UVM_ACTIVE;

    extern function new (string name = "ahb_agent_config");
endclass

function new (string name = "ahb_agent_config");
    super.new(name);
endfunction