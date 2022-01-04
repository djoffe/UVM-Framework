//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2017 Nov 02
// Created with uvmf_gen version 3.6g
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric Environment 
// Unit            : axi4_2x2_fabric Environment
// File            : axi4_2x2_fabric_environment.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//----------------------------------------------------------------------
//



class axi4_2x2_fabric_environment 
      #(
      int AXI4_ADDRESS_WIDTH = 32,                                
      int AXI4_RDATA_WIDTH = 32,                                
      int AXI4_WDATA_WIDTH = 32,                                
      int AXI4_MASTER_ID_WIDTH = 4,                                
      int AXI4_SLAVE_ID_WIDTH = 5,                                
      int AXI4_USER_WIDTH = 4,                                
      int AXI4_REGION_MAP_SIZE = 16                                
      )
extends uvmf_environment_base #(.CONFIG_T( axi4_2x2_fabric_env_configuration
                              #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )
                             ));

  `uvm_component_param_utils( axi4_2x2_fabric_environment #(
                              AXI4_ADDRESS_WIDTH,
                              AXI4_RDATA_WIDTH,
                              AXI4_WDATA_WIDTH,
                              AXI4_MASTER_ID_WIDTH,
                              AXI4_SLAVE_ID_WIDTH,
                              AXI4_USER_WIDTH,
                              AXI4_REGION_MAP_SIZE
                            ))


  axi4_2x2_fabric_qvip_environment  qvip_env;


  uvm_analysis_port #( mvc_sequence_item_base ) qvip_env_mgc_axi4_m0_ap [string];
  uvm_analysis_port #( mvc_sequence_item_base ) qvip_env_mgc_axi4_m1_ap [string];
  uvm_analysis_port #( mvc_sequence_item_base ) qvip_env_mgc_axi4_s0_ap [string];
  uvm_analysis_port #( mvc_sequence_item_base ) qvip_env_mgc_axi4_s1_ap [string];


  typedef axi4_master_predictor  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  axi4_m0_pred_t;
  axi4_m0_pred_t axi4_m0_pred;
  typedef axi4_master_predictor  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  axi4_m1_pred_t;
  axi4_m1_pred_t axi4_m1_pred;
  typedef axi4_slave_predictor  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  axi4_slave_pred_t;
  axi4_slave_pred_t axi4_slave_pred;
  typedef axi4_master_rw_adapter  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             // .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             // .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  axi4_m0_rw_pred_t;
  axi4_m0_rw_pred_t axi4_m0_rw_pred;
  typedef axi4_master_rw_adapter  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             // .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             // .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  axi4_m1_rw_pred_t;
  axi4_m1_rw_pred_t axi4_m1_rw_pred;
  typedef axi4_slave_rw_adapter  #(
                             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
                             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
                             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
                             // .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
                             // .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
                             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
                             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
                             )  axi4_slave_rw_pred_t;
  axi4_slave_rw_pred_t axi4_slave_rw_pred;

  typedef uvmf_in_order_race_scoreboard #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)))  axi4_m0_sb_t;
  axi4_m0_sb_t axi4_m0_sb;
  typedef uvmf_in_order_race_scoreboard #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)))  axi4_m1_sb_t;
  axi4_m1_sb_t axi4_m1_sb;
  typedef uvmf_in_order_race_scoreboard #(rw_txn)  axi4_m0_rw_sb_t;
  axi4_m0_rw_sb_t axi4_m0_rw_sb;
  typedef uvmf_in_order_race_scoreboard #(rw_txn)  axi4_m1_rw_sb_t;
  axi4_m1_rw_sb_t axi4_m1_rw_sb;



// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// FUNCTION: build_phase()
// This function builds all components within this environment.
//
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    qvip_env = axi4_2x2_fabric_qvip_environment::type_id::create("qvip_env",this);
    qvip_env.set_config(configuration.qvip_env_config);
    axi4_m0_pred = axi4_m0_pred_t::type_id::create("axi4_m0_pred",this);
    axi4_m0_pred.configuration = configuration;
    axi4_m1_pred = axi4_m1_pred_t::type_id::create("axi4_m1_pred",this);
    axi4_m1_pred.configuration = configuration;
    axi4_slave_pred = axi4_slave_pred_t::type_id::create("axi4_slave_pred",this);
    axi4_slave_pred.configuration = configuration;
    axi4_m0_rw_pred = axi4_m0_rw_pred_t::type_id::create("axi4_m0_rw_pred",this);
    // axi4_m0_rw_pred.configuration = configuration;
    axi4_m1_rw_pred = axi4_m1_rw_pred_t::type_id::create("axi4_m1_rw_pred",this);
    // axi4_m1_rw_pred.configuration = configuration;
    axi4_slave_rw_pred = axi4_slave_rw_pred_t::type_id::create("axi4_slave_rw_pred",this);
    // axi4_slave_rw_pred.configuration = configuration;
    axi4_m0_sb = axi4_m0_sb_t::type_id::create("axi4_m0_sb",this);
    axi4_m1_sb = axi4_m1_sb_t::type_id::create("axi4_m1_sb",this);
    axi4_m0_rw_sb = axi4_m0_rw_sb_t::type_id::create("axi4_m0_rw_sb",this);
    axi4_m1_rw_sb = axi4_m1_rw_sb_t::type_id::create("axi4_m1_rw_sb",this);


  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    axi4_m0_pred.axi4_ap.connect(axi4_m0_sb.expected_analysis_export);
    axi4_m1_pred.axi4_ap.connect(axi4_m1_sb.expected_analysis_export);
    axi4_slave_pred.axi4_m0_ap.connect(axi4_m0_sb.actual_analysis_export);
    axi4_slave_pred.axi4_m1_ap.connect(axi4_m1_sb.actual_analysis_export);
    axi4_m0_rw_pred.port_rw.connect(axi4_m0_rw_sb.expected_analysis_export);
    axi4_m1_rw_pred.port_rw.connect(axi4_m1_rw_sb.expected_analysis_export);
    axi4_slave_rw_pred.port_rw_m0.connect(axi4_m0_rw_sb.actual_analysis_export);
    axi4_slave_rw_pred.port_rw_m1.connect(axi4_m1_rw_sb.actual_analysis_export);
    qvip_env_mgc_axi4_m0_ap = qvip_env.mgc_axi4_m0.ap; 
    qvip_env_mgc_axi4_m1_ap = qvip_env.mgc_axi4_m1.ap; 
    qvip_env_mgc_axi4_s0_ap = qvip_env.mgc_axi4_s0.ap; 
    qvip_env_mgc_axi4_s1_ap = qvip_env.mgc_axi4_s1.ap; 
    qvip_env_mgc_axi4_m0_ap["trans_ap"].connect(axi4_m0_pred.axi4_master_ae);
    qvip_env_mgc_axi4_m1_ap["trans_ap"].connect(axi4_m1_pred.axi4_master_ae);
    qvip_env_mgc_axi4_s0_ap["trans_ap"].connect(axi4_slave_pred.axi4_slave_ae);
    qvip_env_mgc_axi4_s1_ap["trans_ap"].connect(axi4_slave_pred.axi4_slave_ae);
    qvip_env_mgc_axi4_m0_ap["trans_ap"].connect(axi4_m0_rw_pred.analysis_export);
    qvip_env_mgc_axi4_m1_ap["trans_ap"].connect(axi4_m1_rw_pred.analysis_export);
    qvip_env_mgc_axi4_s0_ap["trans_ap"].connect(axi4_slave_rw_pred.analysis_export);
    qvip_env_mgc_axi4_s1_ap["trans_ap"].connect(axi4_slave_rw_pred.analysis_export);


  endfunction

endclass

