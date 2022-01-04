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
// Unit            : qvip_usb3_pipe_example_environment
// File            : qvip_usb3_pipe_example_environment.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/05
//----------------------------------------------------------------------

// DESCRIPTION: This environment contains the following UVM components:
 // qvip_usb_host_agent: Used to interface to the qvip_usb_host port on the DUT.

//
class qvip_usb3_pipe_example_environment #(int DATA_BUS_WIDTH = 32) extends uvmf_environment_base #(.CONFIG_T( qvip_usb3_pipe_example_configuration));

  `uvm_component_utils( qvip_usb3_pipe_example_environment );

// qvip_agent_t qvip_usb_host_agent;

  typedef usb_ss_agent #(DATA_BUS_WIDTH) qvip_agent_t;
  // Instance of an usb_ss_agent.
  qvip_agent_t qvip_usb_host_agent;

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

    qvip_usb_host_agent     = qvip_agent_t::type_id::create("qvip_usb_host_agent",this);
    uvm_config_db #( uvm_object )::set( this , "qvip_usb_host_agent*", mvc_config_base_id, configuration.qvip_usb_host_config);

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
 // qvip_usb_host_agent.monitored_ap.connect();


  endfunction

endclass


