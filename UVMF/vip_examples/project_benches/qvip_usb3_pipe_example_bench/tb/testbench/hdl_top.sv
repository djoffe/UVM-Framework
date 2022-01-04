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
// Project         : UVMF_3_4a_Templates
// Unit            : hdl_top
// File            : hdl_top.svh
//----------------------------------------------------------------------
// Created by      : Vijay Gill
// Creation Date   : 2015/04/30
//----------------------------------------------------------------------

// Description: This top level module instantiates all synthesizable
//    static content.  This and tb_top.sv are the two top level modules
//    of the simulation.  
//
//    This module instantiates the following:
//        DUT: The Design Under Test
//        Interfaces:  Signal bundles that contain signals connected to DUT
//        Driver BFM's: BFM's that actively drive interface signals
//        Monitor BFM's: BFM's that passively monitor interface signals
//
//----------------------------------------------------------------------
//
import qvip_usb3_pipe_example_bench_parameters_pkg::*;

module hdl_top;
// pragma attribute hdl_top partition_module_xrtl                                            

  // regs/wire needed for RTL connections
  reg clk;
  reg areset;

  wire [((DATA_BUS_WIDTH) - 1):0]      pipe_txd;
  wire [((DATA_BUS_WIDTH / 8) - 1):0]  pipe_txk;
  wire                                 pipe_txelecidle;
  wire                                 pipe_txdetect_lpbk;
  wire [1:0]                           pipe_pwrdown;
  wire                                 pipe_rxpolarityinv;
  wire                                 pipe_rxeqtrng;
  wire                                 pipe_txoneszeros;
  wire [1:0]                           pipe_phy_mode;
  wire                                 pipe_rate;
  wire [17:0]                          pipe_txdeemph;
  wire [2:0]                           pipe_txmargin;
  wire                                 pipe_txswing;
  wire                                 pipe_elas_buf_mode;
  wire                                 pipe_rxtermination;
  wire                                 pipe_txdata_valid;
  wire                                 pipe_txstart_block;
  wire [3:0]                           pipe_txsync_header;
  wire                                 pipe_txblock_align_control;
  wire                                 pipe_rxstandby;
  wire [1:0]                           pipe_width;
  wire [2:0]                           pipe_pclk_rate;
  wire                                 pipe_pclkchange_ack;
  wire [((DATA_BUS_WIDTH) - 1):0]     pipe_rxd;
  wire [((DATA_BUS_WIDTH / 8) - 1):0] pipe_rxk;
  wire                                pipe_rxvalid;
  wire                                pipe_rxelecidle;
  wire                                pipe_phystatus;
  wire [2:0]                          pipe_rxstatus;
  wire                                pipe_rxdata_valid;
  wire                                pipe_rxstart_block;
  wire [3:0]                          pipe_rxsync_header;
  wire                                pipe_rxstandby_status;
  wire                                pipe_pclkchange_ok;

  // Instantiate the QVIP Phy Host Wrapper Module
  usb_ss_phy_host # (
                      .DATA_BUS_WIDTH (DATA_BUS_WIDTH),
                      .IF_NAME        ("qvip_usb_host_BFM"),
                      .PATH_NAME      ("UVMF_VIRTUAL_INTERFACES"),
                      .EN_LTSSM_COV   ( 1 )
                    )
         phy_host   (
                      .clk                        (clk),
                      .areset                     (areset),
                      .pipe_txd                   (pipe_txd),
                      .pipe_txk                   (pipe_txk),
                      .pipe_txelecidle            (pipe_txelecidle),
                      .pipe_txdetect_lpbk         (pipe_txdetect_lpbk),
                      .pipe_pwrdown               (pipe_pwrdown),
                      .pipe_rxpolarityinv         (pipe_rxpolarityinv),
                      .pipe_rxeqtrng              (pipe_rxeqtrng),
                      .pipe_txoneszeros           (pipe_txoneszeros),
                      .pipe_phy_mode              (pipe_phy_mode),
                      .pipe_rate                  (pipe_rate),
                      .pipe_txdeemph              (pipe_txdeemph),
                      .pipe_txmargin              (pipe_txmargin),
                      .pipe_txswing               (pipe_txswing ),
                      .pipe_elas_buf_mode         (pipe_elas_buf_mode),
                      .pipe_rxtermination         (pipe_rxtermination),
                      .pipe_txdata_valid          (pipe_txdata_valid),
                      .pipe_txstart_block         (pipe_txstart_block),
                      .pipe_txsync_header         (pipe_txsync_header),
                      .pipe_txblock_align_control (pipe_txblock_align_control),
                      .pipe_rxstandby             (pipe_rxstandby),
                      .pipe_width                 (pipe_width),
                      .pipe_pclk_rate             (pipe_pclk_rate),
                      .pipe_pclkchange_ack        (pipe_pclkchange_ack),

                      .pipe_rxd                   (pipe_rxd),
                      .pipe_rxk                   (pipe_rxk),
                      .pipe_rxvalid               (pipe_rxvalid),
                      .pipe_rxelecidle            (pipe_rxelecidle),
                      .pipe_phystatus             (pipe_phystatus),
                      .pipe_rxstatus              (pipe_rxstatus),
                      .pipe_rxdata_valid          (pipe_rxdata_valid),
                      .pipe_rxstart_block         (pipe_rxstart_block),
                      .pipe_rxsync_header         (pipe_rxsync_header),
                      .pipe_rxstandby_status      (pipe_rxstandby_status),
                      .pipe_pclkchange_ok         (pipe_pclkchange_ok)
                    );

// Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
// The signal bundle, _if, contains signals to be connected to the DUT.
// The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
// The driver, driver_bfm, drives transactions onto the bus, _if.

  
// qvip_if          qvip_usb_host_bus();
// qvip_monitor_bfm qvip_usb_host_monitor_bfm(qvip_usb_host_bus);
// qvip_driver_bfm  qvip_usb_host_driver_bfm(qvip_usb_host_bus);
 

// Instantiate DUT here
  mac_device_dut #(
                    DATA_BUS_WIDTH
                  )
             DUT  (
                    .clk                        (clk),
                    .areset                     (areset),
                    .pipe_txd                   (pipe_txd),
                    .pipe_txk                   (pipe_txk),
                    .pipe_txelecidle            (pipe_txelecidle),
                    .pipe_txdetect_lpbk         (pipe_txdetect_lpbk),
                    .pipe_pwrdown               (pipe_pwrdown),
                    .pipe_rxpolarityinv         (pipe_rxpolarityinv),
                    .pipe_rxeqtrng              (pipe_rxeqtrng),
                    .pipe_txoneszeros           (pipe_txoneszeros),
                    .pipe_phy_mode              (pipe_phy_mode),
                    .pipe_rate                  (pipe_rate),
                    .pipe_txdeemph              (pipe_txdeemph),
                    .pipe_txmargin              (pipe_txmargin),
                    .pipe_txswing               (pipe_txswing ),
                    .pipe_elas_buf_mode         (pipe_elas_buf_mode),
                    .pipe_rxtermination         (pipe_rxtermination),
                    .pipe_txdata_valid          (pipe_txdata_valid),
                    .pipe_txstart_block         (pipe_txstart_block),
                    .pipe_txsync_header         (pipe_txsync_header),
                    .pipe_txblock_align_control (pipe_txblock_align_control),
                    .pipe_rxstandby             (pipe_rxstandby),
                    .pipe_width                 (pipe_width),
                    .pipe_pclk_rate             (pipe_pclk_rate),
                    .pipe_pclkchange_ack        (pipe_pclkchange_ack),
                    .pipe_rxd                   (pipe_rxd),
                    .pipe_rxk                   (pipe_rxk),
                    .pipe_rxvalid               (pipe_rxvalid),
                    .pipe_rxelecidle            (pipe_rxelecidle),
                    .pipe_phystatus             (pipe_phystatus),
                    .pipe_rxstatus              (pipe_rxstatus),
                    .pipe_rxdata_valid          (pipe_rxdata_valid),
                    .pipe_rxstart_block         (pipe_rxstart_block),
                    .pipe_rxsync_header         (pipe_rxsync_header),
                    .pipe_rxstandby_status      (pipe_rxstandby_status),
                    .pipe_pclkchange_ok         (pipe_pclkchange_ok)
                  );

  // Generate clk
  initial begin
    clk = 1'b0;
    forever begin
      #(4ns) clk = ~clk;
    end
  end

  // Generate reset
  initial begin
    areset = 1'b0;
    #20ns;
    areset = 1'b1;
  end

endmodule
