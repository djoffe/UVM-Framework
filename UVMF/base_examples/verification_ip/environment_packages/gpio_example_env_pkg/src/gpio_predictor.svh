//----------------------------------------------------------------------
// Created with uvmf_gen version 2019.4_1
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//
// DESCRIPTION: This analysis component contains analysis_exports for receiving
//   data and analysis_ports for sending data.
// 
//   This analysis component has the following analysis_exports that receive the 
//   listed transaction type.
//   
//   gpio_b_ae receives transactions of type  gpio_transaction#(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32))  
//   gpio_a_ae receives transactions of type  gpio_transaction#(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16))  
//
//   This analysis component has the following analysis_ports that can broadcast 
//   the listed transaction type.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class gpio_predictor #(
  type CONFIG_T
  ) extends uvm_component;

  // Factory registration of this class
  `uvm_component_param_utils( gpio_predictor #(
                              CONFIG_T
                              ))


  // Instantiate a handle to the configuration of the environment in which this component resides
  CONFIG_T configuration;

  
  // Instantiate the analysis exports
  uvm_analysis_imp_gpio_b_ae #(gpio_transaction#(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32)), gpio_predictor #(
                              .CONFIG_T(CONFIG_T)
                              )) gpio_b_ae;
  uvm_analysis_imp_gpio_a_ae #(gpio_transaction#(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16)), gpio_predictor #(
                              .CONFIG_T(CONFIG_T)
                              )) gpio_a_ae;




  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // FUNCTION: new
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction

  // FUNCTION: build_phase
  virtual function void build_phase (uvm_phase phase);

    gpio_b_ae = new("gpio_b_ae", this);
    gpio_a_ae = new("gpio_a_ae", this);
  endfunction

  // FUNCTION: write_gpio_b_ae
  // Transactions received through gpio_b_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_gpio_b_ae(gpio_transaction#(.WRITE_PORT_WIDTH(16),.READ_PORT_WIDTH(32)) t);
    // pragma uvmf custom gpio_b_ae_predictor begin
    `uvm_info("PRED", "Transaction Received through gpio_b_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_MEDIUM)
    //  UVMF_CHANGE_ME: Implement predictor model here.  
    `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)
    `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "UVMF_CHANGE_ME: The gpio_predictor::write_gpio_b_ae function needs to be completed with DUT prediction model",UVM_NONE)
    `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)
 
    // pragma uvmf custom gpio_b_ae_predictor end
  endfunction

  // FUNCTION: write_gpio_a_ae
  // Transactions received through gpio_a_ae initiate the execution of this function.
  // This function performs prediction of DUT output values based on DUT input, configuration and state
  virtual function void write_gpio_a_ae(gpio_transaction#(.WRITE_PORT_WIDTH(32),.READ_PORT_WIDTH(16)) t);
    // pragma uvmf custom gpio_a_ae_predictor begin
    `uvm_info("PRED", "Transaction Received through gpio_a_ae", UVM_MEDIUM)
    `uvm_info("PRED", {"            Data: ",t.convert2string()}, UVM_MEDIUM)
    //  UVMF_CHANGE_ME: Implement predictor model here.  
    `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)
    `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "UVMF_CHANGE_ME: The gpio_predictor::write_gpio_a_ae function needs to be completed with DUT prediction model",UVM_NONE)
    `uvm_info("UNIMPLEMENTED_PREDICTOR_MODEL", "******************************************************************************************************",UVM_NONE)
 
    // pragma uvmf custom gpio_a_ae_predictor end
  endfunction


endclass 
