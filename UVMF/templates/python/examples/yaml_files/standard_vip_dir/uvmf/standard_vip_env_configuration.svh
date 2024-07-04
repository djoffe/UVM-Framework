//
// File: standard_vip_env_configuration.svh
//
// Generated from Mentor VIP Configurator (20230807)
// Generated using Mentor VIP Library ( 2023.3_1 : 08/18/2023:20:00 )
//
class standard_vip_env_configuration extends uvmf_environment_configuration_base;
    `uvm_object_utils(standard_vip_env_configuration)
    // Handles for vip config for each of the QVIP instances
    
    axi4_master_0_cfg_t axi4_master_0_cfg;
    // Handles for address maps
    
    address_map axi4_am;
    
    function new
    (
        string name = "standard_vip_env_configuration"
    );
        super.new(name);
        axi4_master_0_cfg = axi4_master_0_cfg_t::type_id::create("axi4_master_0_cfg");
    endfunction
    
    virtual function string convert2string;
        return {"standard_vip_env_configuration:",axi4_master_0_cfg.convert2string()};
    endfunction: convert2string
    
    extern function void initialize
    (
        uvmf_sim_level_t sim_level,
        string environment_path,
        string interface_names[],
        uvm_reg_block register_model = null,
        uvmf_active_passive_t interface_activity[] = {}
    );
    
endclass: standard_vip_env_configuration

function void standard_vip_env_configuration::initialize
(
    uvmf_sim_level_t sim_level,
    string environment_path,
    string interface_names[],
    uvm_reg_block register_model = null,
    uvmf_active_passive_t interface_activity[] = {}
);
    super.initialize(sim_level, environment_path, interface_names, register_model, interface_activity);
    
    if ( !uvm_config_db #(axi4_master_0_bfm_t)::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], axi4_master_0_cfg.m_bfm ) )
    begin
        `uvm_fatal("Config Error", $sformatf("uvm_config_db #(axi4_master_0_bfm_t)::get() cannot find bfm vif handle for agent with interface_name '%s'", interface_names[0]))
    end
    
    begin
        addr_map_entry_s addr_map_entries[] = new [1];
        addr_map_entries = '{1{
            '{MAP_NORMAL,"RANGE_1",0,MAP_NS,4'h0,64'h0,64'h1000,MEM_NORMAL,MAP_NORM_SEC_DATA}}};
        axi4_am = address_map::type_id::create("axi4_am_addr_map");
        axi4_am.addr_mask = 64'hFFF;
        axi4_am.set( addr_map_entries );
    end
    
    axi4_master_0_config_policy::configure(axi4_master_0_cfg, axi4_am);
    if ( interface_activity.size() > 0 )
    begin
        case ( interface_activity[0] )
            ACTIVE :
                axi4_master_0_cfg.agent_cfg.is_active = 1;
            PASSIVE :
                axi4_master_0_cfg.agent_cfg.is_active = 0;
        endcase
    end
endfunction: initialize

