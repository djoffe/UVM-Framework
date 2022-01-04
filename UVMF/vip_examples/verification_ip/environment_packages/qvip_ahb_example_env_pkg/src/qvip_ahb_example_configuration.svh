//----------------------------------------------------------------------
//   Copyright 2015 Mentor Graphics Corporation
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
// Unit            : qvip_ahb_example_configuration
// File            : qvip_ahb_example_configuration.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2015/05/05
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
class qvip_ahb_example_configuration #(int AHB_NUM_MASTERS = 2,
                                       int AHB_NUM_MASTER_BITS = 2,
                                       int AHB_NUM_SLAVES = 2,
                                       int AHB_ADDRESS_WIDTH = 32,
                                       int AHB_WDATA_WIDTH = 32,
                                       int AHB_RDATA_WIDTH = 32 ) extends uvmf_environment_configuration_base;

  `uvm_object_param_utils( qvip_ahb_example_configuration #(AHB_NUM_MASTERS,
                                                            AHB_NUM_MASTER_BITS,
                                                            AHB_NUM_SLAVES,
                                                            AHB_ADDRESS_WIDTH,
                                                            AHB_WDATA_WIDTH,
                                                            AHB_RDATA_WIDTH ));


  // This typedef is used to define the interface type retrieved from the uvm_config_db.
  typedef virtual mgc_ahb #(AHB_NUM_MASTERS,
                            AHB_NUM_MASTER_BITS,
                            AHB_NUM_SLAVES,
                            AHB_ADDRESS_WIDTH,
                            AHB_WDATA_WIDTH,
                            AHB_RDATA_WIDTH) ahb_if_t;

  typedef ahb_master_burst_transfer #(AHB_NUM_MASTERS,
                                      AHB_NUM_MASTER_BITS,
                                      AHB_NUM_SLAVES,
                                      AHB_ADDRESS_WIDTH,
                                      AHB_WDATA_WIDTH,
                                      AHB_RDATA_WIDTH
                                     ) burst_transfer_t;

  // This class, ahb_vip_config, defines a single configuration object that is
  // used to configure the AHB (mgc_ahb) interface. All aspects of the
  // AHB interface can be configured, including abstraction-level, clocks, and reset.
  // Each member has a default value that is applied to the interface if the
  // member is not set.
  typedef ahb_vip_config #(AHB_NUM_MASTERS,
                           AHB_NUM_MASTER_BITS,
                           AHB_NUM_SLAVES,
                           AHB_ADDRESS_WIDTH,
                           AHB_WDATA_WIDTH,
                           AHB_RDATA_WIDTH) ahb_vip_config_t;

  ahb_vip_config_t ahb_master_config, ahb_slave_config, ahb_arbiter_config, ahb_monitor_config;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );

    ahb_master_config     = ahb_vip_config_t::type_id::create("ahb_master_config"); 
    ahb_slave_config      = ahb_vip_config_t::type_id::create("ahb_slave_config"); 
    ahb_arbiter_config    = ahb_vip_config_t::type_id::create("ahb_arbiter_config"); 
    ahb_monitor_config    = ahb_vip_config_t::type_id::create("ahb_monitor_config"); 

  endfunction

// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
      "ahb_master_config:", ahb_master_config.convert2string()
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
// the qvip_ahb_config_db.  
//
  function void initialize(uvmf_sim_level_t sim_level, 
                                      string environment_path,
                                      string interface_names[],
                                      uvm_reg_block register_model = null,
                                      uvmf_active_passive_t interface_activity[] = null
                                     );

     if(!uvm_config_db #( ahb_if_t )::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], ahb_master_config.m_bfm ))
       `uvm_error("CFG", "uvm_config_db #( ahb_if_t )::get cannot find resource ahb_master_config.m_bfm" ) 
     if(!uvm_config_db #( ahb_if_t )::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], ahb_slave_config.m_bfm ))
       `uvm_error("CFG", "uvm_config_db #( ahb_if_t )::get cannot find resource ahb_slave_config.m_bfm" ) 
     if(!uvm_config_db #( ahb_if_t )::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], ahb_arbiter_config.m_bfm ))
       `uvm_error("CFG", "uvm_config_db #( ahb_if_t )::get cannot find resource ahb_arbiter_config.m_bfm" ) 
     // Note: as the monitor has its own (unique/separate) bfm, it uses index [1] below to pull its interface_name from config_db
     if(!uvm_config_db #( ahb_if_t )::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[1], ahb_monitor_config.m_bfm ))
       `uvm_error("CFG", "uvm_config_db #( ahb_if_t )::get cannot find resource ahb_monitor_config.m_bfm" ) 

     do_ahb_master_config();
     do_ahb_slave_config();
     do_ahb_arbiter_config();
     do_ahb_monitor_config();

     // Place the configured object in global configuration space.
     // This propagates the configuration items down through the
     // hierarchy (because of the "*")
     uvm_config_db #( uvm_object )::set( null , {environment_path,".ahb_master_agent*"} ,  mvc_config_base_id , ahb_master_config );
     uvm_config_db #( uvm_object )::set( null , {environment_path,".ahb_slave_agent*"} ,   mvc_config_base_id , ahb_slave_config );
     uvm_config_db #( uvm_object )::set( null , {environment_path,".ahb_arbiter_agent*"} , mvc_config_base_id , ahb_arbiter_config );
     uvm_config_db #( uvm_object )::set( null , {environment_path,".ahb_monitor_agent*"} , mvc_config_base_id , ahb_monitor_config );

  endfunction

  function void do_ahb_master_config();
    ahb_if_t bfm = ahb_master_config.m_bfm;
  
    ahb_master_config.agent_cfg.agent_type = AHB_MASTER;
    ahb_master_config.agent_cfg.index = 1;
    ahb_master_config.agent_cfg.en_sb = 0;
    ahb_master_config.agent_cfg.ext_decoder = 1;
    // optional listeners and loggers
    // ahb_master_config.agent_cfg.en_txn_ltnr = 1;
    // ahb_master_config.agent_cfg.en_logger.txn_log = 1;
    // ahb_master_config.agent_cfg.en_logger.txn_log_name = "master_txn.log";
    // ahb_master_config.agent_cfg.en_logger.beat_log = 1;
    // ahb_master_config.agent_cfg.en_logger.beat_log_name = "master_beat.log";
  
    // as the master, slave and arbiter all reference the same bfm, only need to specify the address ranges once.
    bfm.set_config_slave_start_address_range_index1(0, S0_START_ADDRESS);
    bfm.set_config_slave_end_address_range_index1(0, S0_END_ADDRESS);
    bfm.set_config_slave_start_address_range_index1(1, S1_START_ADDRESS);
    bfm.set_config_slave_end_address_range_index1(1, S1_END_ADDRESS);
    // pick one of the masters to be the default master
    bfm.set_config_default_master(0);
  endfunction
  
  function void do_ahb_slave_config();
    ahb_slave_config.agent_cfg.agent_type = AHB_SLAVE;
    ahb_slave_config.agent_cfg.index = 1;
    ahb_slave_config.agent_cfg.en_sb = 0;
    ahb_slave_config.agent_cfg.ext_decoder = 1;
  endfunction
  
  function void do_ahb_arbiter_config();
    ahb_arbiter_config.agent_cfg.agent_type = AHB_ARBITER;
    ahb_arbiter_config.agent_cfg.en_sb = 0;
    ahb_arbiter_config.agent_cfg.ext_decoder = 1;
  endfunction
  
  function void do_ahb_monitor_config();
    ahb_if_t bfm = ahb_monitor_config.m_bfm;
  
    // specify is_active as 0 to indicate passive mode and thus agent will contain only a monitor, no driver nor sequencer.
    // specify agent_type as AHB_MASTER to enable it to monitor (txn listener and logger output) both ahb txn's and beats.
    // specify index as 0 indicating should monitor activity on master 0, the RTL DUT master.
    ahb_monitor_config.agent_cfg.is_active = 0;
    ahb_monitor_config.agent_cfg.agent_type = AHB_MASTER;
    ahb_monitor_config.agent_cfg.index = 0;
    ahb_monitor_config.agent_cfg.en_sb = 0;
    // optional listeners and loggers
    ahb_monitor_config.agent_cfg.en_txn_ltnr = 1;
    ahb_monitor_config.agent_cfg.en_logger.txn_log = 1;
    ahb_monitor_config.agent_cfg.en_logger.txn_log_name = "monitor_txn.log";
    ahb_monitor_config.agent_cfg.en_logger.beat_log = 1;
    ahb_monitor_config.agent_cfg.en_logger.beat_log_name = "monitor_beat.log";
  
    // as the monitor is a separate/unique bfm from above, specify the address ranges here as well.
    bfm.set_config_slave_start_address_range_index1(0, S0_START_ADDRESS);
    bfm.set_config_slave_end_address_range_index1(0, S0_END_ADDRESS);
    bfm.set_config_slave_start_address_range_index1(1, S1_START_ADDRESS);
    bfm.set_config_slave_end_address_range_index1(1, S1_END_ADDRESS);
  endfunction

endclass

