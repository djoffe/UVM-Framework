//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : dbole
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_serial Simulation Bench 
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

class test_top extends uvmf_test_base #(.CONFIG_T(qvip_ethernet_serial_configuration), 
                                        .ENV_T(qvip_ethernet_serial_environment), 
                                        .TOP_LEVEL_SEQ_T(qvip_example_ethernet_serial_sequence_base));

  `uvm_component_utils( test_top );

// ****************************************************************************
// FUNCTION: new()
// This is the standard system verilog constructor.  All components are 
// constructed in the build_phase to allow factory overriding.
//
  function new( string name = "", uvm_component parent = null );
     super.new( name ,parent );
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
    string interface_names[] = {
    ETH_10G_IF
};
    super.build_phase(phase);
    configuration.initialize(BLOCK, "uvm_test_top.environment", interface_names);

  endfunction
// ****************************************************************************
  //virtual function void connect_phase(uvm_phase phase);
    //super.connect_phase(phase);

    //top_level_sequence.qvip_ethernet_serial_agent_t_config = configuration.qvip_ethernet_serial_agent_t_config;
//
    //top_level_sequence.pcie_pipe_rc_sqr = environment.qvip_ethernet_agent.qvip_agent.m_sequencer;
  //endfunction

// ****************************************************************************
  virtual task run_phase( uvm_phase phase );
    
    phase.raise_objection(this, "Objection raised by test_top");

    top_level_sequence.start(null);

    phase.drop_objection(this, "Objection dropped by test_top");
  endtask

endclass

