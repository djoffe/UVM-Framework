/*****************************************************************************
 *
 * Copyright 2007-2015 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
 * MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
 *
 *****************************************************************************/

// Module: ethernet_dummy_dut

`timescale 1ps/1ps
`include "uvm_macros.svh"

module ethernet_dummy_dut (clk_0, clk_1, reset, rx_lane_0, rx_lane_1, rx_lane_2, rx_lane_3, tx_lane_0, tx_lane_1, tx_lane_2, tx_lane_3);
  import uvm_pkg::*;
  import mvc_pkg::*;
  import mgc_ethernet_v1_0_pkg::*;

  // Clocks and reset
  input clk_0;
  input clk_1;
  input reset;

  input [9:0] rx_lane_0;
  input [9:0] rx_lane_1;
  input [9:0] rx_lane_2;
  input [9:0] rx_lane_3;

  output [9:0] tx_lane_0;
  output [9:0] tx_lane_1;
  output [9:0] tx_lane_2;
  output [9:0] tx_lane_3;
 
  // Ethernet Interface Instance
  mgc_ethernet ethernet_dut(.iclk_0(clk_0), .iclk_1(clk_1), .ian_clk_0(1'bz), .ian_clk_1(1'bz), .ireset(reset), .iMDC(1'bz));

 assign tx_lane_0    = ethernet_dut.L_10b[0][0];
 assign tx_lane_1    = ethernet_dut.L_10b[0][1];
 assign tx_lane_2    = ethernet_dut.L_10b[0][2];
 assign tx_lane_3    = ethernet_dut.L_10b[0][3];

 assign ethernet_dut.L_10b[1][0]   = rx_lane_0;
 assign ethernet_dut.L_10b[1][1]   = rx_lane_1;
 assign ethernet_dut.L_10b[1][2]   = rx_lane_2;
 assign ethernet_dut.L_10b[1][3]   = rx_lane_3;

  initial begin
    ethernet_dut.ethernet_set_device_abstraction_level(0, 0, 1);
    ethernet_dut.config_autoneg_enable = 0;
    // Configuring the 100GBASE-R with RS-FEC layer
    ethernet_dut.config_interface_type       = ETH_100G_BASE_R; 
    ethernet_dut.config_pma_lane_count       = 4;
    ethernet_dut.config_fec_lane_width       = 10;
    ethernet_dut.config_include_rs_fec_layer = 1;
    // Configuring the AMP counter for Tx and Rx
    ethernet_dut.config_rs_fec_amp_counter_4095[0] = 50;
    ethernet_dut.config_rs_fec_amp_counter_4095[1] = 50;
  end
endmodule
