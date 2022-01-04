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
// Unit            : Test Top
// File            : test_top.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class is the base class for all further test cases.
//    It instantiates the configuration, environment and top level
//    sequence.  It also starts the top level sequence.
//
//----------------------------------------------------------------------
//
class test_top extends uvmf_test_base #(
   .CONFIG_T(vip_axi3_ahb_configuration_t),
   .ENV_T(vip_axi3_ahb_environment_t),
   .TOP_LEVEL_SEQ_T(vip_axi3_ahb_sequence_base_t)
);

  `uvm_component_utils( test_top );


// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
     super.new( name ,parent );
  endfunction

// ****************************************************************************
  virtual function void build_phase(uvm_phase phase);
    string interface_names [] = { VIP_AXI3_BFM_MSTR, VIP_AHB_BFM_MSTR } ;
    super.build_phase(phase);
    configuration.initialize(BLOCK, "uvm_test_top.environment",interface_names);

    set_config_int("*", "recording_detail", UVM_FULL);

  endfunction

// ****************************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    top_level_sequence.axi3_master_sequencer = environment.axi3_master_agent.qvip_agent.m_sequencer;
    top_level_sequence.ahb_master_sequencer  = environment.ahb_master_agent.qvip_agent.m_sequencer;
  endfunction

endclass
