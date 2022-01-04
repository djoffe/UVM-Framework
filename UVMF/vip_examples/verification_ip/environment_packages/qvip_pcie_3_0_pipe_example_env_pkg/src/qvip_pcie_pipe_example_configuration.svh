//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : QVIP Integration example
// Unit            : Configuration
// File            : qvip_pcie_pipe_example_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the configuration used by the
//    qvip_pcie_pipe_example environment.  It contains a configuration for
//    each agent within the environemnt.  The configuration for the pcie_pipe
//    qvip contains a reference to the systemVerilog interface that
//    the agent will drive.  A handle to the interface is retrieved from
//    the uvm_config_db.  Once configured, the pcie_pipe qvip configuration
//    is made available to the agent though the uvm_config_db.
//
//----------------------------------------------------------------------
//
class qvip_pcie_pipe_example_configuration
                   #(int LANES = 4,
                     int PIPE_BYTES_MAX = 1,
                     int CONFIG_NUM_OF_FUNCTIONS = 1
) extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( qvip_pcie_pipe_example_configuration #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS ));

    typedef virtual mgc_pcie #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS) pcie_if_t;

    typedef pcie_vip_config #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS)  config_t;

    config_t pcie_pipe_rc_cfg;


// ****************************************************************************
  function new( string name = "" );
    super.new( name );

        pcie_pipe_rc_cfg  = config_t::type_id::create("pcie_pipe_rc_cfg" );

  endfunction

// ****************************************************************************
  // virtual function string convert2string();
     // return {"\n"};
  // endfunction
// ****************************************************************************
  function void initialize(uvmf_sim_level_t sim_level,
                           string environment_path,
                           string interface_names[],
                           uvm_reg_block register_model = null,
                           uvmf_active_passive_t interface_activity[] = null
                           );

      // Getting interface
    if(!uvm_config_db #(pcie_if_t) ::get(null,UVMF_VIRTUAL_INTERFACES,interface_names[0], pcie_pipe_rc_cfg.m_bfm))
     `uvm_error("CFG","uvm_config_db #(pcie_if_t)::get cannot find resource PCIE_RC_IF");

     //Perform the ex01_test test specific configuration.
     do_pcie_pipe_config();

     // Place the configured object in global configuration space.
     // This propagates the configuration items down through the
     // hierarchy (because of the "*")
     uvm_config_db #( uvm_object )::set( null , {environment_path,".pcie_pipe_rc_agent*"} , mvc_config_base_id , pcie_pipe_rc_cfg );

  endfunction

  function void do_pcie_pipe_config();

  pcie_pipe_rc_cfg.agent_descriptor.pcie_details   = '{version:PCIE_3_0, gen:PCIE_GEN3, if_type:PCIE_PIPE};
  pcie_pipe_rc_cfg.agent_descriptor.bfm_node       = '{node_type:PCIE_RC, mac:0};
  pcie_pipe_rc_cfg.agent_descriptor.dut_node       = '{node_type:PCIE_NEP, mac:1};
  pcie_pipe_rc_cfg.agent_descriptor.options        = '{ext_clock:0,
                                                       ext_reset:0,
                                                       en_sb:1,
                                                       en_pm_cvg:0,
                                                       en_pl_cvg:0,
                                                       en_dl_cvg:0,
                                                       en_tl_cvg:0,
                                                       log_txns:1,
                                                       log_txns_in_tracker:0,
                                                       log_symbol:0,
                                                       negotiate_max_speed:1,
                                                       monitor:0};

  pcie_pipe_rc_cfg.agent_descriptor.eq_options.en_eq = 1;      // Equalization feature enabled
  pcie_pipe_rc_cfg.agent_descriptor.eq_options.en_ph2_3 = 1;   // Equalization Phases 2 and 3 enabled

  pcie_pipe_rc_cfg.agent_descriptor.addr_settings.sys_mem_start_addr = 64'h0;
  pcie_pipe_rc_cfg.agent_descriptor.addr_settings.sys_mem_range = 64'h0000_ffff_ffff_ffff;

  pcie_pipe_rc_cfg.agent_descriptor.addr_settings.ep_mem_32_base_addr[0][0] =  32'h4000_0000;
  pcie_pipe_rc_cfg.agent_descriptor.addr_settings.ep_mem_64_base_addr[0][0] =  64'h1_0000_0000;

 endfunction

endclass


