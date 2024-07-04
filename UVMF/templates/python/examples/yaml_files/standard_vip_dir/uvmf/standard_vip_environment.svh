//
// File: standard_vip_environment.svh
//
// Generated from Mentor VIP Configurator (20230807)
// Generated using Mentor VIP Library ( 2023.3_1 : 08/18/2023:20:00 )
//
`include "uvm_macros.svh"
class standard_vip_environment
#(
    string UNIQUE_ID = ""
) extends uvmf_environment_base #(.CONFIG_T(standard_vip_env_configuration));
    `uvm_component_param_utils(standard_vip_environment #(UNIQUE_ID))
    // Agent handles
    
    axi4_master_0_agent_t axi4_master_0;
    function new
    (
        string name = "standard_vip_environment",
        uvm_component parent = null
    );
        super.new(name, parent);
    endfunction
    
    extern function void build_phase
    (
        uvm_phase phase
    );
    
    extern function void connect_phase
    (
        uvm_phase phase
    );
    
endclass: standard_vip_environment

function void standard_vip_environment::build_phase
(
    uvm_phase phase
);
    axi4_master_0 = axi4_master_0_agent_t::type_id::create("axi4_master_0", this );
    axi4_master_0.set_mvc_config(configuration.axi4_master_0_cfg);
    
endfunction: build_phase

function void standard_vip_environment::connect_phase
(
    uvm_phase phase
);
    uvm_config_db #(mvc_sequencer)::set(null,UVMF_SEQUENCERS,{UNIQUE_ID,"axi4_master_0"},axi4_master_0.m_sequencer);
endfunction: connect_phase

