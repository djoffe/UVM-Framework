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
// Created by      : student
// Creation Date   : 2014/11/05
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
import uvm_pkg::*;
import qvip_ahb_example_parameters_pkg::*;

module hdl_top;
// pragma attribute hdl_top partition_module_xrtl                                            

// Instantiate DUT here
//
// This is the top level module, instantiating the clock and reset logic, as well as
//       an AHB system consisting of 2 AHB masters, 2 AHB slaves, an AHB arbiter and an AHB decoder.
//       Master 0, Slave 0 and the decoder are the DUT's and thus are modeled in RTL.
//       Master 1, Slave 1 and the arbiter are all modeled within a single AHB QVIP interface.
//       A second AHB QVIP interface is instantiated in Passive (monitor) mode to monitor all AHB activity.
//

  wire                             HCLK;
  wire                             HRESETn;
  wire [(AHB_ADDRESS_WIDTH-1):0]   HADDR_m[AHB_NUM_MASTERS];
  wire [1:0]                       HTRANS_m[AHB_NUM_MASTERS];
  wire                             HWRITE_m[AHB_NUM_MASTERS];
  wire [2:0]                       HSIZE_m[AHB_NUM_MASTERS];
  wire [(AHB_WDATA_WIDTH-1):0]     HWDATA_m[AHB_NUM_MASTERS];
  wire [2:0]                       HBURST_m[AHB_NUM_MASTERS];
  wire [3:0]                       HPROT_m[AHB_NUM_MASTERS];
  wire [(AHB_RDATA_WIDTH-1):0]     HRDATA_m[AHB_NUM_MASTERS];
  wire                             HREADY_m[AHB_NUM_MASTERS];
  wire [1:0]                       HRESP_m[AHB_NUM_MASTERS];
  wire                             HMASTLOCK_m[AHB_NUM_MASTERS];
  wire                             HBUSREQ[AHB_NUM_MASTERS];
  wire                             HGRANT[AHB_NUM_MASTERS];
  wire                             HLOCK[AHB_NUM_MASTERS];
  wire [(AHB_ADDRESS_WIDTH-1):0]   HADDR_s[AHB_NUM_SLAVES];
  wire [1:0]                       HTRANS_s[AHB_NUM_SLAVES];
  wire                             HWRITE_s[AHB_NUM_SLAVES];
  wire [2:0]                       HSIZE_s[AHB_NUM_SLAVES];
  wire [(AHB_WDATA_WIDTH-1):0]     HWDATA_s[AHB_NUM_SLAVES];
  wire [2:0]                       HBURST_s[AHB_NUM_SLAVES];
  wire [3:0]                       HPROT_s[AHB_NUM_SLAVES];
  wire                             HMASTLOCK_s[AHB_NUM_SLAVES];
  wire [(AHB_RDATA_WIDTH-1):0]     HRDATA_s[AHB_NUM_SLAVES];
  wire                             HREADY_s[AHB_NUM_SLAVES];
  wire [1:0]                       HRESP_s[AHB_NUM_SLAVES];
  wire                             HREADYOUT[AHB_NUM_SLAVES];
  wire [(AHB_NUM_MASTER_BITS-1):0] HMASTER[AHB_NUM_SLAVES];
  wire [(AHB_NUM_MASTERS-1):0]     HSPLIT[AHB_NUM_SLAVES];
  wire                             HSEL[AHB_NUM_SLAVES];
  wire [(AHB_ADDRESS_WIDTH-1):0]   HADDR_d;
  wire                             HREADY_d;
  wire                             HSEL_wr[AHB_NUM_SLAVES];

  wire [5:0]                       HPROT_mon[AHB_NUM_MASTERS];
  wire [2:0]                       HRESP_mon[AHB_NUM_SLAVES];
   
  wire [0:0]                       unused_wire_1;
  wire [1:0]                       unused_wire_2;

  // following assign statements are used to simplify connection of signals to ahb_monitor_if
  assign HADDR_m[1]     = qvip_ahb_if.master_HADDR[1];
  assign HTRANS_m[1]    = qvip_ahb_if.master_HTRANS[1];
  assign HWRITE_m[1]    = qvip_ahb_if.master_HWRITE[1];
  assign HSIZE_m[1]     = qvip_ahb_if.master_HSIZE[1];
  assign HWDATA_m[1]    = qvip_ahb_if.master_HWDATA[1];
  assign HBURST_m[1]    = qvip_ahb_if.master_HBURST[1];
  assign HBUSREQ[1]     = qvip_ahb_if.master_HBUSREQ[1];
  assign HLOCK[1]       = qvip_ahb_if.master_HLOCK[1];
  assign HRDATA_s[1]    = qvip_ahb_if.master_HRDATA[1];
  assign HREADY_s[1]    = qvip_ahb_if.slave_HREADY[1];
  assign HSPLIT[1]      = qvip_ahb_if.slave_HSPLIT[1];
  assign HSEL[1]        = qvip_ahb_if.slave_HSEL[1];
  assign HPROT_mon[0]   = {2'b0, HPROT_m[0]};
  assign HPROT_mon[1]   = qvip_ahb_if.master_HPROT[1];
  assign HRESP_mon[0]   = {1'b0, HRESP_s[0]};
  assign HRESP_mon[1]   = qvip_ahb_if.master_HRESP[1];


  // Just a typedef for this mgc_ahb with these particular parameters and values.
  typedef virtual mgc_ahb #(AHB_NUM_MASTERS,
                            AHB_NUM_MASTER_BITS,
                            AHB_NUM_SLAVES,
                            AHB_ADDRESS_WIDTH,
                            AHB_WDATA_WIDTH,
                            AHB_RDATA_WIDTH) qvip_ahb_if_t ;

  // The instantiation of the clock and reset module
  clk_reset clk_rst_inst (HCLK, HRESETn);

  // The instantiation of the active interface which will be used to model a master, slave and the arbiter.
  mgc_ahb #(AHB_NUM_MASTERS,
            AHB_NUM_MASTER_BITS,
            AHB_NUM_SLAVES,
            AHB_ADDRESS_WIDTH,
            AHB_WDATA_WIDTH,
            AHB_RDATA_WIDTH) qvip_ahb_if (HCLK, HRESETn);

  // The instantiation of the passive interface which will be used as a monitor for all ahb activity.
  mgc_ahb #(AHB_NUM_MASTERS,
            AHB_NUM_MASTER_BITS,
            AHB_NUM_SLAVES,
            AHB_ADDRESS_WIDTH,
            AHB_WDATA_WIDTH,
            AHB_RDATA_WIDTH) qvip_ahb_monitor_if (HCLK, HRESETn);

  // Instantiation of QVIP connectivity module for monitor 
  ahb_monitor #(.NUM_MASTERS(AHB_NUM_MASTERS),
                .NUM_MASTER_BITS(AHB_NUM_MASTER_BITS),
                .NUM_SLAVES(AHB_NUM_SLAVES),
                .ADDR_WIDTH(AHB_ADDRESS_WIDTH),
                .WDATA_WIDTH(AHB_WDATA_WIDTH),
                .RDATA_WIDTH(AHB_RDATA_WIDTH)
               ) monitor (.ahb_if      (qvip_ahb_monitor_if),
                          .HADDR       (HADDR_m),
                          .HTRANS      (HTRANS_m),
                          .HWRITE      (HWRITE_m),
                          .HSIZE       (HSIZE_m),
                          .HWDATA      (HWDATA_m),
                          .HBURST      (HBURST_m),
                          .HPROT       (HPROT_mon),
                          .HBUSREQ     (HBUSREQ),
                          .HLOCK       (HLOCK),
                          .HRDATA      (HRDATA_s),
                          .HREADY      (HREADY_s),
                          .HRESP       (HRESP_mon),
                          .HSPLIT      (HSPLIT),
                          .HSEL        (HSEL),
                          .HMASTER     (qvip_ahb_if.HMASTER),
                          .HGRANT      (qvip_ahb_if.arbiter_HGRANT),
                          .HMASTLOCK   (qvip_ahb_if.HMASTLOCK),
                          .HBSTRB      (),
                          .HUNALIGN    (),
                          .HDOMAIN     ()
                         );


  // The instantiation of the DUT, the AHB RTL master 0
  ahb_verilog_master #(.AHB_NUM_MASTERS(AHB_NUM_MASTERS),
                       .AHB_NUM_MASTER_BITS(AHB_NUM_MASTER_BITS),
                       .AHB_NUM_SLAVES(AHB_NUM_SLAVES),
                       .AHB_ADDRESS_WIDTH(AHB_ADDRESS_WIDTH),
                       .AHB_WDATA_WIDTH(AHB_WDATA_WIDTH),
                       .AHB_RDATA_WIDTH(AHB_RDATA_WIDTH),
                       .AHB_MASTER_INDEX(0)
                      ) DUT (.HCLK      (HCLK),
                             .HRESETn   (HRESETn),
                             .HADDR     (HADDR_m[0]),
                             .HTRANS    (HTRANS_m[0]),
                             .HWRITE    (HWRITE_m[0]),
                             .HSIZE     (HSIZE_m[0]),
                             .HWDATA    (HWDATA_m[0]),
                             .HBURST    (HBURST_m[0]),
                             .HPROT     (HPROT_m[0]),
                             .HRDATA    (HRDATA_m[0]),
                             .HREADY    (HREADY_m[0]),
                             .HRESP     (HRESP_m[0]),
                             .HGRANT    (HGRANT[0]),
                             .HMASTLOCK (HMASTLOCK_m[0]),
                             .HBUSREQ   (HBUSREQ[0]),
                             .HLOCK     (HLOCK[0])
                            );

  // Instantiating QVIP connectivity module for master 0
  ahb_master #(.NUM_MASTERS(AHB_NUM_MASTERS),
               .NUM_MASTER_BITS(AHB_NUM_MASTER_BITS),
               .NUM_SLAVES(AHB_NUM_SLAVES),
               .ADDR_WIDTH(AHB_ADDRESS_WIDTH),
               .WDATA_WIDTH(AHB_WDATA_WIDTH),
               .RDATA_WIDTH(AHB_RDATA_WIDTH),
               .MASTER_INDEX(0)
              ) master0 (.ahb_if    (qvip_ahb_if),
                         .HADDR     (HADDR_m[0]),
                         .HTRANS    (HTRANS_m[0]),
                         .HWRITE    (HWRITE_m[0]),
                         .HSIZE     (HSIZE_m[0]),
                         .HWDATA    (HWDATA_m[0]),
                         .HBURST    (HBURST_m[0]),
                         .HPROT     ({2'b00, HPROT_m[0]}),
                         .HBUSREQ   (HBUSREQ[0]),
                         .HLOCK     (HLOCK[0]),
                         .HRDATA    (HRDATA_m[0]),
                         .HREADY    (HREADY_m[0]),
                         .HRESP     ({unused_wire_1, HRESP_m[0]}),
                         .HGRANT    ( HGRANT[0]),
                         .HMASTLOCK (HMASTLOCK_m[0]),
                         .HBSTRB    (),
                         .HUNALIGN  ()
                        );


  // The instantiation of AHB RTL slave 0
  ahb_verilog_slave #(.AHB_NUM_MASTERS(AHB_NUM_MASTERS),
                      .AHB_NUM_MASTER_BITS(AHB_NUM_MASTER_BITS),
                      .AHB_NUM_SLAVES(AHB_NUM_SLAVES),
                      .AHB_ADDRESS_WIDTH(AHB_ADDRESS_WIDTH),
                      .AHB_WDATA_WIDTH(AHB_WDATA_WIDTH),
                      .AHB_RDATA_WIDTH(AHB_RDATA_WIDTH),
                       .AHB_SLAVE_INDEX(0)
                     ) rtl_slave0 (.HCLK     (HCLK),
                                   .HRESETn  (HRESETn),
                                   .HADDR    (HADDR_s[0]),
                                   .HTRANS   (HTRANS_s[0]),
                                   .HWRITE   (HWRITE_s[0]),
                                   .HSIZE    (HSIZE_s[0]),
                                   .HWDATA   (HWDATA_s[0]),
                                   .HBURST   (HBURST_s[0]),
                                   .HRDATA   (HRDATA_s[0]),
                                   .HSEL     (HSEL[0]),
                                   .HREADYi  (HREADYOUT[0]),     // HREADYi scalar input
                                   .HREADYo  (HREADY_s[0]),      // HREADYo scalar output
                                   .HRESP    (HRESP_s[0]),
                                   .HSPLIT   (HSPLIT[0])
                                  );

  // Instantiating QVIP connectivity module for slave 0
  ahb_slave #(.NUM_MASTERS(AHB_NUM_MASTERS),
              .NUM_MASTER_BITS(AHB_NUM_MASTER_BITS),
              .NUM_SLAVES(AHB_NUM_SLAVES),
              .ADDR_WIDTH(AHB_ADDRESS_WIDTH),
              .WDATA_WIDTH(AHB_WDATA_WIDTH),
              .RDATA_WIDTH(AHB_RDATA_WIDTH),
              .SLAVE_INDEX(0)
             ) slave0 (.ahb_if      (qvip_ahb_if),
                       .HADDR       (HADDR_s[0]),
                       .HTRANS      (HTRANS_s[0]),
                       .HWRITE      (HWRITE_s[0]),
                       .HSIZE       (HSIZE_s[0]),
                       .HWDATA      (HWDATA_s[0]),
                       .HBURST      (HBURST_s[0]),
                       .HPROT       ({unused_wire_2, HPROT_s[0]}),
                       .HMASTER     (HMASTER[0]),
                       .HMASTLOCK   (HMASTLOCK_s[0]),
                       .HREADYOUT   (HREADYOUT[0]),
                       .HRDATA      (HRDATA_s[0]),
                       .HREADY      (HREADY_s[0]),
                       .HRESP       ({1'b0, HRESP_s[0]}),
                       .HSPLIT      (HSPLIT[0]),
                       .HSEL        (HSEL[0]),
                       .HBSTRB      (),
                       .HUNALIGN    (),
                       .HDOMAIN     ()
                      );


  // RTL decoder
  ahb_verilog_decoder #(.S0_START_ADDRESS(S0_START_ADDRESS),
                        .S0_END_ADDRESS(S0_END_ADDRESS),
                        .S1_START_ADDRESS(S1_START_ADDRESS),
                        .S1_END_ADDRESS(S1_END_ADDRESS),
                        .AHB_NUM_SLAVES(AHB_NUM_SLAVES),
                        .ADDRESSWIDTH(AHB_ADDRESS_WIDTH)
                       ) rtl_decoder (.HRESETn  (HRESETn),
                                      .HADDR    (HADDR_d),
                                      .HREADY   (HREADY_d),
                                      .HSEL     (HSEL_wr)
                                     );
                                                
  // Instantiating QVIP connectivity module for decoder
  ahb_decoder #(.NUM_MASTERS(AHB_NUM_MASTERS),
                .NUM_MASTER_BITS(AHB_NUM_MASTER_BITS),
                .NUM_SLAVES(AHB_NUM_SLAVES),
                .ADDR_WIDTH(AHB_ADDRESS_WIDTH),
                .WDATA_WIDTH(AHB_WDATA_WIDTH),
                .RDATA_WIDTH(AHB_RDATA_WIDTH)
               ) decoder (.ahb_if   (qvip_ahb_if),
                          .HSEL     (HSEL_wr),
                          .HADDR    (HADDR_d),
                          .HREADY   (HREADY_d)
                         );


initial begin // tbx vif_binding_block
  import uvm_pkg::uvm_config_db;
  // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
  // They are placed into the uvm_config_db using the string names defined in the parameters package.
  // The string names are passed to the agent configurations by test_top through the top level configuration.
  // They are retrieved by the agents configuration class for use by the agent.
 
  uvm_config_db #( qvip_ahb_if_t )::set( null , "UVMF_VIRTUAL_INTERFACES" , qvip_ahb_BFM , qvip_ahb_if ); 
  uvm_config_db #( qvip_ahb_if_t )::set( null , "UVMF_VIRTUAL_INTERFACES" , qvip_ahb_monitor_BFM , qvip_ahb_monitor_if ); 

end

endmodule

