//
// File: standard_vip_env.svh
//
// Generated from Mentor VIP Configurator (20230807)
// Generated using Mentor VIP Library ( 2023.3_1 : 08/18/2023:20:00 )
//
`include "uvm_macros.svh"
class standard_vip_env extends uvm_env;
    `uvm_component_utils(standard_vip_env)
    standard_vip_env_config cfg;
    // Agent handles
    
    axi4_master_0_agent_t axi4_master_0;
    function new
    (
        string name = "standard_vip_env",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
endclass: standard_vip_env

function void standard_vip_env::build_phase
(
    uvm_phase phase
);
    if ( cfg == null )
    begin
        if ( !uvm_config_db #(standard_vip_env_config)::get(this, "", "env_config", cfg) )
        begin
            `uvm_error("build_phase", "Unable to find the env config object in the uvm_config_db")
        end
    end
    axi4_master_0 = axi4_master_0_agent_t::type_id::create("axi4_master_0", this );
    axi4_master_0.set_mvc_config(cfg.axi4_master_0_cfg);
    
endfunction: build_phase

