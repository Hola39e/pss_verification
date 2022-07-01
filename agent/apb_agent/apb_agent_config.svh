class apb_agent_config extends uvm_obejct;
    localparam string s_my_config_id = "apb_agent_config";
    localparam string s_no_config_id = "no_config";
    localparam string s_my_config_type_error_id = "config type error";


    `uvm_object_utils(apb_agent_config)

    virtual apb_if APB;

    uvm_active_passive_enum active = UVM_ACTIVE;

    bit has_functional_coverage = 0;
    bit has_scoreboard = 0;
    
    // address decode for the select line
    int no_select_lines = 1;
    int apb_index = 0;

    logic [31:0] start_address[15:0];
    logic [31:0] range [15:0];

    // methods
    extern static function apb_agent_config get_config(uvm_conponent c);
    extern function new(string name = "apb_agent_config");
endclass

// 静态方法：从特定组件中获取config句柄
function apb_agent_config apb_agent_config::get_config(uvm_conponent c);
    apb_agent_config t;
    if(!uvm_config_db#(apb_agent_config)::get(c, "", s_my_config_id, t))
        `uvm_fatal("CONFIGLOAD", $sformatf("ERROR get config in class age_agent_config"))

    return t;
endfunction