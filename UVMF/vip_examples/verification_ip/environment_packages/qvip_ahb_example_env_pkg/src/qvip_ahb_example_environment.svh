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
// Project         : UVMF_3_4a_Templates
// Unit            : qvip_ahb_example_environment
// File            : qvip_ahb_example_environment.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2015/05/05
//----------------------------------------------------------------------
// DESCRIPTION: This environment contains the following UVM components:
 // ahb_master_agent: Used to interface to the ahb_master port on the QVIP.

class qvip_ahb_example_environment #(int AHB_NUM_MASTERS     =  2,
                                     int AHB_NUM_MASTER_BITS =  2,
                                     int AHB_NUM_SLAVES      =  2,
                                     int AHB_ADDRESS_WIDTH   = 32,
                                     int AHB_WDATA_WIDTH     = 32,
                                     int AHB_RDATA_WIDTH     = 32,
                                     string AHB_SLAVE_NAME   = "hvl_top.DUT"
                                    ) extends uvmf_environment_base #(.CONFIG_T( qvip_ahb_example_configuration
                                                                                 #(AHB_NUM_MASTERS,
                                                                                   AHB_NUM_MASTER_BITS,
                                                                                   AHB_NUM_SLAVES,
                                                                                   AHB_ADDRESS_WIDTH,
                                                                                   AHB_WDATA_WIDTH,
                                                                                   AHB_RDATA_WIDTH)));

  `uvm_component_param_utils( qvip_ahb_example_environment #(AHB_NUM_MASTERS,
                                                             AHB_NUM_MASTER_BITS,
                                                             AHB_NUM_SLAVES,
                                                             AHB_ADDRESS_WIDTH,
                                                             AHB_WDATA_WIDTH,
                                                             AHB_RDATA_WIDTH,
                                                             AHB_SLAVE_NAME));

  typedef ahb_agent #(AHB_NUM_MASTERS,
                      AHB_NUM_MASTER_BITS,
                      AHB_NUM_SLAVES,
                      AHB_ADDRESS_WIDTH,
                      AHB_WDATA_WIDTH,
                      AHB_RDATA_WIDTH) qvip_ahb_agent_t;

  // Instances of an ahb_agent.
  qvip_ahb_agent_t ahb_master_agent, ahb_slave_agent, ahb_arbiter_agent, ahb_monitor_agent;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// FUNCTION: build_phase()
// This function builds all components within this environment.
//
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    ahb_master_agent     = qvip_ahb_agent_t::type_id::create("ahb_master_agent",this);
    ahb_slave_agent      = qvip_ahb_agent_t::type_id::create("ahb_slave_agent",this);
    ahb_arbiter_agent    = qvip_ahb_agent_t::type_id::create("ahb_arbiter_agent",this);
    ahb_monitor_agent    = qvip_ahb_agent_t::type_id::create("ahb_monitor_agent",this);

/*
    uvm_config_db #( uvm_object )::set( this , "ahb_master_agent*",  mvc_config_base_id, configuration.ahb_master_config);
    uvm_config_db #( uvm_object )::set( this , "ahb_slave_agent*",   mvc_config_base_id, configuration.ahb_slave_config);
    uvm_config_db #( uvm_object )::set( this , "ahb_arbiter_agent*", mvc_config_base_id, configuration.ahb_arbiter_config);
    uvm_config_db #( uvm_object )::set( this , "ahb_monitor_agent*", mvc_config_base_id, configuration.ahb_monitor_config);
*/

  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

 // Uncomment these lines and connect the agents to predictors or scoreboards as needed
 // ahb_master_agent.monitored_ap.connect();


  endfunction

endclass


