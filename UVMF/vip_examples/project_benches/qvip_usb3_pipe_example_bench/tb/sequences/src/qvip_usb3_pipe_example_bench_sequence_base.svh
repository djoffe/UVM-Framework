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
// Unit            : qvip_usb3_pipe_example_bench_sequence_base
// File            : qvip_usb3_pipe_example_bench_sequence_base.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/05
//----------------------------------------------------------------------

// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
class qvip_usb3_pipe_example_bench_sequence_base #(int DATA_BUS_WIDTH = 32) extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( qvip_usb3_pipe_example_bench_sequence_base );

  // Instantiate sequences here

  typedef usb_ss_host_burst_test_sequence_local #(DATA_BUS_WIDTH) usb_ss_host_sequence_t;
  usb_ss_host_sequence_t host_seq;

  // Sequencer handles for each active interface in the environment
  // Configuration handles to access interface BFM's
  //  uvm_sequencer #(qvip_transaction)  qvip_usb_host_sequencer; 
  mvc_sequencer qvip_usb_host_sequencer; 
  //   qvip_configuration  qvip_usb_host_config; 

// ****************************************************************************
  function new( string name = "" );
     super.new( name );

  // Retrieve the sequencer handles from the uvm_config_db
//  if( !uvm_config_db #( uvm_sequencer #(qvip_transaction) )::get( null , UVMF_SEQUENCERS , qvip_usb_host_BFM , qvip_usb_host_sequencer ) ) 
// `uvm_error("CFG" , "uvm_config_db #( uvm_sequencer#(qvip_usb_host_transaction) )::get cannot find resource qvip_usb_host_sequencer" ) 

/*
  if( !uvm_config_db #( qvip_configuration )::get( null , UVMF_CONFIGURATIONS , qvip_usb_host_BFM , qvip_usb_host_config ) ) 
 `uvm_error("CFG" , "uvm_config_db #( qvip_usb_host_configuration )::get cannot find resource qvip_usb_host_config" ) 
*/

  endfunction


// ****************************************************************************
  virtual task body();

  // Construct sequences here
  host_seq = usb_ss_host_sequence_t::type_id::create("USB_SS_host_sequence");

  // Start sequences here
  host_seq.start(qvip_usb_host_sequencer);

  // Delay to allow for design latency
  //  qvip_usb_host_config.wait_for_num_clocks(100);
 
  endtask

endclass

