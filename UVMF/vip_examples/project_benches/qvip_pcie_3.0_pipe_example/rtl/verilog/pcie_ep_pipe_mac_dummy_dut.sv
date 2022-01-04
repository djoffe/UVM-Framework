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

// copied locally from the following source:
// Questa_VIP_10_4_uvm/examples/pcie/common/pcie_ep_pipe_mac_dummy_dut.sv

module pcie_ep_pipe_mac_dummy_dut
       #(int LANES = 32,
         int PIPE_BYTES_MAX = 4,
         int CONFIG_NUM_OF_FUNCTIONS = 8
        )
       (
         input clk,
         input rst_n,
         output [(LANES*PIPE_BYTES_MAX*8)-1:0] pipe_txdata,
         output [(LANES*PIPE_BYTES_MAX)-1:0]   pipe_txdatak,
         output [LANES-1:0] pipe_txelecidle,
         output [LANES-1:0] pipe_txdatavalid,
         output [LANES-1:0] pipe_txcompliance,
         output [LANES-1:0] pipe_rxpolarity,
         output [(LANES*18)-1:0] pipe_txdeemph,
         output [LANES-1:0] pipe_txstartblock,
         output [(LANES*2)-1:0] pipe_txsyncheader,
         output [(LANES*3)-1:0] pipe_rxpresethint,
         output [LANES-1:0] pipe_rxeqeval,
         output [LANES-1:0] pipe_invalidrequest,
         output [LANES-1:0] pipe_rxstandby,
         output [LANES-1:0] pipe_txdetectrxloopback,
         output [(LANES*2)-1:0] pipe_rate,
         output [(LANES*3)-1:0] pipe_txmargin,
         output [LANES-1:0] pipe_txswing,
         output [(LANES*2)-1:0] pipe_width,
         output [(LANES*6)-1:0] pipe_lf,
         output [(LANES*6)-1:0] pipe_fs,
         output [LANES-1:0] pipe_blockaligncontrol,
         output [(LANES*3)-1:0] pipe_pclkrate,
         output [2:0] pipe_powerdown,
         output [3:0] pipe_localpresetindex,
         output pipe_getlocalpresetcoefficients,
         input [(LANES*PIPE_BYTES_MAX*8)-1:0] pipe_rxdata,
         input [(LANES*PIPE_BYTES_MAX)-1:0]  pipe_rxdatak,
         input [LANES-1:0] pipe_phystatus,
         input [LANES-1:0] pipe_rxvalid,
         input [LANES-1:0] pipe_rxelecidle,
         input [LANES-1:0] pipe_rxstartblock,
         input [(LANES*2)-1:0] pipe_rxsyncheader,
         input [LANES-1:0] pipe_rxdatavalid,
         input [(LANES*8)-1:0] pipe_linkevalfbackfigmerit,
         input [(LANES*6)-1:0] pipe_linkevalfbackdirchange,
         input [LANES-1:0] pipe_rxstandbystatus,
         input [(LANES*3)-1:0] pipe_rxstatus,
         input [(LANES*18)-1:0] pipe_localtxpresetcoeffs,
         input  [1:0] pipe_databuswidth,
         input  [5:0] pipe_localfs,
         input  [5:0] pipe_locallf,
         input        pipe_localtxcoefficientsvalid,
         input PCLKACK_n ,
         output PCLKREQ_n
       );

  import mgc_pcie_v2_0_pkg::*;

  pcie_vip_config #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) ep_cfg = new();

  // Instance of the Interface
  mgc_pcie #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS)  pcie_ep(clk, ,rst_n, rst_n, , );
 
  generate
    genvar lane, pipe_byte;
    for(lane = 0; lane < LANES; lane++)
    begin
      for(pipe_byte = 0; pipe_byte < PIPE_BYTES_MAX; pipe_byte++)
      begin
        // MAC Inputs
        assign pcie_ep.pipe_txd[0][pipe_byte][lane]   = pipe_rxdata[(((lane*PIPE_BYTES_MAX)+(pipe_byte+1))*8)-1:((lane*PIPE_BYTES_MAX)+pipe_byte)*8];
        assign pcie_ep.pipe_txk[0][pipe_byte][lane]   = pipe_rxdatak[pipe_byte+(lane*PIPE_BYTES_MAX)];
        // MAC Outputs
        assign pipe_txdata[(((lane*PIPE_BYTES_MAX)+(pipe_byte+1))*8)-1:((lane*PIPE_BYTES_MAX)+pipe_byte)*8] = pcie_ep.pipe_txd[1][pipe_byte][lane];
        assign pipe_txdatak[pipe_byte+(lane*PIPE_BYTES_MAX)] = pcie_ep.pipe_txk[1][pipe_byte][lane];

      end

      // MAC Inputs
      assign pcie_ep.pipe_phystatus_per_lane[0][lane] = pipe_phystatus[lane];
      assign pcie_ep.pipe_rxvalid[0][lane] = pipe_rxvalid[lane];
      assign pcie_ep.pipe_rxelecidle[0][lane] = pipe_rxelecidle[lane];
      assign pcie_ep.pipe_txstart_block[0][lane] = pipe_rxstartblock[lane];
      assign pcie_ep.pipe_txsync_header[0][lane] = pipe_rxsyncheader[((lane+1)*2)-1:2*lane];
      assign pcie_ep.pipe_txdata_valid[0][lane] = pipe_rxdatavalid[lane];
      assign pcie_ep.pipe_link_evaluation_feedback_figure_merit[0][lane] = pipe_linkevalfbackfigmerit[((lane+1)*8)-1:lane*8];
      assign pcie_ep.pipe_link_evaluation_feedback_direction_change[0][lane] = pipe_linkevalfbackdirchange[((lane+1)*6)-1:lane*6];
      assign pcie_ep.pipe_rxstandby_status[0][lane] = pipe_rxstandbystatus[lane];
      assign pcie_ep.pipe_rxstatus[0][lane] = pipe_rxstatus[((lane+1)*3)-1:lane*3];
      assign pcie_ep.pipe_local_tx_preset_coefficients[0][lane] = pipe_localtxpresetcoeffs[((lane+1)*18)-1:lane*18];

      // MAC Outputs
      assign pipe_txelecidle[lane] = pcie_ep.pipe_txelecidle[1][lane];
      assign pipe_txdatavalid[lane] = pcie_ep.pipe_txdata_valid[1][lane];
      assign pipe_txcompliance[lane] =  pcie_ep.pipe_txcompliance[1][lane];
      assign pipe_rxpolarity[lane] = pcie_ep.pipe_rxpolarity[1][lane];
      assign pipe_txdeemph[lane] = pcie_ep.pipe_txdeemph[1][lane];
      assign pipe_txstartblock[lane] = pcie_ep.pipe_txstart_block[1][lane];
      assign pipe_txsyncheader[((lane+1)*2)-1:lane*2] = pcie_ep.pipe_txsync_header[1][lane];
      assign pipe_rxpresethint[((lane+1)*3)-1:lane*3] = pcie_ep.pipe_rxpreset_hint[1][lane];
      assign pipe_rxeqeval[lane] = pcie_ep.pipe_rxeq_eval[1][lane];
      assign pipe_invalidrequest[lane] = pcie_ep.pipe_invalid_request[1][lane];
      assign pipe_rxstandby[lane] = pcie_ep.pipe_rxstandby[1][lane];
      assign pipe_txdetectrxloopback[lane] = pcie_ep.pipe_txdetectrx_lpbk_per_lane[1][lane];
      assign pipe_rate[((lane+1)*2)-1:lane*2] = pcie_ep.pipe_rate_per_lane[1][lane];
      assign pipe_txmargin[((lane+1)*3)-1:lane*3] = pcie_ep.pipe_txmargin_per_lane[1][lane];
      assign pipe_txswing[lane] = pcie_ep.pipe_txswing_per_lane[1][lane];
      assign pipe_width[lane] = pcie_ep.pipe_width_per_lane[1][lane];
      assign pipe_pclkrate[((lane+1)*3)-1:lane*3] = pcie_ep.pipe_pclk_rate_per_lane[1][lane];
      assign pipe_lf[((lane+1)*6)-1:lane*6] = pcie_ep.pipe_LF_per_lane[1][lane];
      assign pipe_fs[((lane+1)*6)-1:lane*6] = pcie_ep.pipe_FS_per_lane[1][lane];
      assign pipe_blockaligncontrol[lane] = pcie_ep.pipe_block_allign_control_per_lane[1][lane];
    end
  endgenerate

  // MAC Inputs
  assign pcie_ep.pipe_data_bus_width[0] = pipe_databuswidth;
  assign pcie_ep.pipe_local_FS[0] = pipe_localfs;
  assign pcie_ep.pipe_local_LF[0] = pipe_locallf;
  assign pcie_ep.pipe_local_tx_coefficients_valid[0] = pipe_localtxcoefficientsvalid;

  // MAC Outputs
  assign pipe_powerdown = pcie_ep.pipe_pwrdown[1];
  assign pipe_localpresetindex = pcie_ep.pipe_local_preset_index[1];
  assign pipe_getlocalpresetcoefficients = pcie_ep.pipe_get_local_preset_coefficients[1];

  initial
  begin
    pcie_ep.config_pclk_rate_per_lane = 1;
    pcie_ep.config_width_per_lane = 1;
    pcie_ep.config_rate_per_lane = 1;
    pcie_ep.config_fs_lf_per_lane = 1;
    pcie_ep.config_txdetectrx_lpbk_per_lane = 1;
    pcie_ep.config_txmargin_txswing_per_lane = 1;
    pcie_ep.config_block_align_control_per_lane = 1;
    pcie_ep.config_phystatus_per_lane = 1;

    ep_cfg.m_other_end_cfg = new();
    ep_cfg.m_device_type = PCIE_NEP;
    ep_cfg.m_other_end_cfg.m_device_type = PCIE_RC;
    ep_cfg.m_bfm = pcie_ep;
    ep_cfg.m_other_end_cfg.m_bfm = pcie_ep;
    ep_cfg.m_bfm.set_config_pcie_if_type(PCIE_PIPE);
    ep_cfg.m_bfm.set_config_pipe_mac_mode_index1(0, PCIE_MAC_SLAVE);
    ep_cfg.m_bfm.set_config_pipe_mac_mode_index1(1, PCIE_MAC_MASTER);
    ep_cfg.m_bfm.set_config_pcie_version({PCIE_3_0, PCIE_3_0});
    pcie_standard_config #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS)::add_to_config(.config_handle(ep_cfg), .no_listener(1), .no_scoreboard(1), .mac(1), .internal_reset_clock(), .monitor_mode());
    ep_cfg.initialize_config_space();
  end

endmodule

