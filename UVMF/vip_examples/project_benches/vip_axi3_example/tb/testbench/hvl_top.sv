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
import vip_axi3_example_parameters_pkg::*;
import vip_axi3_example_test_pkg::*;

module hvl_top;

  mgc_axi_master_hvl #(
    .ADDR_WIDTH(TEST_AXI_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI_ID_WIDTH),
    .VIP_IF_UVM_NAME(VIP_AXI3_BFM),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES),
    .VIP_IF_HDL_PATH("hdl_top.axi3_master")
  ) axi3_master ();

  initial run_test();

endmodule
