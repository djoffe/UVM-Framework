/*****************************************************************************
 *
 * Copyright 2007-2015 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
 * MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
 *
 *****************************************************************************/

//
// Module:- mac_device_dut
//
// This module is a dummy mac device module which is doing nothing, only ports 
// are instatiated for the connection in top.sv.
// QVIP(PHY) acts as host which is connected to this module.
//

// copied from example $QUESTA_MVC_HOME/examples/USB3_0_SS/dut_connection_templates/pipe/mac_device_dut
// and then enhanced to create a functioning mac_device_dut via instantiating and configuring QVIP local to this file.

`include "uvm_macros.svh"

module mac_device_dut#  (
                          int DATA_BUS_WIDTH = 32
                        )
                        (

                          input  clk,
                          input  areset,

                          input [((DATA_BUS_WIDTH) - 1):0]       pipe_rxd,
                          input [((DATA_BUS_WIDTH / 8) - 1):0]   pipe_rxk,
                          input                                  pipe_rxvalid,
                          input                                  pipe_rxelecidle,
                          input                                  pipe_phystatus,
                          input [2:0]                            pipe_rxstatus,
                          input                                  pipe_rxdata_valid,
                          input                                  pipe_rxstart_block,
                          input [3:0]                            pipe_rxsync_header,
                          input                                  pipe_rxstandby_status,
                          input                                  pipe_pclkchange_ok,

                          output logic [((DATA_BUS_WIDTH) - 1):0]      pipe_txd,
                          output logic [((DATA_BUS_WIDTH / 8) - 1):0]  pipe_txk,
                          output logic                                 pipe_txelecidle,
                          output logic                                 pipe_txdetect_lpbk,
                          output logic [1:0]                           pipe_pwrdown,
                          output logic                                 pipe_rxpolarityinv,
                          output logic                                 pipe_rxeqtrng,
                          output logic                                 pipe_txoneszeros,
                          output logic [1:0]                           pipe_phy_mode,
                          output logic                                 pipe_rate,
                          output logic [17:0]                          pipe_txdeemph,
                          output logic [2:0]                           pipe_txmargin,
                          output logic                                 pipe_txswing,
                          output logic                                 pipe_elas_buf_mode,
                          output logic                                 pipe_rxtermination,
                          output logic                                 pipe_txdata_valid,
                          output logic                                 pipe_txstart_block,
                          output logic [3:0]                           pipe_txsync_header,
                          output logic                                 pipe_txblock_align_control,
                          output logic                                 pipe_rxstandby,
                          output logic [1:0]                           pipe_width,
                          output logic [2:0]                           pipe_pclk_rate,
                          output logic                                 pipe_pclkchange_ack
                        );

import uvm_pkg::*;
import mgc_usb_ss_v3_0_pkg::*;
import QUESTA_MVC::*;

typedef usb_ss_device_sequence  #(DATA_BUS_WIDTH) usb_ss_device_sequence_t;

// virtual interface typedefs
typedef virtual mgc_usb_ss#(DATA_BUS_WIDTH) usb_ss_if_t;

  // Instance of an usb_ss_agent.
  usb_ss_agent #(DATA_BUS_WIDTH) usb_ss_device_agent;

  // This is the configuration class for the usb_ss_device_cfg.
  usb_ss_vip_config #(DATA_BUS_WIDTH) usb_ss_device_cfg;

  // Variable: tlm_device_cfg
  // This is TLM Device configuration class. This provides the complete
  // configuration about the endpoints, interfaces etc of the TLM device. This
  // class is used when TLM Device sequence is used.
  usb_ss_device_config tlm_device_cfg;

  usb_ss_mac_device # (
                        .DATA_BUS_WIDTH (DATA_BUS_WIDTH),
                        .IF_NAME        ("USB_SS_PIPE_IF"),
                        .EN_LTSSM_COV   ( 1 )
                      )
         mac_device   (
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

  initial begin
    configure_tlm_device();
    uvm_config_db #( usb_ss_device_config )::set( null , "*" , "ss_device_config" , tlm_device_cfg );

    usb_ss_device_cfg = new("usb_ss_device_cfg");
    usb_ss_device_cfg.m_bfm = mac_device.usb_ss_if;
    configure_usb_ss_device();
    usb_ss_device_agent = new("usb_ss_device_agent");
    usb_ss_device_agent.set_mvc_config(usb_ss_device_cfg);
  end

  initial begin
     usb_ss_device_sequence_t  device_seq;
     device_seq  = usb_ss_device_sequence_t::type_id::create("USB_SS_device_sequence");

     #1;
     initial_ltssm_transition();
     #1;
`ifdef BACKDOOR_ENUMERATION
     backdoor_enumeration();
`endif

     device_seq.start( usb_ss_device_agent.m_sequencer );
  end

  function void configure_usb_ss_device();
     longint clk_half_period;
     int factor;

     factor = (32/DATA_BUS_WIDTH);

     clk_half_period = questa_mvc_sv_convert_to_precision(4000/factor, QUESTA_MVC_TIME_PS );
     usb_ss_device_cfg.agent_cfg.agent_type = USB_SS_DEV;
     usb_ss_device_cfg.agent_cfg.if_type    = USB_SS_PIPE_IF;
     usb_ss_device_cfg.agent_cfg.mac_mode   = USB_SS_MAC_DEVICE;
     usb_ss_device_cfg.agent_cfg.en_sb.dev  = 1'b0;
     usb_ss_device_cfg.agent_cfg.ext_reset  = 1;
     usb_ss_device_cfg.agent_cfg.ext_clock  = 1;
     usb_ss_device_cfg.agent_cfg.tseq_cnt   = 65;
     usb_ss_device_cfg.agent_cfg.en_cvg.phy_link_layer = 1'b0;
     usb_ss_device_cfg.agent_cfg.en_cvg.dev_protocol_layer = 1'b0;
     // following are initial state values when using initial_ltssm_transition()
     usb_ss_device_cfg.agent_cfg.init_link_state  = USB_SS_Disabled;
     usb_ss_device_cfg.agent_cfg.init_link_substate  = USB_SS_Inactive_Quiet;
 
     // enable diagnostic messages to ease bring-up and debug of link training
     usb_ss_device_cfg.m_bfm.set_init_diagnostic_enable(1'b1);

     // All timer values are time based and time unit used is ns
     usb_ss_device_cfg.set_timer_default_val();
     usb_ss_device_cfg.m_bfm.set_usb_ss_10us_value(10000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_TIMER_12ms(12000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_TIMER_10ms(10000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_TIMER_6ms(6000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_TIMER_2ms(2000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_TIMER_360ms(360000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_TIMER_300ms(300000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_LFPS_high_tPeriod(10);
     usb_ss_device_cfg.m_bfm.set_usb_ss_LFPS_low_tPeriod(10);    
     usb_ss_device_cfg.m_bfm.set_usb_ss_g_tNoLFPSResponseTimeout_for_U1_U2(2000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_g_tNoLFPSResponseTimeout_for_U2_or_Loopback(2000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Polling_LFPS_tBurst_min(600);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Polling_LFPS_tBurst_max(1400);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Polling_LFPS_tBurst_gen_apply(600);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Ping_LFPS_tBurst_min(40);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Ping_LFPS_tBurst_max(200);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Ping_LFPS_tBurst_gen_apply(40);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Warm_Reset_LFPS_tBurst_min(80000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Warm_Reset_LFPS_tBurst_max(120000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_Warm_Reset_LFPS_tBurst_gen_apply(80000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U1_Exit_LFPS_tBurst_min(600);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U1_Exit_LFPS_both_in_U1_tBurst_max(2000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U1_Exit_LFPS_one_in_U1_U2_tBurst_max(2000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U1_Exit_LFPS_both_in_U1_tBurst_gen_apply(600);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U1_Exit_LFPS_one_in_U1_U2_tBurst_gen_apply(600);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U2_or_Loopback_Exit_LFPS_tBurst_min(80000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U2_or_Loopback_Exit_LFPS_tBurst_max(2000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U2_or_Loopback_Exit_LFPS_tBurst_gen_apply(80000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U3_WakeUp_LFPS_tBurst_min(80000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U3_WakeUp_LFPS_tBurst_max(10000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_U3_WakeUp_LFPS_tBurst_gen_apply(80000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_tRepeat_LFPS_polling_gen_apply(6000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_tRepeat_LFPS_ping_gen_apply(160000000);
     usb_ss_device_cfg.m_bfm.set_usb_ss_tReset_delay_duration(18000000);

     // SuperSpeedPlus specific variables 
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lfps_logic0_gen(7000);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lfps_logic0_min(6000);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lfps_logic0_max(9000);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lfps_logic1_min(11000);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lfps_logic1_max(14000);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lfps_logic1_gen(12000);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lbpm_gen(2000);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lbpm_min(2000);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_tRepeat_lbpm_max(2400);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_lbpm_logic0_tBurst_min(500);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_lbpm_logic0_tBurst_max(800);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_lbpm_logic0_tBurst_gen(600);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_lbpm_logic1_tBurst_min(1330);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_lbpm_logic1_tBurst_max(1800);
     usb_ss_device_cfg.m_bfm.set_cfg_ssp_lbpm_logic1_tBurst_gen(1500);

     usb_ss_device_cfg.m_bfm.set_loopback_master_port(1'b1);
     usb_ss_device_cfg.m_bfm.set_config_clk_init_value_index1(0, 0);
     usb_ss_device_cfg.m_bfm.set_config_clk_init_value_index1(1, 0);
     usb_ss_device_cfg.m_bfm.set_config_clk_phase_shift_index1 (0, clk_half_period);
     usb_ss_device_cfg.m_bfm.set_config_clk_phase_shift_index1 (1, clk_half_period);
     usb_ss_device_cfg.m_bfm.set_config_clk_1st_time_index1    (0, clk_half_period);
     usb_ss_device_cfg.m_bfm.set_config_clk_1st_time_index1    (1, clk_half_period);
     usb_ss_device_cfg.m_bfm.set_config_clk_2nd_time_index1    (0, clk_half_period);
     usb_ss_device_cfg.m_bfm.set_config_clk_2nd_time_index1    (1, clk_half_period);
     usb_ss_device_cfg.m_delay_header_seq_adv = 80;
  endfunction
  

  function void configure_tlm_device ();
     tlm_device_cfg = new ();
   
     tlm_device_cfg.m_id_vendor        = 16'h0000;
     tlm_device_cfg.m_id_product       = 16'h0000;
     tlm_device_cfg.m_cdDevice         = 16'h0000;
     tlm_device_cfg.m_manufacturer     = 8'h00;
     tlm_device_cfg.m_product          = 8'h01;
     tlm_device_cfg.m_serial_number    = 8'h02;
   
     tlm_device_cfg.set_dev_capab_desc
                           (
                             .dev_capab_type (SUPERSPEED_USB),
                             .ltm_capab      (1'b0),
                             .ls_supprt      (1'b0),
                             .fs_supprt      (1'b0),
                             .hs_supprt      (1'b1),
                             .ss_supprt      (1'b1),
                             .u1_dev_exit_latency (8'h04),
                             .u2_dev_exit_latency (16'h0012)
                           );
   
     tlm_device_cfg.set_dev_desc
                             (
                               .cd_usb                 (16'h0300),
                               .dev_class              (8'h00),
                               .dev_subclass           (8'h00),
                               .endp0_max_pkt_size     (8'h09),
                               .num_cfgs               (1)
                             );
   
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h1),
                               .endp_dir                    (1'b0),
                               .endp_type                   (USB_CONTROL),
                               .max_pkt_size                (16'h0200),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h0),
                               .max_num_streams             (5'h00),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h00),
                               .intf_alt_sett_num           (8'h00),
                               .cfg_num                     (8'h06)
                             );
   
   
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h3),
                               .endp_dir                    (1'b0),
                               .endp_type                   (USB_BULK),
                               .max_pkt_size                (16'h0400),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h4),
                               .max_num_streams             (5'h00),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h00),
                               .intf_alt_sett_num           (8'h00),
                               .cfg_num                     (8'h06)
                             );
   
   
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h3),
                               .endp_dir                    (1'b1),
                               .endp_type                   (USB_BULK),
                               .max_pkt_size                (16'h0400),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h4),
                               .max_num_streams             (5'h00),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h00),
                               .intf_alt_sett_num           (8'h00),
                               .cfg_num                     (8'h06)
                             );
   
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h1),
                               .endp_dir                    (1'b0),
                               .endp_type                   (USB_CONTROL),
                               .max_pkt_size                (16'h0200),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h0),
                               .max_num_streams             (5'h00),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h00),
                               .intf_alt_sett_num           (8'h01),
                               .cfg_num                     (8'h06)
                             );
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h4),
                               .endp_dir                    (1'b0),
                               .endp_type                   (USB_BULK),
                               .max_pkt_size                (16'h0400),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h4),
                               .max_num_streams             (5'h04),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h00),
                               .intf_alt_sett_num           (8'h01),
                               .cfg_num                     (8'h06)
                             );
   
   
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h4),
                               .endp_dir                    (1'b1),
                               .endp_type                   (USB_BULK),
                               .max_pkt_size                (16'h0400),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h4),
                               .max_num_streams             (5'h04),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h00),
                               .intf_alt_sett_num           (8'h01),
                               .cfg_num                     (8'h06)
                             );
   
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h5),
                               .endp_dir                    (1'b0),
                               .endp_type                   (USB_CONTROL),
                               .max_pkt_size                (16'h0200),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h0),
                               .max_num_streams             (5'h00),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h01),
                               .intf_alt_sett_num           (8'h00),
                               .cfg_num                     (8'h06)
                             );
   
   
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h2),
                               .endp_dir                    (1'b1),
                               .endp_type                   (USB_BULK),
                               .max_pkt_size                (16'h0400),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h4),
                               .max_num_streams             (5'h03),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h01),
                               .intf_alt_sett_num           (8'h00),
                               .cfg_num                     (8'h06)
                             );
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h6),
                               .endp_dir                    (1'b0),
                               .endp_type                   (USB_INTERRUPT),
                               .max_pkt_size                (16'h0400),
                               .poll_int                    (8'h01),
                               .max_burst_size              (4'h4),
                               .max_num_streams             (5'h00),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h01),
                               .intf_alt_sett_num           (8'h00),
                               .cfg_num                     (8'h06)
                             );
   
   
     tlm_device_cfg.set_endp_desc
                             (
                               .endp_addr                   (4'h7),
                               .endp_dir                    (1'b0),
                               .endp_type                   (USB_ISOCHRONOUS),
                               .max_pkt_size                (16'h0400),
                               .poll_int                    (8'h00),
                               .max_burst_size              (4'h4),
                               .max_num_streams             (5'h00),
                               .max_pkt_size_serv_int       (16'h0000),
                               .intf_num                    (8'h01),
                               .intf_alt_sett_num           (8'h00),
                               .cfg_num                     (8'h06)
                             );
   
     // Interface association desc for cfg num 6
     tlm_device_cfg.set_intf_assoc_desc
                             (
                               .num_first_intf             (8'h00),
                               .num_intfs                  (8'h06),
                               .fn_class                   (8'h01),
                               .fn_subclass                (8'h00),
                               .fn_prot                    (8'h00),
                               .index_fn                   (8'h02),
                               .cfg_num                    (8'h06)
                             );

     tlm_device_cfg.create_descrptrs();
  endfunction : configure_tlm_device

  
task initial_ltssm_transition();

  fork
    if (usb_ss_device_cfg.m_bfm.get_g_usb3_enable() == 1'b0)
      usb_ss_device_cfg.m_bfm.wait_for_g_usb3_enable();

    if ((usb_ss_device_cfg.m_bfm.get_initial_link_state_value() == USB_SS_Disabled) ||
        (usb_ss_device_cfg.m_bfm.get_initial_link_state_value() == USB_SS_Rx_Detect))
    begin
      repeat(10) usb_ss_device_cfg.wait_for_clock(); // user can specify delay as desired

      fork
        begin
         // To direct downstream link to RxDetect
          usb_ss_device_cfg.m_bfm.set_g_directed_to_Rx_detect_index1(0, 1'b1);
          usb_ss_device_cfg.wait_for_clock();
          usb_ss_device_cfg.m_bfm.set_g_directed_to_Rx_detect_index1(0, 1'b0);

          // usb_ss_device_cfg.wait_for_link_state_index(0, USB_SS_Rx_Detect);

          // To direct downstream link to Polling.LFPS
          usb_ss_device_cfg.m_bfm.set_g_far_end_rx_termination_present_index1(0, 1'b1);
          usb_ss_device_cfg.wait_for_clock();
          usb_ss_device_cfg.m_bfm.set_g_far_end_rx_termination_valid_index1(0, 1'b1);
          usb_ss_device_cfg.wait_for_clock();
          // usb_ss_device_cfg.m_bfm.set_g_far_end_rx_termination_valid_index1(0, 1'b0);

          usb_ss_device_cfg.wait_for_link_substate_index(0, USB_SS_Rx_Detect_Active, 1'b1);
          `uvm_info ("DUT",
                      $psprintf("Downstream Link state : %s, Downstream Link substate = %s",
                                 usb_ss_device_cfg.m_bfm.get_link_state_index1(0),
                                 usb_ss_device_cfg.m_bfm.get_link_substate_index1(0)),
                      UVM_LOW);
          usb_ss_device_cfg.wait_for_link_state_index(0, USB_SS_U0);
        end
        begin
          // To direct upstream link to RxDetect
          usb_ss_device_cfg.m_bfm.set_g_directed_to_Rx_detect_index1(1, 1'b1);
          usb_ss_device_cfg.wait_for_clock();
          usb_ss_device_cfg.m_bfm.set_g_directed_to_Rx_detect_index1(1, 1'b0);

          usb_ss_device_cfg.wait_for_link_state_index(1, USB_SS_Rx_Detect);

          // To direct downstream link to Polling.LFPS
          usb_ss_device_cfg.m_bfm.set_g_far_end_rx_termination_present_index1(1, 1'b1);
          usb_ss_device_cfg.wait_for_clock();
          usb_ss_device_cfg.m_bfm.set_g_far_end_rx_termination_valid_index1(1, 1'b1);
          usb_ss_device_cfg.wait_for_clock();
          usb_ss_device_cfg.m_bfm.set_g_far_end_rx_termination_valid_index1(1, 1'b0);

          usb_ss_device_cfg.wait_for_link_substate_index(1, USB_SS_Rx_Detect_Active, 1'b1);
          `uvm_info ("DUT",
                     $psprintf("Upstream Link state : %s,   Upstream Link substate = %s"  ,
                               usb_ss_device_cfg.m_bfm.get_link_state_index1(1),
                               usb_ss_device_cfg.m_bfm.get_link_substate_index1(1)),
                      UVM_LOW);
          usb_ss_device_cfg.wait_for_link_state_index(1, USB_SS_U0);
        end
      join
    end
  join_none
endtask

endmodule
