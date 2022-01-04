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
// Unit            : Top level sequence base
// File            : vip_ahb_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the base top level sequence.  It
//    defines the top level flow of stimulus.
//
//----------------------------------------------------------------------
//
class vip_ahb_example_sequence_base #(int AHB_NUM_MASTERS = 1,
                                       int AHB_NUM_MASTER_BITS = 1,
                                       int AHB_NUM_SLAVES = 1,
                                       int AHB_ADDRESS_WIDTH = 32,
                                       int AHB_WDATA_WIDTH = 32,
                                       int AHB_RDATA_WIDTH = 32,
                                       type REQ=uvm_sequence_item,
                                       type RSP=uvm_sequence_item) 
                                       extends uvmf_sequence_base #(REQ,RSP);

  `uvm_object_param_utils( vip_ahb_example_sequence_base #(AHB_NUM_MASTERS ,
                                                            AHB_NUM_MASTER_BITS,
                                                            AHB_NUM_SLAVES,
                                                            AHB_ADDRESS_WIDTH,
                                                            AHB_WDATA_WIDTH,
                                                            AHB_RDATA_WIDTH,
                                                            REQ,RSP));

  typedef ahb_master_burst_transfer_constraint #(AHB_NUM_MASTERS,
                                                 AHB_NUM_MASTER_BITS,
                                                 AHB_NUM_SLAVES,
                                                 AHB_ADDRESS_WIDTH,
                                                 AHB_WDATA_WIDTH,
                                                 AHB_RDATA_WIDTH) ahb_master_seq_item_t;

  typedef ahb_master_sequence #(AHB_NUM_MASTERS,
                                AHB_NUM_MASTER_BITS,
                                AHB_NUM_SLAVES,
                                AHB_ADDRESS_WIDTH,
                                AHB_WDATA_WIDTH,
                                AHB_RDATA_WIDTH) ahb_master_sequence_t;

  mvc_sequencer  ahb_master_sequencer;

  typedef ahb_vip_config #(AHB_NUM_MASTERS,
                           AHB_NUM_MASTER_BITS,
                           AHB_NUM_SLAVES,
                           AHB_ADDRESS_WIDTH,
                           AHB_WDATA_WIDTH,
                           AHB_RDATA_WIDTH) ahb_vip_config_t;

  ahb_vip_config_t ahb_master_cfg;


// ****************************************************************************
  function new(string name = "" );
     super.new( name );
     if( !uvm_config_db #(ahb_vip_config_t)::get( null, UVMF_CONFIGURATIONS, VIP_AHB_BFM_MSTR, ahb_master_cfg ) )
            `uvm_error("CFG" , "uvm_config_db #( ahb_vip_config )::get cannot find resource ahb_master_cfg" )
  endfunction

// ****************************************************************************
  function string convert2string();
     return {super.convert2string()};
  endfunction

// ****************************************************************************
task timeout();
`ifndef XRTL
  repeat (10000) ahb_master_cfg.wait_for_clock(); //# 100us;
`else
  ahb_master_cfg.m_bfm.advance_hardware(10000);
`endif
endtask

// ****************************************************************************
  virtual task body();
     // Construct a new ahb_master_sequence_t type of object named ahb_master_seq
     ahb_master_sequence_t ahb_master_seq =
                    ahb_master_sequence_t::type_id::create("ahb_master_sequence");

     fork
       ahb_master_seq.start( ahb_master_sequencer );  
       timeout();
     join_any

  endtask

endclass
