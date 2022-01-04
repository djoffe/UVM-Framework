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
// Unit            : DUT Top
// File            : hdl_top.sv
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This module instantiates the DUT and all interface bfm's.
//    These components are separated into this module to support emulation.
//    The components in this module are synthesizable, mostly ;-).
//
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import vip_ahb_example_parameters_pkg::*;

module hdl_top; //pragma attribute hdl_top partition_module_xrtl

  mgc_ahb_signal_if #(
    .NUM_MASTERS(TEST_AHB_NUM_MASTERS),
    .NUM_MASTER_BITS(TEST_AHB_NUM_MASTER_BITS),
    .NUM_SLAVES(TEST_AHB_NUM_SLAVES),
    .ADDRESS_WIDTH(TEST_AHB_ADDRESS_WIDTH),
    .WDATA_WIDTH(TEST_AHB_WDATA_WIDTH),
    .RDATA_WIDTH(TEST_AHB_RDATA_WIDTH)
  ) ahb_if (1'bz, 1'bz);

  // The instantiation of the clock and reset module ...
  clk_reset clk_rst_inst (
    ahb_if.HCLK,
    ahb_if.HRESETn
  );

  mgc_ahb_master_hdl #(
    .NUM_MASTERS(TEST_AHB_NUM_MASTERS),
    .NUM_MASTER_BITS(TEST_AHB_NUM_MASTER_BITS),
    .NUM_SLAVES(TEST_AHB_NUM_SLAVES),
    .ADDRESS_WIDTH(TEST_AHB_ADDRESS_WIDTH),
    .WDATA_WIDTH(TEST_AHB_WDATA_WIDTH),
    .RDATA_WIDTH(TEST_AHB_RDATA_WIDTH),
    .VIP_IF_UVM_NAME(VIP_AHB_BFM_MSTR),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES)
  ) ahb_master (.pin_if(ahb_if));
  
  // Wiring of the RTL to the AHB SV Interface ahb_if
  // The instantiation of the DUT, the AHB RTL slave
  ahb_memory_slave_module_hdl #(
    .AHB_NUM_MASTERS(TEST_AHB_NUM_MASTERS),
    .AHB_NUM_MASTER_BITS(TEST_AHB_NUM_MASTER_BITS),
    .AHB_NUM_SLAVES(TEST_AHB_NUM_SLAVES),
    .AHB_ADDRESS_WIDTH(TEST_AHB_ADDRESS_WIDTH),
    .AHB_WDATA_WIDTH(TEST_AHB_WDATA_WIDTH),
    .AHB_RDATA_WIDTH(TEST_AHB_RDATA_WIDTH),
    .AHB_SLAVE_INDEX(0)
  ) DUT (.ahb_if(ahb_if));

  // The instantiation of the arbiter module
  ahb_arbiter ahb_arbiter1 (
    ahb_if.arbiter_HGRANT,
    ahb_if.HMASTER,
    ahb_if.arbiter_HMASTLOCK,
    ahb_if.arbiter_HLOCK,
    ahb_if.HCLK
  );

`ifdef XRTL
`ifdef AHB_QVL_MONITOR
  // The instantiation of the AHB QVL monitor
  qvl_amba3_ahb_monitor #(...) ahb_assertion_monitor (...);
`endif
`endif

endmodule
