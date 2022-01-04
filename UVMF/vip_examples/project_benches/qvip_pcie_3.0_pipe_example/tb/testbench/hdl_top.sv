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
//----------------------------------------------------------------------
//
// Module: hdl_top
// This file shows the pipe level connection where RC is configured as PHY and EP as MAC.
// For more information, please reference Questa Verification IP PCI Express User Guide,
// "PIPE Interface, DUT as EP MAC" use case.
// Clock and reset are generated from RC and are connected to EP DUT. This is intended to work in Gen3 configuration.
//
// Follwing are the parameters definition:
//
// - LANES                     - Link width of the interface.Used for configuring number of lanes in the interface.
//
// - PIPE_BYTES_MAX            - Pipe width of the pipe interface. 1 => 8 bit interface, 2 => 16 bit interface, 4 => 32 bit interface.
//
// - CONFIG_NUM_OF_FUNCTIONS   - Number of physical function available at the Device.
//
// These parameters are set only in the top level modules and it will be reflected in the entire environment.
// User should not set these parameters anywhere else.

module hdl_top();

import uvm_pkg::*;
import mvc_pkg::*;
import questa_uvm_pkg::*;
import QUESTA_MVC::*;
import mgc_pcie_v2_0_pkg::*;

`include "uvm_macros.svh"

import uvmf_base_pkg_hdl::*;
import uvmf_base_pkg::*;
import qvip_pcie_3_0_pipe_example_env_pkg::*;
import qvip_pcie_3_0_pipe_example_test_pkg::*;

  wire [(LANES*PIPE_BYTES_MAX*8)-1:0] TX_DATA;
  wire [(LANES*PIPE_BYTES_MAX)-1:0]   TX_DATAK;
  wire [LANES-1:0] TX_ELECIDLE;
  wire [LANES-1:0] TX_DATAVALID;
  wire [LANES-1:0] TX_COMPLIANCE;
  wire [LANES-1:0] RX_POLARITY;
  wire [(LANES*18)-1:0] TX_DEEMPH;
  wire [LANES-1:0] TX_STARTBLOCK;
  wire [(LANES*2)-1:0] TX_SYNCHEADER;
  wire [(LANES*3)-1:0] RX_PRESETHINT;
  wire [LANES-1:0] RX_EQEVAL;
  wire [LANES-1:0] INVALIDREQUEST;
  wire [LANES-1:0] RX_STANDBY;
  wire [LANES-1:0] TX_DETECTRX_LOOPBACK;
  wire [(LANES*2)-1:0] RATE;
  wire [(LANES*3)-1:0] TX_MARGIN;
  wire [LANES-1:0] TX_SWING;
  wire [(LANES*2)-1:0] WIDTH;
  wire [(LANES*6)-1:0] LF;
  wire [(LANES*6)-1:0] FS;
  wire [LANES-1:0] BLOCKALIGNCONTROL;
  wire [(LANES*3)-1:0] PCLK_RATE;
  wire [(LANES*3)-1:0] POWERDOWN;
  wire [3:0] LOCALPRESETINDEX;
  wire GETLOCALPRESETCOEFFICIENTS;
  wire  [(LANES*PIPE_BYTES_MAX*8)-1:0] RX_DATA;
  wire  [(LANES*PIPE_BYTES_MAX)-1:0]   RX_DATAK;
  wire  [LANES-1:0] PHYSTATUS;
  wire  [LANES-1:0] RX_VALID;
  wire  [LANES-1:0] RX_ELECIDLE;
  wire  [LANES-1:0] RX_STARTBLOCK;
  wire  [(LANES*2)-1:0] RX_SYNCHEADER;
  wire  [LANES-1:0] RX_DATAVALID;
  wire  [(LANES*8)-1:0] LINK_EVAL_FBACK_FIG_MERIT;
  wire  [(LANES*6)-1:0] LINK_EVAL_FBACK_DIR_CHANGE;
  wire  [LANES-1:0] RX_STANDBY_STATUS;
  wire  [(LANES*3)-1:0] RX_STATUS;
  wire  [(LANES*18)-1:0] LOCAL_TX_PRESET_COEFFS;
  wire [1:0] DATABUSWIDTH;
  wire [5:0] LOCALFS;
  wire [5:0] LOCALLF;
  wire       LOCALTXCOEFFICIENTSVALID;
  wire clk;
  wire rst_n;
  wire PCLKREQ_n;
  wire PCLKACK_n;
  wire RxEIDetectDisable;
  wire TxCommonModeDisable;
  wire [2:0] powerdown;

  // RC PHY instantiation
  // clk and rst_n are generated from this module and are connected to DUT
  pcie_rc_pipe_phy #(.LANES(LANES), 
                     .PIPE_BYTES_MAX(PIPE_BYTES_MAX), 
                     .CONFIG_NUM_OF_FUNCTIONS(CONFIG_NUM_OF_FUNCTIONS), 
                     .INTERFACE_NAME ("PCIE_RC_IF"), 
                     .PATH_NAME (UVMF_VIRTUAL_INTERFACES)) 
                rc (.*);

  // EP DUT instantiation
  pcie_ep_pipe_mac_dummy_dut #(.LANES(LANES), .PIPE_BYTES_MAX(PIPE_BYTES_MAX), 
                               .CONFIG_NUM_OF_FUNCTIONS(CONFIG_NUM_OF_FUNCTIONS)) 
  DUT(
    .clk(clk),
    .rst_n(rst_n),
    .pipe_txdata(TX_DATA),
    .pipe_txdatak(TX_DATAK),
    .pipe_txelecidle(TX_ELECIDLE),
    .pipe_txdatavalid(TX_DATAVALID),
    .pipe_txcompliance(TX_COMPLIANCE),
    .pipe_rxpolarity(RX_POLARITY),
    .pipe_txdeemph(TX_DEEMPH),
    .pipe_txstartblock(TX_STARTBLOCK),
    .pipe_txsyncheader(TX_SYNCHEADER),
    .pipe_rxpresethint(RX_PRESETHINT),
    .pipe_rxeqeval(RX_EQEVAL),
    .pipe_invalidrequest(INVALIDREQUEST),
    .pipe_rxstandby(RX_STANDBY),
    .pipe_txdetectrxloopback(TX_DETECTRX_LOOPBACK),
    .pipe_rate(RATE),
    .pipe_txmargin(TX_MARGIN),
    .pipe_txswing(TX_SWING),
    .pipe_width(WIDTH),
    .pipe_lf(LF),
    .pipe_fs(FS),
    .pipe_blockaligncontrol(BLOCKALIGNCONTROL),
    .pipe_pclkrate(PCLK_RATE),
    .pipe_powerdown(powerdown),
    .pipe_localpresetindex(LOCALPRESETINDEX),
    .pipe_getlocalpresetcoefficients(GETLOCALPRESETCOEFFICIENTS),
    .PCLKREQ_n(PCLKREQ_n),
    .pipe_rxdata(RX_DATA),
    .pipe_rxdatak(RX_DATAK),
    .pipe_phystatus(PHYSTATUS),
    .pipe_rxvalid(RX_VALID),
    .pipe_rxelecidle(RX_ELECIDLE),
    .pipe_rxstartblock(RX_STARTBLOCK),
    .pipe_rxsyncheader(RX_SYNCHEADER),
    .pipe_rxdatavalid(RX_DATAVALID),
    .pipe_linkevalfbackfigmerit(LINK_EVAL_FBACK_FIG_MERIT),
    .pipe_linkevalfbackdirchange(LINK_EVAL_FBACK_DIR_CHANGE),
    .pipe_rxstandbystatus(RX_STANDBY_STATUS),
    .pipe_rxstatus(RX_STATUS),
    .pipe_localtxpresetcoeffs(LOCAL_TX_PRESET_COEFFS),
    .pipe_databuswidth(DATABUSWIDTH),
    .pipe_localfs(LOCALFS),
    .pipe_locallf(LOCALLF),
    .pipe_localtxcoefficientsvalid(LOCALTXCOEFFICIENTSVALID),
    .PCLKACK_n(PCLKACK_n)
  );

  // Since in pcie_ep_pipe_mac_dummy_dut, pipe_powerdown is a signal of one 
  // lane, and is connected to POWERDOWN which is per lane signal.
  generate
    genvar lane;
    for(lane = 0; lane < LANES; lane++) begin
      assign POWERDOWN[((lane+1)*3)-1:lane*3] = powerdown; 
    end
  endgenerate

endmodule

