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
// File            : qvip_pcie_pipe_example_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the environment.  It is reusable
//    from block to chip to system level simulations.  Its configuration
//    is qvip_pcie_pipe_example_environment_configuration.  Agents within this
//    environment are configured from this environments configuration.
//
//----------------------------------------------------------------------
//
class qvip_pcie_pipe_example_environment  #(int LANES = 4,
                                            int PIPE_BYTES_MAX = 1,
                                            int CONFIG_NUM_OF_FUNCTIONS = 1
                                           ) extends uvmf_environment_base #(.CONFIG_T(qvip_pcie_pipe_example_configuration));

  `uvm_component_param_utils( qvip_pcie_pipe_example_environment  #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS));


typedef pcie_agent #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) rc_agent_t;

 // This component encapsulates the master mvc_agent and provides
 //    translation from QVIP transactions into custom transactions.
typedef qvip_agent_adapter #(.USE_EXTERNAL_AGENT(0),
                             .EXTERNAL_AGENT_NAME(""),
                             .AGENT_TYPE(rc_agent_t),
                             .TRANSLATOR_TYPE(qvip_pcie_pipe_example_translator_t),
                             .TRANSACTION_TYPE(uvmf_transaction_base)) pcie_pipe_agent_t;

  pcie_pipe_agent_t pcie_pipe_rc_agent;

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction


// ****************************************************************************
// pcie_pipe_agent_t is a handle to an mvc_agent. In this function
// a new mvc_agent object is created and the handle pcie_pipe_agent_t
// is assigned to that object.
// It is named "pcie_pipe_agent_t", which is the name that will appear in
// the UVM hierearchy.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pcie_pipe_rc_agent  = pcie_pipe_agent_t::type_id::create("pcie_pipe_rc_agent", this);
  endfunction

// ****************************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

endclass






