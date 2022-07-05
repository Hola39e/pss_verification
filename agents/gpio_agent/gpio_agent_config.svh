class gpio_agent_config extends uvm_object;
    `uvm_object_utils(gpio_agent_config)
    
    localparam string s_my_config_id = "gpio_agent_config";
    localparam string s_no_config_id = "no_config";
    localparam string s_my_config_type_error_id = "config type error";

    uvm_active_passive_enum active = UVM_ACTIVE;

    virtual gpio_if GPIO;
    bit monitor_external_clock = 0;

    extern static function gpio_agent_config get_config(uvm_component c);
    extern function new(string name = "gpio_agent_config");
endclass

function gpio_agent_config gpio_agent_config::get_config(uvm_component c);
    gpio_agent_config t;

    if(!uvm_config_db#(gpio_agent_config)::get(c, "", s_my_config_id, t))
        `uvm_fatal("CONFIG LOAD STATIC ERROR", $sformatf("connot get config %s", s_my_config_id));

    return t;
endfunction

function gpio_agent_config::new(string name = "gpio_agent_config");
    super.new(name);
endfunction