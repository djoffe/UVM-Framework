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
// Project         : UVM VIP Library
// Unit            : TB Top
// File            : hvl_top.sv
//----------------------------------------------------------------------
// Creation Date   : 05.12.2011
//----------------------------------------------------------------------
// Description: This module contains the non-synthesizable test bench
//     content.  This module allong with hdl_top form the two top level
//     modules of the project.
//
//     This module includes:
//
//          run_test(): This task initiates the UVM phases and blocks
//                    until all UVM phases are complete.
//
//----------------------------------------------------------------------
//
import uvm_pkg::*;
import uvmf_base_pkg::*;
import mvc_pkg::*;
import mgc_ahb_v2_0_pkg::*;
import vip_ahb_example_test_pkg::*;
import vip_ahb_example_parameters_pkg::*;

`include "mvc_macros.svh"

module hvl_top;

  mgc_ahb_master_hvl #(
    .NUM_MASTERS(TEST_AHB_NUM_MASTERS),
    .NUM_MASTER_BITS(TEST_AHB_NUM_MASTER_BITS),
    .NUM_SLAVES(TEST_AHB_NUM_SLAVES),
    .ADDRESS_WIDTH(TEST_AHB_ADDRESS_WIDTH),
    .WDATA_WIDTH(TEST_AHB_WDATA_WIDTH),
    .RDATA_WIDTH(TEST_AHB_RDATA_WIDTH),
    .VIP_IF_UVM_NAME(VIP_AHB_BFM_MSTR),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES),
    .VIP_IF_HDL_PATH("hdl_top.ahb_master")
  ) ahb_master ();

  // The instantiation of the HVL side of the DUT, the AHB slave
  // (also TLM VIP under the hood, hence an HVL side to it)
  ahb_memory_slave_module_hvl #(
    .AHB_NUM_MASTERS(TEST_AHB_NUM_MASTERS),
    .AHB_NUM_MASTER_BITS(TEST_AHB_NUM_MASTER_BITS),
    .AHB_NUM_SLAVES(TEST_AHB_NUM_SLAVES),
    .AHB_ADDRESS_WIDTH(TEST_AHB_ADDRESS_WIDTH),
    .AHB_WDATA_WIDTH(TEST_AHB_WDATA_WIDTH),
    .AHB_RDATA_WIDTH(TEST_AHB_RDATA_WIDTH),
    .AHB_SLAVE_INDEX(0)
  ) DUT ();

  initial
     DUT.initialize(VIP_AHB_BFM_SLV);

  initial
     run_test();

endmodule
