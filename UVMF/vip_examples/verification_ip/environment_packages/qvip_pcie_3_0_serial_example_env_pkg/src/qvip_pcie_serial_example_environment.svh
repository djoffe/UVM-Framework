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
// Unit            : Environment
// File            : qvip_pcie_serial_example_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the environment.  It is reusable
//    from block to chip to system level simulations.  Its configuration
//    is qvip_pcie_serial_example_environment_configuration.  Agents within this
//    environment are configured from this environments configuration.
//
//----------------------------------------------------------------------
//
class qvip_pcie_serial_example_environment  #(int LANES = 8,
                                              int PIPE_BYTES_MAX = 1,
                                              int CONFIG_NUM_OF_FUNCTIONS = 1
                                              ) extends uvmf_environment_base #(.CONFIG_T(qvip_pcie_serial_example_configuration));

  `uvm_component_param_utils( qvip_pcie_serial_example_environment  #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS
));

typedef pcie_vip_config #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS)  config_t;

typedef pcie_agent #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) rc_agent_t;

// Handle of PCIe QVIP agent configuration
config_t rc_agent_cfg;

// Handle for PCIe QVIP RC Agent
rc_agent_t rc_agent;

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction


// ****************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(config_t)::get(null, "CONFIGURATIONS", "rc_agent_cfg", rc_agent_cfg) )
        `uvm_error("CFG" , "uvm_config_db #( config_t )::get cannot get rc_agent_cfg" )
    rc_agent = rc_agent_t::type_id::create("rc_agent", this);
    rc_agent.set_mvc_config(rc_agent_cfg);
  endfunction

endclass
