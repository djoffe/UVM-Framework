//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2017 Nov 02
// Created with uvmf_gen version 3.6g
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_slave_predictor 
// Unit            : axi4_slave_predictor 
// File            : axi4_slave_predictor.svh
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
//
// DESCRIPTION: This analysis component contains analysis_exports for receiving
//   data and analysis_ports for sending data.
// 
//   This analysis component has the following analysis_exports that receive the 
//   listed transaction type.
//   
//   axi4_slave_ae receives transactions of type  mvc_sequence_item_base  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  axi4_m1_ap broadcasts transactions of type axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) 
//  axi4_m0_ap broadcasts transactions of type axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) 
//

class axi4_slave_predictor 
      #(
      int AXI4_ADDRESS_WIDTH = 32,
      int AXI4_RDATA_WIDTH = 32,
      int AXI4_WDATA_WIDTH = 32,
      int AXI4_MASTER_ID_WIDTH = 4,
      int AXI4_SLAVE_ID_WIDTH = 5,
      int AXI4_USER_WIDTH = 4,
      int AXI4_REGION_MAP_SIZE = 16      )
extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( axi4_slave_predictor #(
                              AXI4_ADDRESS_WIDTH,
                              AXI4_RDATA_WIDTH,
                              AXI4_WDATA_WIDTH,
                              AXI4_MASTER_ID_WIDTH,
                              AXI4_SLAVE_ID_WIDTH,
                              AXI4_USER_WIDTH,
                              AXI4_REGION_MAP_SIZE
                            ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  axi4_2x2_fabric_env_configuration   #(
             .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),                                
             .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),                                
             .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),                                
             .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),                                
             .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),                                
             .AXI4_USER_WIDTH(AXI4_USER_WIDTH),                                
             .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)                                
             )  configuration;

  // Instantiate the analysis exports
  uvm_analysis_imp_axi4_slave_ae #(mvc_sequence_item_base, axi4_slave_predictor  #(
                              .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                              .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                              .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                              .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),
                              .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),
                              .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                              .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)
                            ) ) axi4_slave_ae;

  // Instantiate the analysis ports
  uvm_analysis_port #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))) axi4_m1_ap;
  uvm_analysis_port #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))) axi4_m0_ap;

  // Intermediate Transaction variable
  axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_SLAVE_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) axi4_transaction;

  // Transaction variable for predicted values to be sent out either slave_axi4_txn_m0_ap or slave_axi4_txn_m1_ap
  axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) axi4_ap_output_transaction;

  // Transaction variable for predicted values to be sent out axi4_m1_ap
  // axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) axi4_m1_ap_output_transaction;
  // Code for sending output transaction out through axi4_m1_ap
  // axi4_m1_ap.write(axi4_m1_ap_output_transaction);

  // Transaction variable for predicted values to be sent out axi4_m0_ap
  // axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) axi4_m0_ap_output_transaction;
  // Code for sending output transaction out through axi4_m0_ap
  // axi4_m0_ap.write(axi4_m0_ap_output_transaction);


  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    axi4_slave_ae = new("axi4_slave_ae", this);

    axi4_m1_ap =new("axi4_m1_ap", this );
    axi4_m0_ap =new("axi4_m0_ap", this );

  endfunction

  // FUNCTION: write_axi4_slave_ae
  // Transactions received through axi4_slave_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_axi4_slave_ae(mvc_sequence_item_base t);
    `uvm_info("COV", "Transaction Received through axi4_slave_ae", UVM_MEDIUM)
    `uvm_info("COV", {"            Data: ",t.convert2string()}, UVM_FULL)

    // `uvm_info("RED_ALERT:UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)
    // `uvm_info("RED_ALERT:UNIMPLEMENTED_PREDICTOR_MODEL", "The axi4_slave_predictor::write_axi4_slave_ae function needs to be completed with DUT prediction model",UVM_NONE)
    // `uvm_info("RED_ALERT:UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)

    // Construct one of each intermediate transaction type.
    axi4_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_SLAVE_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("axi4_transaction");

    // Construct one of each output transaction type.
    // axi4_m1_ap_output_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("axi4_m1_ap_output_transaction");
    // axi4_m0_ap_output_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("axi4_m0_ap_output_transaction");

    axi4_ap_output_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("axi4_ap_output_transaction");

    if (!$cast(axi4_transaction, t.clone)) `uvm_fatal("PRED", "Error casting");

    // before adapter
    // axi4_transaction.print();

    // Populate broadcast txn attributes by copying attributes from received txn
    // Attributes are defined within questa_mvc_src/sv/axi4/shared/axi_master_sequence_items_MTI.svh
    // Those attributes not specified below will be zero or null.
    axi4_ap_output_transaction.id = axi4_transaction.id[AXI4_MASTER_ID_WIDTH-1:0];
    axi4_ap_output_transaction.addr = axi4_transaction.addr;
    axi4_ap_output_transaction.read_or_write = axi4_transaction.read_or_write;
    axi4_ap_output_transaction.prot = axi4_transaction.prot;
    axi4_ap_output_transaction.region = axi4_transaction.region;
    axi4_ap_output_transaction.size = axi4_transaction.size;
    axi4_ap_output_transaction.burst = axi4_transaction.burst;
    axi4_ap_output_transaction.burst_length = axi4_transaction.burst_length;
    axi4_ap_output_transaction.lock = axi4_transaction.lock;
    axi4_ap_output_transaction.cache = axi4_transaction.cache;
    axi4_ap_output_transaction.qos = axi4_transaction.qos;
    axi4_ap_output_transaction.rdata_words = axi4_transaction.rdata_words;     // dynamic array
    axi4_ap_output_transaction.wdata_words = axi4_transaction.wdata_words;     // dynamic array
    axi4_ap_output_transaction.write_strobes = axi4_transaction.write_strobes; // dynamic array
    axi4_ap_output_transaction.resp = axi4_transaction.resp;                   // dynamic array

    // after adapter
    axi4_ap_output_transaction.print();

    // Code for sending output transaction out through axi4_m1_ap
    // axi4_m1_ap.write(axi4_m1_ap_output_transaction);
    // Code for sending output transaction out through axi4_m0_ap
    // axi4_m0_ap.write(axi4_m0_ap_output_transaction);

    // Now send output transaction through appropriate ap
    if (axi4_transaction.id[AXI4_SLAVE_ID_WIDTH-1])  // if msb asserted, then write to m1, else write to m0.
      axi4_m1_ap.write(axi4_ap_output_transaction);
    else
      axi4_m0_ap.write(axi4_ap_output_transaction);

  endfunction

endclass 

