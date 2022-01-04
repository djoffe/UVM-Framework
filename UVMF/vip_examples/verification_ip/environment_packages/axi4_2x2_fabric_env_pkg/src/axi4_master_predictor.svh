//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2017 Nov 02
// Created with uvmf_gen version 3.6g
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_master_predictor 
// Unit            : axi4_master_predictor 
// File            : axi4_master_predictor.svh
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
//   axi4_master_ae receives transactions of type  mvc_sequence_item_base  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//  axi4_ap broadcasts transactions of type axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) 
//

class axi4_master_predictor 
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
  `uvm_component_param_utils( axi4_master_predictor #(
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
  uvm_analysis_imp_axi4_master_ae #(mvc_sequence_item_base, axi4_master_predictor  #(
                              .AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
                              .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
                              .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
                              .AXI4_MASTER_ID_WIDTH(AXI4_MASTER_ID_WIDTH),
                              .AXI4_SLAVE_ID_WIDTH(AXI4_SLAVE_ID_WIDTH),
                              .AXI4_USER_WIDTH(AXI4_USER_WIDTH),
                              .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)
                            ) ) axi4_master_ae;

  // Instantiate the analysis ports
  uvm_analysis_port #(axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))) axi4_ap;

  // Transaction variable for predicted values to be sent out axi4_ap
  axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE)) axi4_ap_output_transaction;
  // Code for sending output transaction out through axi4_ap
  // axi4_ap.write(axi4_ap_output_transaction);


  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    axi4_master_ae = new("axi4_master_ae", this);

    axi4_ap =new("axi4_ap", this );

  endfunction

  // FUNCTION: write_axi4_master_ae
  // Transactions received through axi4_master_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_axi4_master_ae(mvc_sequence_item_base t);
    `uvm_info("COV", "Transaction Received through axi4_master_ae", UVM_MEDIUM)
    `uvm_info("COV", {"            Data: ",t.convert2string()}, UVM_FULL)

    // `uvm_info("RED_ALERT:UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)
    // `uvm_info("RED_ALERT:UNIMPLEMENTED_PREDICTOR_MODEL", "The axi4_master_predictor::write_axi4_master_ae function needs to be completed with DUT prediction model",UVM_NONE)
    // `uvm_info("RED_ALERT:UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)

    // Construct one of each output transaction type.
    axi4_ap_output_transaction = axi4_master_rw_transaction #(.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH), .AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH), .AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH), .AXI4_ID_WIDTH(AXI4_MASTER_ID_WIDTH), .AXI4_USER_WIDTH(AXI4_USER_WIDTH), .AXI4_REGION_MAP_SIZE(AXI4_REGION_MAP_SIZE))::type_id::create("axi4_ap_output_transaction");

    if (!$cast(axi4_ap_output_transaction, t.clone)) `uvm_fatal("ADAPT", "Error casting");

    // zero out attributes which are a don't care for comparison...
    axi4_ap_output_transaction.addr_user_data              = 'b0;
    axi4_ap_output_transaction.address_valid_delay         = 'b0;
    axi4_ap_output_transaction.write_response_valid_delay  = 'b0;
    axi4_ap_output_transaction.address_ready_delay         = 'b0;
    axi4_ap_output_transaction.write_response_ready_delay  = 'b0;
    axi4_ap_output_transaction.write_data_with_address     = 'b0;
    axi4_ap_output_transaction.write_address_to_data_delay = 'b0;
    axi4_ap_output_transaction.write_data_to_address_delay = 'b0;
    axi4_ap_output_transaction.resp_user_data.delete();         // dynamic array
    axi4_ap_output_transaction.wdata_user_data.delete();        // dynamic array
    axi4_ap_output_transaction.data_valid_delay.delete();       // dynamic array
    axi4_ap_output_transaction.data_ready_delay.delete();       // dynamic array
    axi4_ap_output_transaction.write_data_beats_delay.delete(); // dynamic array

    // after adapter
    // axi4_ap_output_transaction.print();

    // Code for sending output transaction out through axi4_ap
    axi4_ap.write(axi4_ap_output_transaction);
  endfunction

endclass 

