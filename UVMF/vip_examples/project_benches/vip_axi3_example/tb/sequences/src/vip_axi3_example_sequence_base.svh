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
// File            : vip_axi3_sequence_base.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the base top level sequence.  It
//    defines the top level flow of stimulus.
//
//----------------------------------------------------------------------
//
class vip_axi3_example_sequence_base #(int AXI_ADDRESS_WIDTH  =  32,
                                       int AXI_RDATA_WIDTH =  32,
                                       int AXI_WDATA_WIDTH =  32,
                                       int AXI_ID_WIDTH = 2,
                                       type REQ=uvm_sequence_item,
                                       type RSP=uvm_sequence_item)
                                       extends uvmf_sequence_base #(REQ,RSP);

  `uvm_object_param_utils( vip_axi3_example_sequence_base #(AXI_ADDRESS_WIDTH,
                                                            AXI_RDATA_WIDTH,
                                                            AXI_WDATA_WIDTH,
                                                            AXI_ID_WIDTH,
                                                            REQ,RSP));

  typedef axi_simple_rd_wr_sequence   #(AXI_ADDRESS_WIDTH,
                                        AXI_RDATA_WIDTH,
                                        AXI_WDATA_WIDTH,
                                        AXI_ID_WIDTH
                                       ) axi3_master_sequence_t;

  mvc_sequencer  axi3_master_sequencer;

  typedef axi_vip_config #(AXI_ADDRESS_WIDTH,
                           AXI_RDATA_WIDTH,
                           AXI_WDATA_WIDTH,
                           AXI_ID_WIDTH) axi_vip_config_t;

  axi_vip_config_t axi_master_cfg;

// ****************************************************************************
  function new(string name = "" );
     super.new( name );
     if( !uvm_config_db #(axi_vip_config_t)::get( null, UVMF_CONFIGURATIONS, VIP_AXI3_BFM, axi_master_cfg ) )
        `uvm_error("Config Error" , "uvm_config_db #( axi_vip_config )::get cannot find resource axi_master_cfg" )
  endfunction

// ****************************************************************************
  function string convert2string();
     return {super.convert2string()};
  endfunction

// ****************************************************************************
task timeout();
`ifndef XRTL
  repeat (10000) axi_master_cfg.wait_for_clock(); //# 100us;
`else
  axi_master_cfg.m_bfm.wait_for_ACLK(QUESTA_MVC::QUESTA_MVC_POSEDGE, 10000);
`endif
endtask

// ****************************************************************************
  virtual task body();
     // Construct a new axi3_master_sequence_t type of object named axi3_master_sequence
     axi3_master_sequence_t axi3_master_seq =
        axi3_master_sequence_t::type_id::create("axi3_master_sequence");

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
     // The `ifndef is because the pre 10.4 version of the axi_simple_rd_wr_sequence in use here
     // does not support specifying of address start/end constraints via the following properties. 
     // Rather it has them hardcoded to be the same value.

     // Specify start and end address for Read/Write transactions.
     // These are derived from the memory range (currently) suported by slave DUT
     axi3_master_seq.start_addr = 0;
     axi3_master_seq.end_addr = 1024 - 64;
`endif

     fork
       axi3_master_seq.start( axi3_master_sequencer );
       timeout();
     join_any
  endtask

endclass
