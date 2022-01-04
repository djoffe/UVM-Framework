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
// File            : qvip_pcie_serial_example_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the configuration used by the
//    qvip_pcie_serial_example environment.  It contains a configuration for
//    each agent within the environemnt.  The configuration for the pcie_serial
//    qvip contains a reference to the systemVerilog interface that
//    the agent will drive.  A handle to the interface is retrieved from
//    the uvm_config_db.  Once configured, the pcie_serial qvip configuration
//    is made available to the agent though the uvm_config_db.
//
//----------------------------------------------------------------------
//
class qvip_pcie_serial_example_configuration #(int LANES = 8,
                                               int PIPE_BYTES_MAX = 1,
                                               int CONFIG_NUM_OF_FUNCTIONS = 1
                                               ) extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( qvip_pcie_serial_example_configuration #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS ));

    typedef virtual mgc_pcie #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS) pcie_if_t;

    typedef pcie_vip_config #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS)  config_t;

    // Handle of PCIe QVIP agent configuration
    config_t rc_agent_cfg;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );

    rc_agent_cfg  = config_t::type_id::create("rc_agent_cfg" );

  endfunction

// ****************************************************************************
  function void initialize(uvmf_sim_level_t sim_level,
                           string environment_path,
                           string interface_names[] ,
                           uvm_reg_block register_model = null,
                           uvmf_active_passive_t interface_activity[] = null
                           );

         if(!uvm_config_db #( pcie_if_t )::get( null , "uvm_test_top", interface_names[0] , rc_agent_cfg.m_bfm ) ) begin
      `uvm_error("CFG" , $sformatf("uvm_config_db #( bfm_type )::get cannot pcie interface %s" , interface_names[0] ) )
    end

  rc_agent_cfg.agent_descriptor.pcie_details       = '{version:PCIE_3_0, gen:PCIE_GEN3, if_type:PCIE_SERIAL};
  rc_agent_cfg.agent_descriptor.bfm_node.node_type = PCIE_RC;
  rc_agent_cfg.agent_descriptor.dut_node.node_type = PCIE_NEP;
  rc_agent_cfg.agent_descriptor.options            = '{ext_clock:0,
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

  uvm_config_db #(config_t)::set(null, UVMF_CONFIGURATIONS, "rc_agent_cfg", rc_agent_cfg);

  endfunction

endclass
