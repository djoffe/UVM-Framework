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
// Unit            : qvip_usb3_pipe_example_configuration
// File            : qvip_usb3_pipe_example_configuration.svh
//----------------------------------------------------------------------
// Created by      : Vijay Gill
// Creation Date   : 2014/11/05
//----------------------------------------------------------------------

//
// DESCRIPTION: This configuration class contains a configuration
//   object for each agent in the environment.  An agents configuration
//   configures the agent according to how it will be used within the
//   simulation.  This configuration also has a function, 
//   initialize, which tells each agent configuration the
//   string name of the virtual interface it will use and the string
//   path of where the environment resides in the simulation.  This
//   allows for the agent configurations to get their own virtual
//   interfaces and make themselves available to their own agent.
//
//----------------------------------------------------------------------
//
class qvip_usb3_pipe_example_configuration #(int DATA_BUS_WIDTH = 32) extends uvmf_environment_configuration_base;

  `uvm_object_utils( qvip_usb3_pipe_example_configuration );

  // Variable:- usb_ss_host_cfg
  //
  // This is the configuration class for the usb_ss_host_cfg.
  typedef usb_ss_vip_config #(DATA_BUS_WIDTH) usb_ss_vip_config_t;
  usb_ss_vip_config_t qvip_usb_host_config;

  typedef virtual mgc_usb_ss#(DATA_BUS_WIDTH) usb_ss_if_t;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );

    qvip_usb_host_config     = usb_ss_vip_config_t::type_id::create("qvip_usb_host_config"); 

  endfunction

// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
      "qvip_usb_host_config:", qvip_usb_host_config.convert2string()
    };

  endfunction
// ****************************************************************************
// FUNCTION: initialize();
// This function configures each interface agents configuration class.  The 
// sim level determines the active/passive state of the agent.  The environment_path
// identifies the hierarchy down to and including the instantiation name of the
// environment for this configuration class.  Each instance of the environment 
// has its own configuration class.  The string interface names are used by 
// the agent configurations to identify the virtual interface handle to pull from
// the uvqvip_usb_host_config_db.  
//
  function void initialize(uvmf_sim_level_t sim_level, 
                                      string environment_path,
                                      string interface_names[],
                                      uvm_reg_block register_model = null,
                                      uvmf_active_passive_t interface_activity[] = null
                                     );
/*
    if ( sim_level == BLOCK ) begin
      qvip_usb_host_config.initialize( ACTIVE, {environment_path,".qvip_usb_host_agent"}, interface_names[0]); 

    end else begin
      `uvm_fatal("CFG", "Unknown sim_level in qvip_usb3_pipe_example_configuration::initialize()")
    end
*/
     if(!uvm_config_db #( usb_ss_if_t )::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], qvip_usb_host_config.m_bfm ))
       `uvm_error("CFG",
               "uvm_config_db #( usb_ss_if_t )::get cannot find resource qvip_usb_host_config.m_bfm" ) 

     do_usb_ss_host_config();
  endfunction

function void do_usb_ss_host_config();
  longint clk_half_period;

  // This comman factor is defined to take care of timers if in case bus width changes.
  int factor = (32/DATA_BUS_WIDTH);

  clk_half_period = questa_mvc_sv_convert_to_precision(4000/factor, QUESTA_MVC_TIME_PS );

  qvip_usb_host_config.agent_cfg.agent_type = USB_SS_HOST;
  qvip_usb_host_config.agent_cfg.if_type    = USB_SS_PIPE_IF;
  qvip_usb_host_config.agent_cfg.mac_mode   = USB_SS_MAC_DEVICE;
  qvip_usb_host_config.agent_cfg.ext_clock  = 1'b1;
  qvip_usb_host_config.agent_cfg.ext_reset  = 1'b1;
  qvip_usb_host_config.agent_cfg.tseq_cnt   = 65;
  qvip_usb_host_config.agent_cfg.en_cvg.phy_link_layer = 1'b0;
  qvip_usb_host_config.agent_cfg.en_cvg.dev_protocol_layer = 1'b0;
  qvip_usb_host_config.agent_cfg.init_link_state  = USB_SS_Disabled;
  qvip_usb_host_config.agent_cfg.init_link_substate  = USB_SS_Inactive_Quiet;

  // Enable diagnostic messages to ease bring-up and debug of link training
  qvip_usb_host_config.m_bfm.set_init_diagnostic_enable(1'b1);

  // All timer values are time based and time unit used is ns
  qvip_usb_host_config.set_timer_default_val();
  qvip_usb_host_config.m_bfm.set_usb_ss_10us_value(10000);
  qvip_usb_host_config.m_bfm.set_usb_ss_TIMER_12ms(12000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_TIMER_10ms(10000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_TIMER_6ms(6000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_TIMER_2ms(2000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_TIMER_360ms(360000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_TIMER_300ms(300000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_LFPS_high_tPeriod(10);
  qvip_usb_host_config.m_bfm.set_usb_ss_LFPS_low_tPeriod(10);
  qvip_usb_host_config.m_bfm.set_usb_ss_g_tNoLFPSResponseTimeout_for_U1_U2(2000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_g_tNoLFPSResponseTimeout_for_U2_or_Loopback(2000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_Polling_LFPS_tBurst_min(600);  
  qvip_usb_host_config.m_bfm.set_usb_ss_Polling_LFPS_tBurst_max(1400);
  qvip_usb_host_config.m_bfm.set_usb_ss_Polling_LFPS_tBurst_gen_apply(600);
  qvip_usb_host_config.m_bfm.set_usb_ss_Ping_LFPS_tBurst_min(40);
  qvip_usb_host_config.m_bfm.set_usb_ss_Ping_LFPS_tBurst_max(200);
  qvip_usb_host_config.m_bfm.set_usb_ss_Ping_LFPS_tBurst_gen_apply(40);
  qvip_usb_host_config.m_bfm.set_usb_ss_Warm_Reset_LFPS_tBurst_min(80000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_Warm_Reset_LFPS_tBurst_max(120000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_Warm_Reset_LFPS_tBurst_gen_apply(80000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_U1_Exit_LFPS_tBurst_min(600);
  qvip_usb_host_config.m_bfm.set_usb_ss_U1_Exit_LFPS_both_in_U1_tBurst_max(2000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_U1_Exit_LFPS_one_in_U1_U2_tBurst_max(2000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_U1_Exit_LFPS_both_in_U1_tBurst_gen_apply(600);
  qvip_usb_host_config.m_bfm.set_usb_ss_U1_Exit_LFPS_one_in_U1_U2_tBurst_gen_apply(600);
  qvip_usb_host_config.m_bfm.set_usb_ss_U2_or_Loopback_Exit_LFPS_tBurst_min(80000);
  qvip_usb_host_config.m_bfm.set_usb_ss_U2_or_Loopback_Exit_LFPS_tBurst_max(2000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_U2_or_Loopback_Exit_LFPS_tBurst_gen_apply(80000);
  qvip_usb_host_config.m_bfm.set_usb_ss_U3_WakeUp_LFPS_tBurst_min(80000);
  qvip_usb_host_config.m_bfm.set_usb_ss_U3_WakeUp_LFPS_tBurst_max(10000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_U3_WakeUp_LFPS_tBurst_gen_apply(80000);
  qvip_usb_host_config.m_bfm.set_usb_ss_tRepeat_LFPS_polling_gen_apply(6000);
  qvip_usb_host_config.m_bfm.set_usb_ss_tRepeat_LFPS_ping_gen_apply(160000000);
  qvip_usb_host_config.m_bfm.set_usb_ss_tReset_delay_duration(18000000);

  // SuperSpeedPlus(Gen2) specific variables
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lfps_logic0_gen(7000);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lfps_logic0_min(6000);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lfps_logic0_max(9000);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lfps_logic1_min(11000);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lfps_logic1_max(14000);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lfps_logic1_gen(12000);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lbpm_gen(2000);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lbpm_min(2000);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_tRepeat_lbpm_max(2400);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_lbpm_logic0_tBurst_min(500);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_lbpm_logic0_tBurst_max(800);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_lbpm_logic0_tBurst_gen(600);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_lbpm_logic1_tBurst_min(1330);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_lbpm_logic1_tBurst_max(1800);
  qvip_usb_host_config.m_bfm.set_cfg_ssp_lbpm_logic1_tBurst_gen(1500);

  qvip_usb_host_config.m_bfm.set_loopback_master_port(1'b1);
  qvip_usb_host_config.m_bfm.set_config_clk_init_value_index1(0, 0);
  qvip_usb_host_config.m_bfm.set_config_clk_init_value_index1(1, 0);
  qvip_usb_host_config.m_bfm.set_config_clk_phase_shift_index1 (0, clk_half_period);
  qvip_usb_host_config.m_bfm.set_config_clk_phase_shift_index1 (1, clk_half_period);
  qvip_usb_host_config.m_bfm.set_config_clk_1st_time_index1    (0, clk_half_period);
  qvip_usb_host_config.m_bfm.set_config_clk_1st_time_index1    (1, clk_half_period);
  qvip_usb_host_config.m_bfm.set_config_clk_2nd_time_index1    (0, clk_half_period);
  qvip_usb_host_config.m_bfm.set_config_clk_2nd_time_index1    (1, clk_half_period);

endfunction

endclass

