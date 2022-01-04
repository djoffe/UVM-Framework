/*****************************************************************************
 *
 * Copyright 2007-2015 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO
 * LICENSE TERMS.
 *
 *****************************************************************************/

// Module: pcie_rc_pipe_phy
//
// This module is used to connect PHY at RC QVIP with EP MAC DUT on PIPE
// interface.
//
// *Input Parameters*
//
// LANES         	        - Indicates number of LANES
// PIPE_BYTES_MAX 	        - Indicates PIPE data bus width
// CONFIG_NUM_OF_FUNCTIONS 	- Indicates number of functions in the device
// INTERFACE_NAME 	        - Indicates PCIe QVIP interface name for which this module
//                                will be instantiated
// PATH_NAME 	                - Indicates the path where the QVIP interface will be
//                                fetched from uvm_config_db.
// 
// *Ports Description*
//
// clk 	      - Clock used by QVIP to.  It should be left unconnected when using
//              internal clock source of QVIP.
// rst_n      -	Reset signal used by QVIP.  This is a active low signal.
// 
// Rest all signals are according to the PIPE specification 4.0
// 
// copied locally from the following source:
// Questa_VIP_10_4_uvm/questa_mvc_src/sv/pcie/modules/pcie_rc_pipe_phy.sv

module pcie_rc_pipe_phy
       #(int LANES = 32,
         int PIPE_BYTES_MAX = 4,
         int CONFIG_NUM_OF_FUNCTIONS = 8,
         string INTERFACE_NAME = "",
         string PATH_NAME = "")
       (
         inout clk,
         inout rst_n,
         input [(LANES*PIPE_BYTES_MAX*8)-1:0] TX_DATA,
         input [(LANES*PIPE_BYTES_MAX)-1:0]   TX_DATAK,
         input [LANES-1:0] TX_ELECIDLE,
         input [LANES-1:0] TX_DATAVALID,
         input [LANES-1:0] TX_COMPLIANCE,
         input [LANES-1:0] RX_POLARITY,
         input [(LANES*18)-1:0] TX_DEEMPH,
         input [LANES-1:0] TX_STARTBLOCK,
         input [(LANES*2)-1:0] TX_SYNCHEADER,
         input [(LANES*3)-1:0] RX_PRESETHINT,
         input [LANES-1:0] RX_EQEVAL,
         input [LANES-1:0] INVALIDREQUEST,
         input [LANES-1:0] RX_STANDBY,
         input [LANES-1:0] TX_DETECTRX_LOOPBACK,
         input [(LANES*2)-1:0] RATE,
         input [(LANES*3)-1:0] TX_MARGIN,
         input [LANES-1:0] TX_SWING,
         input [(LANES*2)-1:0] WIDTH,
         input [(LANES*6)-1:0] LF,
         input [(LANES*6)-1:0] FS,
         input [LANES-1:0] BLOCKALIGNCONTROL,
         input [(LANES*3)-1:0] PCLK_RATE,
         input [(LANES*3)-1:0] POWERDOWN,
         input [3:0] LOCALPRESETINDEX,
         input GETLOCALPRESETCOEFFICIENTS,
         input PCLKREQ_n,
         input RxEIDetectDisable,
         input TxCommonModeDisable,
         output [(LANES*PIPE_BYTES_MAX*8)-1:0] RX_DATA,
         output [(LANES*PIPE_BYTES_MAX)-1:0]   RX_DATAK,
         output [LANES-1:0] PHYSTATUS,
         output [LANES-1:0] RX_VALID,
         output [LANES-1:0] RX_ELECIDLE,
         output [LANES-1:0] RX_STARTBLOCK,
         output [(LANES*2)-1:0] RX_SYNCHEADER,
         output [LANES-1:0] RX_DATAVALID,
         output [(LANES*8)-1:0] LINK_EVAL_FBACK_FIG_MERIT,
         output [(LANES*6)-1:0] LINK_EVAL_FBACK_DIR_CHANGE,
         output [LANES-1:0] RX_STANDBY_STATUS,
         output [(LANES*3)-1:0] RX_STATUS,
         output [(LANES*18)-1:0] LOCAL_TX_PRESET_COEFFS,
         output  [1:0] DATABUSWIDTH,
         output  [5:0] LOCALFS,
         output  [5:0] LOCALLF,
         output        LOCALTXCOEFFICIENTSVALID,
         output PCLKACK_n
       );
  timeunit 1ps;
  timeprecision 1ps;
  import uvm_pkg::*;

  typedef virtual mgc_pcie #(LANES,PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) pcie_if_t;

  bit select_force_value;
  wire i_clk, i_rst_n;
  bit is_internal_clock, is_internal_reset;
 
  // Instance of the Interface
  mgc_pcie #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS)  pcie_rc(i_clk, ,i_rst_n, i_rst_n, , );
 
  generate
    genvar lane, pipe_byte;
    for(lane = 0; lane < LANES; lane++)
    begin
      for(pipe_byte = 0; pipe_byte < PIPE_BYTES_MAX; pipe_byte++)
      begin
        // PHY Inputs
        assign pcie_rc.pipe_txd[1][pipe_byte][lane]   = TX_DATA[(((lane*PIPE_BYTES_MAX)+(pipe_byte+1))*8)-1:((lane*PIPE_BYTES_MAX)+pipe_byte)*8];
        assign pcie_rc.pipe_txk[1][pipe_byte][lane]   = TX_DATAK[pipe_byte+(lane*PIPE_BYTES_MAX)];
        // PHY Outputs
        assign RX_DATA[(((lane*PIPE_BYTES_MAX)+(pipe_byte+1))*8)-1:((lane*PIPE_BYTES_MAX)+pipe_byte)*8] = pcie_rc.pipe_txd[0][pipe_byte][lane];
        assign RX_DATAK[pipe_byte+(lane*PIPE_BYTES_MAX)] = pcie_rc.pipe_txk[0][pipe_byte][lane];

      end

      // PHY Inputs
      assign pcie_rc.pipe_txelecidle[1][lane]       = TX_ELECIDLE[lane];
      assign pcie_rc.pipe_txdata_valid[1][lane]     = TX_DATAVALID[lane];
      assign pcie_rc.pipe_txcompliance[1][lane]     = TX_COMPLIANCE[lane];
      assign pcie_rc.pipe_rxpolarity[1][lane]       = RX_POLARITY[lane];
      assign pcie_rc.pipe_txdeemph[1][lane]         = TX_DEEMPH[lane];
      assign pcie_rc.pipe_txstart_block[1][lane]    = TX_STARTBLOCK[lane];
      assign pcie_rc.pipe_txsync_header[1][lane]    = TX_SYNCHEADER[((lane+1)*2)-1:lane*2];
      assign pcie_rc.pipe_rxpreset_hint[1][lane]    = RX_PRESETHINT[((lane+1)*3)-1:lane*3];
      assign pcie_rc.pipe_rxeq_eval[1][lane]        = RX_EQEVAL[lane];
      assign pcie_rc.pipe_invalid_request[1][lane]  = INVALIDREQUEST[lane];
      assign pcie_rc.pipe_rxstandby[1][lane]        = RX_STANDBY[lane];
      assign pcie_rc.pipe_txdetectrx_lpbk_per_lane[1][lane]      = TX_DETECTRX_LOOPBACK[lane];
      assign pcie_rc.pipe_rate_per_lane[1][lane]                 = RATE[((lane+1)*2)-1:lane*2];
      assign pcie_rc.pipe_txmargin_per_lane[1][lane]             = TX_MARGIN[((lane+1)*3)-1:lane*3];
      assign pcie_rc.pipe_txswing_per_lane[1][lane]              = TX_SWING[lane];
      assign pcie_rc.pipe_width_per_lane[1][lane]                = WIDTH[((lane+1)*2)-1:lane*2];
      assign pcie_rc.pipe_pclk_rate_per_lane[1][lane]            = PCLK_RATE[((lane+1)*3)-1:lane*3];
      assign pcie_rc.pipe_pwrdown_per_lane[1][lane]              = POWERDOWN[((lane+1)*3)-1:lane*3];
      assign pcie_rc.pipe_LF_per_lane[1][lane]                   = LF[((lane+1)*6)-1:lane*6];
      assign pcie_rc.pipe_FS_per_lane[1][lane]                   = FS[((lane+1)*6)-1:lane*6];
      assign pcie_rc.pipe_block_allign_control_per_lane[1][lane] = BLOCKALIGNCONTROL[lane];
      assign pcie_rc.pipe_rx_ei_detect_dis[1]                    = RxEIDetectDisable;
      assign pcie_rc.pipe_tx_commonmode_dis[1]                   = TxCommonModeDisable;

      assign PHYSTATUS[lane] = pcie_rc.pipe_phystatus_per_lane[0][lane];
      assign RX_VALID[lane] = select_force_value? 1'b1 : pcie_rc.pipe_rxvalid[0][lane];
      assign RX_ELECIDLE[lane] = select_force_value? 1'b0 : pcie_rc.pipe_rxelecidle[0][lane];
      assign RX_STARTBLOCK[lane] = pcie_rc.pipe_txstart_block[0][lane];
      assign RX_SYNCHEADER[((lane+1)*2)-1:2*lane] = pcie_rc.pipe_txsync_header[0][lane];
      assign RX_DATAVALID[lane] = pcie_rc.pipe_txdata_valid[0][lane];
      assign LINK_EVAL_FBACK_FIG_MERIT[((lane+1)*8)-1:lane*8] = pcie_rc.pipe_link_evaluation_feedback_figure_merit[0][lane];
      assign LINK_EVAL_FBACK_DIR_CHANGE[((lane+1)*6)-1:lane*6] = pcie_rc.pipe_link_evaluation_feedback_direction_change[0][lane];
      assign RX_STANDBY_STATUS[lane] = pcie_rc.pipe_rxstandby_status[0][lane];
      assign RX_STATUS[((lane+1)*3)-1:lane*3] = pcie_rc.pipe_rxstatus[0][lane];
      assign LOCAL_TX_PRESET_COEFFS[((lane+1)*18)-1:lane*18] = pcie_rc.pipe_local_tx_preset_coefficients[0][lane];
    end
  endgenerate

  assign pcie_rc.pipe_local_preset_index[1]             = LOCALPRESETINDEX;
  assign pcie_rc.pipe_get_local_preset_coefficients[1]  = GETLOCALPRESETCOEFFICIENTS;
  assign pcie_rc.pipe_pclkreq[1]                        = PCLKREQ_n;
  assign pcie_rc.pipe_pwrdown[1]                        = POWERDOWN[2:0];

  // PHY Outputs
  assign DATABUSWIDTH                                     = pcie_rc.pipe_data_bus_width[0];
  assign LOCALFS                                          = pcie_rc.pipe_local_FS[0];
  assign LOCALLF                                          = pcie_rc.pipe_local_LF[0];
  assign LOCALTXCOEFFICIENTSVALID                         = pcie_rc.pipe_local_tx_coefficients_valid[0];
  assign PCLKACK_n                                        = pcie_rc.pipe_pclkack[0];

  assign clk = is_internal_clock? pcie_rc.clk_0 : 1'bz;
  assign i_clk = is_internal_clock? 1'bz : clk;
  assign rst_n = is_internal_reset? pcie_rc.PERST_n_0 : 1'bz;
  assign i_rst_n = is_internal_reset? 1'bz : rst_n;

  string interface_name = (INTERFACE_NAME == "")? $sformatf("%m_pcie_rc") : INTERFACE_NAME;
  string path_name = (PATH_NAME == "")? "uvm_test_top*" : PATH_NAME;

  // Logic to take care of TxDetectRxLoopback 
  initial 
  begin
    @(negedge pcie_rc.pipe_phystatus[0]); 
    repeat (100) @(posedge clk);
    select_force_value = 1;
    wait(TX_DETECTRX_LOOPBACK[0] == 1); 
    wait(TX_DETECTRX_LOOPBACK[0] == 0); 
    select_force_value = 0;
  end

  initial
  begin
    bit temp;
    pcie_rc.config_pclk_rate_per_lane = 1;
    pcie_rc.config_width_per_lane = 1;
    pcie_rc.config_rate_per_lane = 1;
    pcie_rc.config_fs_lf_per_lane = 1;
    pcie_rc.config_txdetectrx_lpbk_per_lane = 1;
    pcie_rc.config_txmargin_txswing_per_lane = 1;
    pcie_rc.config_block_align_control_per_lane = 1;
    pcie_rc.config_phystatus_per_lane = 1;

    // Setting virtual interface into the uvm_config_db
    uvm_config_db #(pcie_if_t)::set(null, path_name, interface_name, pcie_rc);
    #1;
    pcie_rc.pcie_get_clock_source_abstraction_level(0, temp, is_internal_clock);
    pcie_rc.pcie_get_reset_source_abstraction_level(temp, is_internal_reset);
  end

  initial
  begin 
    `ifdef MODULE_DEPR
       `uvm_warning("DUT",{"QVIP Module pcie_rc_pipe_phy is moved to new location "
                        ,"<qvip_install>/questa_mvc_src/sv/pcie/modules/ and therefore "
                        ,"this file will be deprecated in future QVIP releases"},UVM_NONE)
    `endif
  end

endmodule

