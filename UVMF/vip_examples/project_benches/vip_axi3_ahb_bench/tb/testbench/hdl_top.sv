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
import vip_axi3_ahb_parameters_pkg::*;

module hdl_top; //pragma attribute hdl_top partition_module_xrtl

  mgc_axi_signal_if #(
    .ADDR_WIDTH(TEST_AXI_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI_ID_WIDTH)
  ) axi3_if (1'bz, 1'bz);

  mgc_axi_master_hdl #(
    .ADDR_WIDTH(TEST_AXI_ADDRESS_WIDTH),
    .RDATA_WIDTH(TEST_AXI_RDATA_WIDTH),
    .WDATA_WIDTH(TEST_AXI_WDATA_WIDTH),
    .ID_WIDTH(TEST_AXI_ID_WIDTH),
    .VIP_IF_UVM_NAME(VIP_AXI3_BFM_MSTR),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES)
  ) axi3_master (.pin_if(axi3_if));

  mgc_ahb_signal_if #(
    .NUM_MASTERS(TEST_AHB_NUM_MASTERS),
    .NUM_MASTER_BITS(TEST_AHB_NUM_MASTER_BITS),
    .NUM_SLAVES(TEST_AHB_NUM_SLAVES),
    .ADDRESS_WIDTH(TEST_AHB_ADDRESS_WIDTH),
    .WDATA_WIDTH(TEST_AHB_WDATA_WIDTH),
    .RDATA_WIDTH(TEST_AHB_RDATA_WIDTH)
  ) ahb_if (1'bz, 1'bz);

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
  
  AXI_slave_v axi_slave (
    .ACLK    (axi3_if.ACLK),
    .ARESETn (axi3_if.ARESETn),
    .AWVALID (axi3_if.AWVALID),
    .AWADDR  (axi3_if.AWADDR),
    .AWLEN   (axi3_if.AWLEN[3:0]),
    .AWSIZE  (axi3_if.AWSIZE),
    .AWBURST (axi3_if.AWBURST),
    .AWLOCK  (axi3_if.AWLOCK),
    .AWCACHE (axi3_if.AWCACHE),
    .AWPROT  (axi3_if.AWPROT),
    .AWID    (axi3_if.AWID),
    .AWREADY (axi3_if.AWREADY),
    .ARVALID (axi3_if.ARVALID),
    .ARADDR  (axi3_if.ARADDR),
    .ARLEN   (axi3_if.ARLEN[3:0]),
    .ARSIZE  (axi3_if.ARSIZE),
    .ARBURST (axi3_if.ARBURST),
    .ARLOCK  (axi3_if.ARLOCK),
    .ARCACHE (axi3_if.ARCACHE),
    .ARPROT  (axi3_if.ARPROT),
    .ARID    (axi3_if.ARID),
    .ARREADY (axi3_if.ARREADY),
    .RVALID  (axi3_if.RVALID),
    .RLAST   (axi3_if.RLAST),
    .RDATA   (axi3_if.RDATA),
    .RRESP   (axi3_if.RRESP),
    .RID     (axi3_if.RID),
    .RREADY  (axi3_if.RREADY),
    .WVALID  (axi3_if.WVALID),
    .WLAST   (axi3_if.WLAST),
    .WDATA   (axi3_if.WDATA),
    .WSTRB   (axi3_if.WSTRB),
    .WID     (axi3_if.WID),
    .WREADY  (axi3_if.WREADY),
    .BVALID  (axi3_if.BVALID),
    .BRESP   (axi3_if.BRESP),
    .BID     (axi3_if.BID),
    .BREADY  (axi3_if.BREADY));

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

  // The instantiation of the clock and reset module
 clk_reset axi3_clk_rst_inst (
                          axi3_if.ACLK,
                          axi3_if.ARESETn
                         );

  // The instantiation of the arbiter module
  ahb_arbiter ahb_arbiter1 (
    ahb_if.arbiter_HGRANT,
    ahb_if.HMASTER,
    ahb_if.arbiter_HMASTLOCK,
    ahb_if.arbiter_HLOCK,
    ahb_if.HCLK
  );

  // The instantiation of the clock and reset module
  clk_reset ahb_clk_rst_inst (
                          ahb_if.HCLK,
                          ahb_if.HRESETn
                         );

endmodule
