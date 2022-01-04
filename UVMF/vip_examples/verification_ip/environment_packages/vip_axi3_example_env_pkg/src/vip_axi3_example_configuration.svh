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
// Project         : VIP Integration example
// Unit            : Configuration
// File            : vip_axi3_example_configuration.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the configuration used by the
//    vip_axi3_example environment.  It contains a configuration for
//    each agent within the environment.  The configuration for the axi3
//    vip contains a reference to the systemVerilog interface that
//    the agent will drive.  A handle to the interface is retrieved from
//    the uvm_config_db.  Once configured, the axi3 vip configuration
//    is made available to the agent though the uvm_config_db.
//
//----------------------------------------------------------------------
//
class vip_axi3_example_configuration
                   #(int AXI_ADDRESS_WIDTH  =  32,
                     int AXI_RDATA_WIDTH =  32,
                     int AXI_WDATA_WIDTH =  32,
                     int AXI_ID_WIDTH = 2 ) extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( vip_axi3_example_configuration
                   #(AXI_ADDRESS_WIDTH,
                     AXI_RDATA_WIDTH,
                     AXI_WDATA_WIDTH,
                     AXI_ID_WIDTH ));

  // This typedef is used to define the interface type retrieved from the
  // uvm_config_db.
  typedef virtual mgc_axi #(AXI_ADDRESS_WIDTH,
                            AXI_RDATA_WIDTH,
                            AXI_WDATA_WIDTH,
                            AXI_ID_WIDTH) bfm_type;

  typedef axi_master_rw_transaction #(AXI_ADDRESS_WIDTH,
                                      AXI_RDATA_WIDTH,
                                      AXI_WDATA_WIDTH,
                                      AXI_ID_WIDTH
                                      ) axi_rw_trans_t;

  // This class, axi3_vip_config, defines a single configuration object that is
  // used to configure the AHB (mgc_axi3) interface. All aspects of the
  // AXI interface can be configured, including abstraction-level, clocks, and
  // reset.
  // Each member has a default value that is applied to the interface if the
  // member is not set.
  typedef axi_vip_config #(AXI_ADDRESS_WIDTH,
                           AXI_RDATA_WIDTH,
                           AXI_WDATA_WIDTH,
                           AXI_ID_WIDTH) axi_vip_config_t;

  axi_vip_config_t axi3_master_cfg;

// ****************************************************************************
  function new( string name = "" );
    super.new( name );

    // Create a new axi3_master_cfg object (axi3_vip_config object)
    axi3_master_cfg = new();

  endfunction

// ****************************************************************************
  virtual function string convert2string();
     return {"\n"};
  endfunction
// ****************************************************************************
  function void initialize(uvmf_sim_level_t sim_level,
                           string environment_path,
                           string interface_names[],
                           uvm_reg_block register_model = null,
                           uvmf_active_passive_t interface_activity[] = null
                           );

     if(!uvm_config_db #( bfm_type )::get( null , UVMF_VIRTUAL_INTERFACES, interface_names[0] , axi3_master_cfg.m_bfm ))
       `uvm_error("CFG" , {"uvm_config_db #( bfm_type )::get cannot find resource ", interface_names[0]} )

     //Perform the ex01_test test specific configuration.
     do_axi3_config();

     // Place the configured object in global configuration space.
     // This propagates the configuration items down through the
     // hierarchy (because of the "*")
     uvm_config_db #( uvm_object )::set( null , {environment_path,".axi3_master_agent*"} , mvc_config_base_id , axi3_master_cfg );


     // Place the configuration object additionally in "UVMF_CONFIGURATIONS" space
     // for retrieval by non-components, i.e. objects like the base sequence and such
     uvm_config_db #( axi_vip_config_t )::set( null, UVMF_CONFIGURATIONS, interface_names[0], axi3_master_cfg );

  endfunction

// ----------------------------------------------------------------------------
// Function: do_axi3_config
//
// This function populates the axi master configuration to be the master of a
// single master single slave axi bus.

function void do_axi3_config();
  bfm_type bfm = axi3_master_cfg.m_bfm;

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
  // VIP is AXI Master as Slave is RTL
  axi3_master_cfg.agent_cfg.agent_type  = AXI_MASTER;

  // test bench, rather than QVIP, generates clock and reset
  axi3_master_cfg.agent_cfg.ext_clock   = 1;
  axi3_master_cfg.agent_cfg.ext_reset   = 1;

  // Enable transaction listener for capture and display of transaction within transcript file
  axi3_master_cfg.agent_cfg.en_txn_ltnr   = 1;
`else
  // VIP is AXI Master as Slave is RTL
  axi3_master_cfg.m_active_passive = UVM_ACTIVE;
  axi3_master_cfg.m_bfm.axi_set_master_abstraction_level(0,1); // TLM

  //if(axi3_master_cfg.master_delay == null)
    `uvm_info("CFG",
              {"axi_master_delay_db handle is null. Create handle to",
               "use master delay database"},
               UVM_MEDIUM);

  // Enable transaction listener for capture and display of transaction within transcript file
  axi3_master_cfg.set_analysis_component("trans_ap", "listener", mvc_item_listener #(axi_rw_trans_t)::get_type());
`endif

  bfm.set_config_write_ctrl_first_ratio(1);
  bfm.set_config_write_ctrl_to_data_mintime(0);
  bfm.set_config_write_data_to_ctrl_mintime(0);

endfunction

endclass


