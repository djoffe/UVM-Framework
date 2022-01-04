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
// Project         : QVIP Integration example
// Unit            : Environment
// File            : vip_ahb_example_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the environment.  It is reusable
//    from block to chip to system level simulations.  Its configuration
//    is vip_ahb_example_environment_configuration.  Agents within this
//    environment are configured from this environments configuration.
//
//----------------------------------------------------------------------
//
class vip_ahb_example_environment  #(int AHB_NUM_MASTERS     =  1,
                                      int AHB_NUM_MASTER_BITS =  1,
                                      int AHB_NUM_SLAVES      =  1,
                                      int AHB_ADDRESS_WIDTH   = 32,
                                      int AHB_WDATA_WIDTH     = 32,
                                      int AHB_RDATA_WIDTH     = 32,
                                      string AHB_SLAVE_NAME   = "hvl_top.DUT"
                                     ) extends uvmf_environment_base #(.CONFIG_T(vip_ahb_example_configuration));

  `uvm_component_param_utils( vip_ahb_example_environment  #(AHB_NUM_MASTERS, 
                                                             AHB_NUM_MASTER_BITS, 
                                                             AHB_NUM_SLAVES, 
                                                             AHB_ADDRESS_WIDTH, 
                                                             AHB_WDATA_WIDTH, 
                                                             AHB_RDATA_WIDTH,
                                                             AHB_SLAVE_NAME));

  // Declare ahb_master_agent to be a handle of type mvc_agent.
  mvc_agent ahb_master_agent;

 // This component encapsulates the slave mvc_agent and provides
 //    translation from QVIP transactions into custom transactions.
typedef qvip_agent_adapter #(.USE_EXTERNAL_AGENT(1),
                             .EXTERNAL_AGENT_NAME(AHB_SLAVE_NAME),
                             .TRANSLATOR_TYPE(vip_ahb_example_translator_t),
                             .TRANSACTION_TYPE(wb_transaction)) ahb_slave_agent_t;
  ahb_slave_agent_t ahb_slave_agent;

typedef vip_ahb_example_rx_tx_sorter #(.T(wb_transaction), 
                                       .P0(wb_transaction), 
                                       .P1(wb_transaction)) 
                                      vip_ahb_example_rx_tx_sorter_t;

vip_ahb_example_rx_tx_sorter_t rx_tx_sorter;

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
// ahb_master_agent is a handle to an mvc_agent. In this function
// a new mvc_agent object is created and the handle ahb_master_agent
// is assigned to that object. 
// It is named "ahb_master_agent", which is the name that will appear in
// the UVM hierearchy.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ahb_master_agent = mvc_agent::type_id::create("ahb_master_agent", this);
    ahb_slave_agent  = ahb_slave_agent_t::type_id::create("ahb_slave_agent", this);
    rx_tx_sorter     = vip_ahb_example_rx_tx_sorter_t::type_id::create("rx_tx_sorter", this);
  endfunction

// ****************************************************************************
//  Connect the ahb_slave_agent to the rx_tx_sorter
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ahb_slave_agent.monitored_ap.connect( rx_tx_sorter.analysis_export );
  endfunction

endclass

