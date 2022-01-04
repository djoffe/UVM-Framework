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
// Unit            : DUT Top
// File            : hdl_top.sv
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This module instantiates the DUT and all interface bfm's.
//    These components are separated into this module to support emulation.
//    The components in this module are synthesizable, mostly ;-).
//
/*****************************************************************************
 *
 * Copyright 2007-2013 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT
 * TO LICENSE TERMS.
 *
 *****************************************************************************/

// Module: hdl_top
// This file shows the serial interface level connection.
// Here internal  clock and reset are provided to the environment. This is intended to
// work in Gen3 configuration.  This module instantiates a PCIe interface.
//
// In its initial block it calls run_test("test") which constructs and executes
// an UVM testbench.
//
// Communication between module and test is done using uvm_config_db.  Top level
// calls the test which has the test vectors.  Here  VIP component is configured
// as RC device and EP DUT component is acting as DUT.
//
// Follwing are the parameters definition:
// - LANES                     - Link width of the interface.Used for
//                               configuring number of lanes in the interface.
//
// - PIPE_BYTES_MAX            - Pipe width of the pipe interface. 1 => 8 bit
//                               interface, 2 => 16 bit interface, 4 => 32 bit
//                               interface.
//
// - CONFIG_NUM_OF_FUNCTIONS   - Number of physical function available at the
//                               Device.
//
// These parameters are set only in the tb_params_pkg.sv and it will be
// reflected in the entire environment.  User should not set these parameters
// anywhere else.
//
module hdl_top();
  import uvm_pkg::*;
  import uvmf_base_pkg_hdl::*;
  import qvip_pcie_3_0_serial_example_test_pkg::*;
  import mgc_pcie_v2_0_pkg::*;

  wire [TEST_LANES-1:0] rc_tx_data_plus;
  wire [TEST_LANES-1:0] rc_tx_data_minus;
  wire [TEST_LANES-1:0] rc_rx_data_plus;
  wire [TEST_LANES-1:0] rc_rx_data_minus;
  wire ref_clk;
  wire rst_n;

  ref_clk_generator clk_gen (.clk_100_mhz(ref_clk), .clk_125_mhz());

  // RC instantiation
  pcie_rc_serial #(.LANES(TEST_LANES), .CONFIG_NUM_OF_FUNCTIONS(TEST_CONFIG_NUM_OF_FUNCTIONS), .INTERFACE_NAME (PCIE_RC_IF))
    rc  ( .clk(),
          .rst_n(rst_n),
          .rx_data_plus(rc_rx_data_plus),
          .rx_data_minus(rc_rx_data_minus),
          .tx_data_plus(rc_tx_data_plus),
          .tx_data_minus(rc_tx_data_minus),
          .clkreq()
          );

  // EP instantiation
  pcie_ep_serial_dummy_dut #(.LANES(TEST_LANES), .CONFIG_NUM_OF_FUNCTIONS(TEST_CONFIG_NUM_OF_FUNCTIONS))
    DUT  ( .ref_clk(ref_clk),
          .rst_n(rst_n),
          .rx_p(rc_tx_data_plus),
          .rx_n(rc_tx_data_minus),
          .tx_p(rc_rx_data_plus),
          .tx_n(rc_rx_data_minus)
          );

endmodule
