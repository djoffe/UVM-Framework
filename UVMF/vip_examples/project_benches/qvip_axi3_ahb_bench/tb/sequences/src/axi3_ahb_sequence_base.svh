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
// Unit            : Top level sequence base
// File            : axi3_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the base top level sequence.  It
//    defines the top level flow of stimulus.
//
//----------------------------------------------------------------------
//
class axi3_ahb_sequence_base #(
                                       int AHB_NUM_MASTERS = 1,
                                       int AHB_NUM_MASTER_BITS = 1,
                                       int AHB_NUM_SLAVES = 1,
                                       int AHB_ADDRESS_WIDTH = 32,
                                       int AHB_WDATA_WIDTH = 32,
                                       int AHB_RDATA_WIDTH = 32,
                                       int AXI_ADDRESS_WIDTH  =  32,
                                       int AXI_RDATA_WIDTH =  32,
                                       int AXI_WDATA_WIDTH =  32,
                                       int AXI_ID_WIDTH = 2,
                                       type REQ=uvm_sequence_item,
                                       type RSP=uvm_sequence_item)
                                       extends uvmf_sequence_base #(REQ,RSP);

  `uvm_object_param_utils( axi3_ahb_sequence_base #(
                                                            AHB_NUM_MASTERS ,
                                                            AHB_NUM_MASTER_BITS,
                                                            AHB_NUM_SLAVES,
                                                            AHB_ADDRESS_WIDTH,
                                                            AHB_WDATA_WIDTH,
                                                            AHB_RDATA_WIDTH,
                                                            AXI_ADDRESS_WIDTH,
                                                            AXI_RDATA_WIDTH,
                                                            AXI_WDATA_WIDTH,
                                                            AXI_ID_WIDTH,
                                                            REQ,RSP));

  typedef axi_simple_test_sequence   #(AXI_ADDRESS_WIDTH,
                                       AXI_RDATA_WIDTH,
                                       AXI_WDATA_WIDTH,
                                       AXI_ID_WIDTH
                                       ) axi3_master_sequence_t;

  mvc_sequencer  axi3_master_sequencer;

  // Instantiate a axi3_master_sequence_t type of object named axi3_master_seq.
  axi3_master_sequence_t axi3_master_seq;


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

  // Instantiate a ahb_master_sequence_t type of object named ahb_master_seq.
  ahb_master_sequence_t ahb_master_seq;

// ****************************************************************************
  function new(string name = "" );
     super.new( name );
  endfunction

// ****************************************************************************
  function string convert2string();
     return {super.convert2string()};
  endfunction

// ****************************************************************************
task timeout();
  # 100us;
endtask

// ****************************************************************************
  virtual task body();
     // Construct a new axi3_master_sequence_t type of object named axi3_master_seq
     axi3_master_sequence_t axi3_master_seq =
                    axi3_master_sequence_t::type_id::create("axi3_master_seq");
     ahb_master_sequence_t ahb_master_seq = 
                    ahb_master_sequence_t::type_id::create("ahb_master_seq");

     fork
       axi3_master_seq.start( axi3_master_sequencer );
       ahb_master_seq.start( ahb_master_sequencer );  
       timeout();
     join_any

  endtask

endclass

