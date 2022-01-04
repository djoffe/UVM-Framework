//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : boden
// Creation Date   : 2016 Nov 30
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : gpio_example Simulation Bench 
// Unit            : Top level UVM test
// File            : test_top.svh
//----------------------------------------------------------------------
// Description: This top level UVM test is the base class for all
//     future tests created for this project.
//
//     This test class contains:
//          Configuration:  The top level configuration for the project.
//          Environment:    The top level environment for the project.
//          Top_level_sequence:  The top level sequence for the project.
//                                          
//----------------------------------------------------------------------
//

typedef gpio_example_env_configuration gpio_example_env_configuration_t;
typedef gpio_example_environment gpio_example_environment_t;

class test_top extends uvmf_test_base #(.CONFIG_T(gpio_example_env_configuration_t), 
                                        .ENV_T(gpio_example_environment_t), 
                                        .TOP_LEVEL_SEQ_T(gpio_example_bench_sequence_base));

  `uvm_component_utils( test_top );


string interface_names[] = {
    gpio_pkg_gpio_a_BFM /* gpio_a     [0] */ , 
    gpio_pkg_gpio_b_BFM /* gpio_b     [1] */ 
};

uvmf_active_passive_t interface_activities[] = { 
    ACTIVE /* gpio_a     [0] */ , 
    ACTIVE /* gpio_b     [1] */ 
};



  //variable: clk_ctrl
  //Clock Proxy Object used to control the Clock
  // Must be extended clock_ctrl object and not clock_ctrl_base because
  // bfm is set here.  Usage elsewhere in testbench can just use a
  // clock_ctrl_base handle.
  clock_ctrl #(.PHASE_OFFSET_IN_PS(9000),
               .INIT_CLOCK_HALF_PERIOD(2500)) clk_ctrl;
  
  //variable: reset_ctrl
  //Reset Proxy Object used to control Reset
  // Must be extended reset_ctrl object and not reset_ctrl_base because bfm
  // is set here.  Usage elsewhere in testbench can just use a reset_ctrl_base
  // handle
  async_reset_ctrl #(.RESET_POLARITY(0),
                     .INITIAL_IDLE_TIME_IN_PS(1000),
                     .RESET_ACTIVE_TIME_IN_PS(200000)) reset_ctrl;

// ****************************************************************************
// FUNCTION: new()
// This is the standard system verilog constructor.  All components are 
// constructed in the build_phase to allow factory overriding.
//
  function new( string name = "", uvm_component parent = null );
     super.new( name ,parent );
  endfunction


// ****************************************************************************
// FUNCTION: setup_clock_reset_controllers()
// 
//
  function void setup_clock_reset_controllers();
      virtual clock_bfm #(.PHASE_OFFSET_IN_PS(9000), .INIT_CLOCK_HALF_PERIOD(2500)) clk_bfm;
      virtual async_reset_bfm #(.RESET_POLARITY(0), .INITIAL_IDLE_TIME_IN_PS(1000), .RESET_ACTIVE_TIME_IN_PS(200000)) async_rst_bfm;

      // Construct the clock controller proxy
      clk_ctrl = clock_ctrl #(.PHASE_OFFSET_IN_PS(9000), .INIT_CLOCK_HALF_PERIOD(2500))::type_id::create("clk_ctrl");
      //Set the bfm handle in the clk_ctrl
      if (!uvm_config_db#(virtual clock_bfm #(.PHASE_OFFSET_IN_PS(9000), .INIT_CLOCK_HALF_PERIOD(2500)) )::get(null, UVMF_VIRTUAL_INTERFACES, CLOCK_CONTROLLER, clk_bfm)) begin
        `uvm_fatal("TEST", "Could not get the Clock BFM Interface")
      end
      clk_ctrl.set_bfm(clk_bfm);
      // Make clock controller proxy available to environment
      uvm_config_db #( clock_ctrl_base )::set(null, UVMF_CLOCK_APIS, CLOCK_CONTROLLER, clk_ctrl);

      // Construct the reset controller proxy
      reset_ctrl = async_reset_ctrl #(.RESET_POLARITY(0), .INITIAL_IDLE_TIME_IN_PS(1000), .RESET_ACTIVE_TIME_IN_PS(200000))::type_id::create("reset_ctrl");
      //Set the bfm handle in the reset_ctrl
      if (!uvm_config_db#(virtual async_reset_bfm #(.RESET_POLARITY(0), .INITIAL_IDLE_TIME_IN_PS(1000), .RESET_ACTIVE_TIME_IN_PS(200000)))::get(null, UVMF_VIRTUAL_INTERFACES, RESET_CONTROLLER, async_rst_bfm)) begin
        `uvm_fatal("TEST", "Could not get the Reset BFM Interface")
      end
      reset_ctrl.set_bfm(async_rst_bfm);
      // Make reset controller proxy available to environment
      uvm_config_db #( reset_ctrl_base )::set(null, UVMF_RESET_APIS, RESET_CONTROLLER, reset_ctrl);

  endfunction




// ****************************************************************************
// FUNCTION: build_phase()
// The construction of the configuration and environment classes is done in
// the build_phase of uvmf_test_base.  Once the configuraton and environment
// classes are built then the initialize call is made to perform the
// following: 
//     Monitor and driver BFM virtual interface handle passing into agents
//     Set the active/passive state for each agent
// Once this build_phase completes, the build_phase of the environment is
// executed which builds the agents.
//
  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    configuration.initialize(BLOCK, "uvm_test_top.environment", interface_names, null, interface_activities);

    setup_clock_reset_controllers();


  endfunction

endclass
