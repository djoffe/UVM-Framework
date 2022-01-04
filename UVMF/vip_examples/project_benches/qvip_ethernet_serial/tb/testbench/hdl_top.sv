//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : aattarha
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_serial Simulation Bench 
// Unit            : HDL top level module
// File            : hdl_top.sv
//----------------------------------------------------------------------
//                                          
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
//----------------------------------------------------------------------
//

import qvip_ethernet_serial_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;
`timescale 1ps/1ps
module hdl_top;
// pragma attribute hdl_top partition_module_xrtl                                            

// Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
// The signal bundle, _if, contains signals to be connected to the DUT.
// The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
// The driver, driver_bfm, drives transactions onto the bus, _if.


wire                    pkt_rx_avail;           // From dut of xge_mac.v
wire [63:0]             pkt_rx_data;            // From dut of xge_mac.v
wire [63:0]             pkt_tx_data;            // From dut of xge_mac.v
wire                    pkt_rx_eop;             // From dut of xge_mac.v
wire                    pkt_tx_eop;             // From dut of xge_mac.v
wire [2:0]              pkt_rx_mod;             // From dut of xge_mac.v
wire [2:0]              pkt_tx_mod;             // From dut of xge_mac.v
wire                    pkt_rx_err;             // From dut of xge_mac.v
wire                    pkt_rx_sop;             // From dut of xge_mac.v
wire                    pkt_tx_sop;             // From dut of xge_mac.v
wire                    pkt_rx_val;             // From dut of xge_mac.v
wire                    pkt_tx_val;             // From dut of xge_mac.v
wire                    pkt_rx_ren;             // From dut of xge_mac.v
wire                    pkt_tx_full;            // From dut of xge_mac.v
wire                    wb_ack_o;               // From dut of xge_mac.v
wire [31:0]             wb_dat_o;               // From dut of xge_mac.v
wire                    wb_int_o;               // From dut of xge_mac.v
wire [7:0]              xgmii_txc;              // From dut of xge_mac.v
wire [7:0]              xgmii_rxc;              // From dut of xge_mac.v
wire [7:0]              wb_adr_i;               // From dut of xge_mac.v
wire [31:0]             wb_dat_i;              // From dut of xge_mac.v
wire [63:0]             xgmii_txd;              // From dut of xge_mac.v
wire [63:0]             xgmii_rxd;              // From dut of xge_mac.v



  // Just a typedef for mgc_ethernet.
  typedef virtual mgc_ethernet bfm_type;

  // The instantiation of the Ethernet interface, with z's for the clk and reset, 
  // since they are driven at the RTL level.
  mgc_ethernet ethernet_if(.iclk_0(1'bz), .iclk_1(1'bz), .ireset(1'bz), .iMDC(1'bz), .ian_clk_0(1'bz), .ian_clk_1(1'bz));


  // Connections with DUT when available (with Dut's Tx)
  assign ethernet_if.XD[1][0] = dut.xgmii_txd[7:0];
  assign ethernet_if.XD[1][1] = dut.xgmii_txd[15:8];
  assign ethernet_if.XD[1][2] = dut.xgmii_txd[23:16];
  assign ethernet_if.XD[1][3] = dut.xgmii_txd[31:24];
  assign ethernet_if.XD[1][4] = dut.xgmii_txd[39:32];
  assign ethernet_if.XD[1][5] = dut.xgmii_txd[47:40];
  assign ethernet_if.XD[1][6] = dut.xgmii_txd[55:48];
  assign ethernet_if.XD[1][7] = dut.xgmii_txd[63:56];

  assign ethernet_if.XC[1][0] = dut.xgmii_txc[0];
  assign ethernet_if.XC[1][1] = dut.xgmii_txc[1];
  assign ethernet_if.XC[1][2] = dut.xgmii_txc[2];
  assign ethernet_if.XC[1][3] = dut.xgmii_txc[3];
  assign ethernet_if.XC[1][4] = dut.xgmii_txc[4];
  assign ethernet_if.XC[1][5] = dut.xgmii_txc[5];
  assign ethernet_if.XC[1][6] = dut.xgmii_txc[6];
  assign ethernet_if.XC[1][7] = dut.xgmii_txc[7];

  // Connections with DUT when available (with Dut's Rx)
  assign dut.xgmii_rxd[7:0]    = ethernet_if.XD[0][0];
  assign dut.xgmii_rxd[15:8]   = ethernet_if.XD[0][1];
  assign dut.xgmii_rxd[23:16]  = ethernet_if.XD[0][2];
  assign dut.xgmii_rxd[31:24]  = ethernet_if.XD[0][3];
  assign dut.xgmii_rxd[39:32]  = ethernet_if.XD[0][4];
  assign dut.xgmii_rxd[47:40]  = ethernet_if.XD[0][5];
  assign dut.xgmii_rxd[55:48]  = ethernet_if.XD[0][6];
  assign dut.xgmii_rxd[63:56]  = ethernet_if.XD[0][7];
                                                                  
  assign dut.xgmii_rxc[0]  = ethernet_if.XC[0][0];
  assign dut.xgmii_rxc[1]  = ethernet_if.XC[0][1];
  assign dut.xgmii_rxc[2]  = ethernet_if.XC[0][2];
  assign dut.xgmii_rxc[3]  = ethernet_if.XC[0][3];
  assign dut.xgmii_rxc[4]  = ethernet_if.XC[0][4];
  assign dut.xgmii_rxc[5]  = ethernet_if.XC[0][5];
  assign dut.xgmii_rxc[6]  = ethernet_if.XC[0][6];
  assign dut.xgmii_rxc[7]  = ethernet_if.XC[0][7];


  // QVIP sources both clk and reset
  wire clk_156m25          = ethernet_if.clk_0;
  wire reset_n             = ~ethernet_if.reset;

// Instantiate DUT here
xge_mac dut(/*AUTOINST*/
            // Outputs
            .pkt_rx_avail               (pkt_rx_avail),
            .pkt_rx_data                (pkt_rx_data[63:0]),
            .pkt_rx_eop                 (pkt_rx_eop),
            .pkt_rx_err                 (pkt_rx_err),
            .pkt_rx_mod                 (pkt_rx_mod[2:0]),
            .pkt_rx_sop                 (pkt_rx_sop),
            .pkt_rx_val                 (pkt_rx_val),
            .pkt_tx_full                (pkt_tx_full),
            .wb_ack_o                   (wb_ack_o),
            .wb_dat_o                   (wb_dat_o[31:0]),
            .wb_int_o                   (wb_int_o),
            .xgmii_txc                  (xgmii_txc[7:0]),
            .xgmii_txd                  (xgmii_txd[63:0]),
            // Inputs
            .clk_156m25                 (clk_156m25),
            .clk_xgmii_rx               (clk_156m25),
            .clk_xgmii_tx               (clk_156m25),
            .pkt_rx_ren                 (pkt_rx_ren),
            .pkt_tx_data                (pkt_tx_data[63:0]),
            .pkt_tx_eop                 (pkt_tx_eop),
            .pkt_tx_mod                 (pkt_tx_mod[2:0]),
            .pkt_tx_sop                 (pkt_tx_sop),
            .pkt_tx_val                 (pkt_tx_val),
            .reset_156m25_n             (reset_n),
            .reset_xgmii_rx_n           (reset_n),
            .reset_xgmii_tx_n           (reset_n),
            .wb_adr_i                   (wb_adr_i[7:0]),
            .wb_clk_i                   (wb_clk_i),
            .wb_cyc_i                   (wb_cyc_i),
            .wb_dat_i                   (wb_dat_i[31:0]),
            .wb_rst_i                   (wb_rst_i),
            .wb_stb_i                   (wb_stb_i),
            .wb_we_i                    (wb_we_i),
            .xgmii_rxc                  (xgmii_rxc[7:0]),
            .xgmii_rxd                  (xgmii_rxd[63:0]));


initial begin // tbx vif_binding_block
    import uvm_pkg::uvm_config_db;
// The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
// They are placed into the uvm_config_db using the string names defined in the parameters package.
// The string names are passed to the agent configurations by test_top through the top level configuration.
// They are retrieved by the agents configuration class for use by the agent.
   // UVM environment.
    uvm_config_db #( bfm_type )::set( null , "UVMF_VIRTUAL_INTERFACES" , ETH_10G_IF , ethernet_if );



  end

endmodule

