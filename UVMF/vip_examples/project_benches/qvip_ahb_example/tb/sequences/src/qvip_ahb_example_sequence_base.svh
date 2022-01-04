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
// Unit            : qvip_ahb_example_sequence_base
// File            : qvip_ahb_example_sequence_base.svh
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
class qvip_ahb_example_sequence_base #(int AHB_NUM_MASTERS = 1,
                                       int AHB_NUM_MASTER_BITS = 1,
                                       int AHB_NUM_SLAVES = 1,
                                       int AHB_ADDRESS_WIDTH = 32,
                                       int AHB_WDATA_WIDTH = 32,
                                       int AHB_RDATA_WIDTH = 32)
                                       // type REQ=uvm_sequence_item,
                                       // type RSP=uvm_sequence_item)
                                       // extends uvmf_sequence_base #(REQ,RSP);
                                       extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_param_utils( qvip_ahb_example_sequence_base #(AHB_NUM_MASTERS ,
                                                            AHB_NUM_MASTER_BITS,
                                                            AHB_NUM_SLAVES,
                                                            AHB_ADDRESS_WIDTH,
                                                            AHB_WDATA_WIDTH,
                                                            AHB_RDATA_WIDTH));
                                                            // REQ,RSP));

  typedef ahb_master_sequence #(AHB_NUM_MASTERS,
                                AHB_NUM_MASTER_BITS,
                                AHB_NUM_SLAVES,
                                AHB_ADDRESS_WIDTH,
                                AHB_WDATA_WIDTH,
                                AHB_RDATA_WIDTH) ahb_master_seq_t;

  // Instantiate sequences here
  ahb_master_seq_t qvip_ahb_master_random_seq;
 

  typedef ahb_vip_config #(AHB_NUM_MASTERS,
                           AHB_NUM_MASTER_BITS,
                           AHB_NUM_SLAVES,
                           AHB_ADDRESS_WIDTH,
                           AHB_WDATA_WIDTH,
                           AHB_RDATA_WIDTH) ahb_vip_config_t;

  ahb_vip_config_t ahb_master_cfg;

  // Sequencer handles for each active interface in the environment
  // Configuration handles to access interface BFM's
  // uvm_sequencer #(qvip_ahb_transaction)  qvip_ahb_master_sequencer; 
  // qvip_ahb_configuration  qvip_ahb_master_config; 
  mvc_sequencer ahb_master_sequencer;

 
// ****************************************************************************
  function new( string name = "" );
     super.new( name );

/*
  // Retrieve the sequencer handles from the uvm_config_db
 if( !uvm_config_db #( uvm_sequencer #(qvip_ahb_transaction) )::get( null , UVMF_SEQUENCERS , qvip_ahb_master_BFM , qvip_ahb_master_sequencer ) ) 
 `uvm_error("CFG" , "uvm_config_db #( uvm_sequencer#(qvip_ahb_master_transaction) )::get cannot find resource qvip_ahb_master_sequencer" ) 
*/ 

/*
  if( !uvm_config_db #( qvip_ahb_configuration )::get( null , UVMF_CONFIGURATIONS , qvip_ahb_BFM , qvip_ahb_master_config ) ) 
 `uvm_error("CFG" , "uvm_config_db #( qvip_ahb_master_configuration )::get cannot find resource qvip_ahb_master_config" ) 
*/

  endfunction

// ****************************************************************************
  task timeout();
    # 100us;
  endtask

// ****************************************************************************
  virtual task body();

  // Construct sequences here
  qvip_ahb_master_random_seq = ahb_master_seq_t::type_id::create("qvip_ahb_master_seq");
 
  // Delay to allow for design latency
  //qvip_ahb_master_config.wait_for_num_clocks(100);
 
  // Start sequences here
  fork
    qvip_ahb_master_random_seq.start(ahb_master_sequencer);
    timeout();
  join_any

  endtask

endclass

