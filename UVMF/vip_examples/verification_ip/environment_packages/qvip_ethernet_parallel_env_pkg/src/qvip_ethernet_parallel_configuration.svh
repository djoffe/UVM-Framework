//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : vgill
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_parallel Environment 
// Unit            : Environment configuration
// File            : ethernet_qvip_config.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: THis is the configuration for the qvip_ethernet_parallel environment.
//  it contains configuration classes for each agent.  It also contains
//  environment level configuration variables.
//
//----------------------------------------------------------------------
//
class qvip_ethernet_parallel_configuration extends uvmf_environment_configuration_base;

  `uvm_object_utils( qvip_ethernet_parallel_configuration );

    ethernet_vip_config ethernet_qvip_config;
    typedef virtual mgc_ethernet ethernet_if_t;

    string ethernet_qvip_interface_name;

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
// This function constructs the configuration object for each agent in the environment.
//
  function new( string name = "" );
    super.new( name );

    ethernet_qvip_config = ethernet_vip_config::type_id::create("ethernet_qvip_config");
  endfunction

// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for
// logfile reporting. This function concatenates the convert2string result for
// each agent configuration in this configuration class.
//
  virtual function string convert2string();
    return {
    ethernet_qvip_config.convert2string    };

  endfunction
// ****************************************************************************
// FUNCTION: initialize();
// This function configures each interface agents configuration class.  The 
// sim level determines the active/passive state of the agent.  The environment_path
// identifies the hierarchy down to and including the instantiation name of the
// environment for this configuration class.  Each instance of the environment 
// has its own configuration class.  The string interface names are used by 
// the agent configurations to identify the virtual interface handle to pull from
// the uvm_config_db.  
//
  function void initialize(uvmf_sim_level_t sim_level, 
                                      string environment_path,
                                      string interface_names[],
                                      uvm_reg_block register_model = null,
                                      uvmf_active_passive_t interface_activity[] = null
                                     );
    // This is so the env can access this name through this config object to place the agents
    // sequencer into the config_db for the sequence to retrieve.
    this.ethernet_qvip_interface_name = interface_names[0];

    if ( sim_level == BLOCK ) begin
       if(!uvm_config_db #( ethernet_if_t )::get( null, "UVMF_VIRTUAL_INTERFACES", interface_names[0], ethernet_qvip_config.m_bfm ))
       `uvm_error("CFG",
               "uvm_config_db #( ethernet_if_t )::get cannot find resource ethernet_qvip_config.m_bfm" )
//     ethernet_qvip_config.initialize( ACTIVE, {environment_path,".qvip_ethernet_agent_t_agent"}, interface_names[0]);
    end else begin
      `uvm_fatal("CFG", "Unknown sim_level in ethernet_qvip_config::initialize()")
    end

    do_ethernet_qvip_config();

  endfunction

  function void do_ethernet_qvip_config();  

  // This configures the QVIP's Tx Agent for the following settings
  // Active                 n 1
  // Interface Type         : ETHERNET_100G_RS_FEC_SER
  // MDIO Type              : ETHERNET_MDIO_DISABLED
  // Clock                  : Internal
  // Reset                  : Internal
  // Coverage               : Tx and Rx coverage disabled
  // Listener               : Enabled for Data and Control Frames

  // bfm_type bfm = ethernet_qvip_config.tx_cfg.m_bfm;
  ethernet_if_t bfm = ethernet_qvip_config.m_bfm;

  ethernet_qvip_config.agent_cfg.is_active               = 1;
  ethernet_qvip_config.agent_cfg.if_type                 = ETHERNET_100G_RS_FEC_PAR;
  ethernet_qvip_config.agent_cfg.mdio_type               = ETHERNET_MDIO_DISABLED;
  ethernet_qvip_config.agent_cfg.ext_clock               = 0;
  ethernet_qvip_config.agent_cfg.ext_reset               = 0;
  ethernet_qvip_config.agent_cfg.en_cvg.tx               = 6'h00;
  ethernet_qvip_config.agent_cfg.en_cvg.rx               = 6'h00;
  ethernet_qvip_config.agent_cfg.en_txn_ltnr.data_frame  = 1;
  ethernet_qvip_config.agent_cfg.en_txn_ltnr.cntrl_frame = 1;

  // Specific configurations setting directly in BFM
  bfm.config_mac_pause_transmission = 0;             // Disabling the Pause Feature
  bfm.config_rs_fec_amp_counter_4095[0] = 50;
  bfm.config_rs_fec_amp_counter_4095[1] = 50;

  endfunction

endclass

