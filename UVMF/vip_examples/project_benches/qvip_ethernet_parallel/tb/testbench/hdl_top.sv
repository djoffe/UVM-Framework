//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : vgill
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_parallel Simulation Bench 
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

`timescale 1ps/1ps

import qvip_ethernet_parallel_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

module hdl_top;
// pragma attribute hdl_top partition_module_xrtl                                            

// Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
// The signal bundle, _if, contains signals to be connected to the DUT.
// The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
// The driver, driver_bfm, drives transactions onto the bus, _if.
  typedef virtual mgc_ethernet ethernet_if_t;

  wire clk_0 = ethernet_if.clk_0;
  wire clk_1 = ethernet_if.clk_1;
  wire reset = ethernet_if.reset;

  // Instantiate ethernet QVIP here
  mgc_ethernet ethernet_if(.iclk_0(1'bz), .iclk_1(1'bz), .ireset(1'bz), .iMDC(1'bz), .ian_clk_0(1'bz), .ian_clk_1(1'bz));

  // Instantiate DUT here
  ethernet_dummy_dut DUT 
     (
      // Clocks and reset
      .clk_0(clk_0), // input
      .clk_1(clk_1), // input
      .reset(reset), // input
      // Rx lanes
      .rx_lane_0(ethernet_if.L_10b[0][0]), // input [9:0]
      .rx_lane_1(ethernet_if.L_10b[0][1]), // input [9:0]
      .rx_lane_2(ethernet_if.L_10b[0][2]), // input [9:0]
      .rx_lane_3(ethernet_if.L_10b[0][3]), // input [9:0]
      // Tx lanes
      .tx_lane_0(ethernet_if.L_10b[1][0]), // output [9:0]
      .tx_lane_1(ethernet_if.L_10b[1][1]), // output [9:0]
      .tx_lane_2(ethernet_if.L_10b[1][2]), // output [9:0]
      .tx_lane_3(ethernet_if.L_10b[1][3])  // output [9:0]
     );

initial begin // tbx vif_binding_block
   import uvm_pkg::uvm_config_db;
   // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
   // They are placed into the uvm_config_db using the string names defined in the parameters package.
   // The string names are passed to the agent configurations by test_top through the top level configuration.
   // They are retrieved by the agents configuration class for use by the agent.

   // Place the virtual interface handle into the config_db for the test to retrieve
   uvm_config_db #( ethernet_if_t )::set(null,
                                         "UVMF_VIRTUAL_INTERFACES",
                                         "qvip_ethernet_BFM",
                                         ethernet_if);
  end

endmodule

