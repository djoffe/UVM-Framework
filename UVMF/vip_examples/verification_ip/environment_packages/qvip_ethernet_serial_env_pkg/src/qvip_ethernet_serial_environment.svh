//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : dbole
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_serial Environment 
// Unit            : qvip_ethernet_serial Environment
// File            : qvip_ethernet_serial_environment.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This environment contains all agents, predictors and
// scoreboards required for the block level design.
//----------------------------------------------------------------------
//


class qvip_ethernet_serial_environment extends uvmf_environment_base #(.CONFIG_T( qvip_ethernet_serial_configuration));

  `uvm_component_utils( qvip_ethernet_serial_environment );

   ethernet_agent qvip_ethernet_agent;

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

  qvip_ethernet_agent = ethernet_agent::type_id::create("qvip_ethernet_agent",this);

  endfunction

// ****************************************************************************
// FUNCTION: connect_phase()
// This function makes all connections within this environment.  Connections
// typically inclue agent to predictor, predictor to scoreboard and scoreboard
// to agent.
//
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

// Uncomment these lines and connect the agents to predictors or scoreboards as needed
// qvip_ethernet_agent.monitored_ap.connect(selectAnalysisExport);
uvm_config_db #( mvc_sequencer )::set( null , UVMF_SEQUENCERS , configuration.ethernet_qvip_interface_name, qvip_ethernet_agent.m_sequencer );

  endfunction

endclass

