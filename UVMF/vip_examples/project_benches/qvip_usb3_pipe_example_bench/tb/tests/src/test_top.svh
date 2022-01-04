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
// Unit            : test_top
// File            : test_top.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/05
//----------------------------------------------------------------------

// Description: This top level UVM test is the base class for all
//     future tests created for this project.
//
//     This test class contains:
//          Configuration:  The top level configuration for the project.
//          Environment:    The top level environment for the project.
//          Top_level_sequence:  The top level sequence for the project.
//
class test_top extends uvmf_test_base #(.CONFIG_T(qvip_usb3_pipe_example_configuration #(DATA_BUS_WIDTH)), 
                                        .ENV_T(qvip_usb3_pipe_example_environment), 
                                        .TOP_LEVEL_SEQ_T(qvip_usb3_pipe_example_bench_sequence_base));

  `uvm_component_utils( test_top );

// ****************************************************************************
// FUNCTION: new()
// This is the standard system verilog constructor.  All components are 
// constructed in the build_phase to allow factory overriding.
//
  function new( string name = "", uvm_component parent = null );
     super.new( name ,parent );
  endfunction

  virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     top_level_sequence.qvip_usb_host_sequencer = environment.qvip_usb_host_agent.m_sequencer;
  endfunction

// ****************************************************************************
// FUNCTION: build_phase()
// The construction of the configuration and environment classes is done in
// the build_phase of uvmf_test_base.  Once the configuraton and environment
// classes are built then the initialize call is made to perform the
// following: 
//     Monitor and driver BFM virtual interface handle passing into agents
//     Set the active/passive state for each agent
// Once this build_phase completes, the build_phase of the environment is
// executed which builds the agents.
//
  virtual function void build_phase(uvm_phase phase);
    string interface_names[] = {
 qvip_usb_host_BFM
};
    super.build_phase(phase);
    configuration.initialize(BLOCK, "uvm_test_top.environment", interface_names);
  endfunction

  // FUNCTION: run_phase
  // This task manages the test objection and starts the top level sequence.
  // This was copied from uvmf_test_base and is overriding that run_phase because
  // I needed to do more than just start the top_level_sequence.
  virtual task run_phase( uvm_phase phase );
    phase.raise_objection(this, "Objection raised by test_top");
    initial_ltssm_transition();
    top_level_sequence.start(null);
    phase.drop_objection(this, "Objection dropped by test_top");
  endtask

task initial_ltssm_transition();

  fork
    if (configuration.qvip_usb_host_config.m_bfm.get_g_usb3_enable() == 1'b0)
      configuration.qvip_usb_host_config.m_bfm.wait_for_g_usb3_enable();

    if ((configuration.qvip_usb_host_config.m_bfm.get_initial_link_state_value() == USB_SS_Disabled) ||
        (configuration.qvip_usb_host_config.m_bfm.get_initial_link_state_value() == USB_SS_Rx_Detect))
    begin
      repeat(10) configuration.qvip_usb_host_config.wait_for_clock(); // user can specify delay as desired

      fork
        begin
         // To direct downstream link to RxDetect
          configuration.qvip_usb_host_config.m_bfm.set_g_directed_to_Rx_detect_index1(0, 1'b1);
          configuration.qvip_usb_host_config.wait_for_clock();
          configuration.qvip_usb_host_config.m_bfm.set_g_directed_to_Rx_detect_index1(0, 1'b0);

          configuration.qvip_usb_host_config.wait_for_link_state_index(0, USB_SS_Rx_Detect);
          `uvm_info ("TEST",
                     $psprintf("Downstream Link state : %s, Downstream Link substate = %s",
                               configuration.qvip_usb_host_config.m_bfm.get_link_state_index1(0),
                               configuration.qvip_usb_host_config.m_bfm.get_link_substate_index1(0)),
                      UVM_LOW);

          // To direct downstream link to Polling.LFPS
          configuration.qvip_usb_host_config.m_bfm.set_g_far_end_rx_termination_present_index1(0, 1'b1);
          configuration.qvip_usb_host_config.wait_for_clock();
          configuration.qvip_usb_host_config.m_bfm.set_g_far_end_rx_termination_valid_index1(0, 1'b1);
          configuration.qvip_usb_host_config.wait_for_clock();
          configuration.qvip_usb_host_config.m_bfm.set_g_far_end_rx_termination_valid_index1(0, 1'b0);

          configuration.qvip_usb_host_config.wait_for_link_substate_index(0, USB_SS_Rx_Detect_Active, 1'b1);
          `uvm_info ("TEST",
                     $psprintf("Downstream Link state : %s, Downstream Link substate = %s",
                                configuration.qvip_usb_host_config.m_bfm.get_link_state_index1(0),
                                configuration.qvip_usb_host_config.m_bfm.get_link_substate_index1(0)),
                      UVM_LOW);
          configuration.qvip_usb_host_config.wait_for_link_state_index(0, USB_SS_U0);
        end
        begin
          // To direct upstream link to RxDetect
          configuration.qvip_usb_host_config.m_bfm.set_g_directed_to_Rx_detect_index1(1, 1'b1);
          configuration.qvip_usb_host_config.wait_for_clock();
          configuration.qvip_usb_host_config.m_bfm.set_g_directed_to_Rx_detect_index1(1, 1'b0);

          configuration.qvip_usb_host_config.wait_for_link_state_index(1, USB_SS_Rx_Detect);
          `uvm_info ("TEST",
                     $psprintf("Upstream Link state : %s,   Upstream Link substate = %s"  ,
                               configuration.qvip_usb_host_config.m_bfm.get_link_state_index1(1),
                               configuration.qvip_usb_host_config.m_bfm.get_link_substate_index1(1)),
                      UVM_LOW);

          // To direct downstream link to Polling.LFPS
          configuration.qvip_usb_host_config.m_bfm.set_g_far_end_rx_termination_present_index1(1, 1'b1);
          configuration.qvip_usb_host_config.wait_for_clock();
          configuration.qvip_usb_host_config.m_bfm.set_g_far_end_rx_termination_valid_index1(1, 1'b1);
          configuration.qvip_usb_host_config.wait_for_clock();
          // configuration.qvip_usb_host_config.m_bfm.set_g_far_end_rx_termination_valid_index1(1, 1'b0);

          configuration.qvip_usb_host_config.wait_for_link_substate_index(1, USB_SS_Rx_Detect_Active, 1'b1);
          `uvm_info ("TEST",
                     $psprintf("Upstream Link state : %s,   Upstream Link substate = %s"  ,
                               configuration.qvip_usb_host_config.m_bfm.get_link_state_index1(1),
                               configuration.qvip_usb_host_config.m_bfm.get_link_substate_index1(1)),
                      UVM_LOW);
          configuration.qvip_usb_host_config.wait_for_link_state_index(1, USB_SS_U0);
        end
      join
    end
  join_none
endtask

endclass

