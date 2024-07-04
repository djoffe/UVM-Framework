//
// File: standard_vip_env_config.svh
//
// Generated from Mentor VIP Configurator (20230807)
// Generated using Mentor VIP Library ( 2023.3_1 : 08/18/2023:20:00 )
//
class standard_vip_env_config extends uvm_object;
    `uvm_object_utils(standard_vip_env_config)
    // Handles for vip config for each of the QVIP instances
    
    axi4_master_0_cfg_t axi4_master_0_cfg;
    // Handles for address maps
    
    address_map axi4_am;
    
    function new
    (
        string name = "standard_vip_env_config"
    );
        super.new(name);
    endfunction
    
    extern function void initialize;
    
endclass: standard_vip_env_config

function void standard_vip_env_config::initialize;
    begin
        addr_map_entry_s addr_map_entries[] = new [1];
        addr_map_entries = '{1{
            '{MAP_NORMAL,"RANGE_1",0,MAP_NS,4'h0,64'h0,64'h1000,MEM_NORMAL,MAP_NORM_SEC_DATA}}};
        axi4_am = address_map::type_id::create("axi4_am_addr_map");
        axi4_am.addr_mask = 64'hFFF;
        axi4_am.set( addr_map_entries );
    end
endfunction: initialize

