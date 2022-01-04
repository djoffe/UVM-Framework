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
import vip_axi3_example_parameters_pkg::*;

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
    .VIP_IF_UVM_NAME(VIP_AXI3_BFM),
    .VIP_IF_UVM_CONTEXT(UVMF_VIRTUAL_INTERFACES)
  ) axi3_master (.pin_if(axi3_if));

        AXI_slave_v  DUT (
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
                             .BREADY  (axi3_if.BREADY)
                             );



  // The instantiation of the clock and reset module
 clk_reset clk_rst_inst (
                          axi3_if.ACLK,
                          axi3_if.ARESETn
                         );

endmodule
