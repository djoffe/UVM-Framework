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
// Project         : VIP Integration example
// Unit            : Environment
// File            : vip_axi3_example_environment.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class defines the environment.  It is reusable
//    from block to chip to system level simulations.  Its configuration
//    is vip_axi3_example_environment_configuration.  Agents within this
//    environment are configured from this environments configuration.
//
//----------------------------------------------------------------------
//
class vip_axi3_example_environment  #(int AXI_ADDRESS_WIDTH  =  32,
                                      int AXI_RDATA_WIDTH =  32,
                                      int AXI_WDATA_WIDTH =  32,
                                      int AXI_ID_WIDTH = 2
                                    ) extends uvmf_environment_base #(.CONFIG_T(vip_axi3_example_configuration));

  `uvm_component_param_utils( vip_axi3_example_environment  #(AXI_ADDRESS_WIDTH ,
                                                              AXI_RDATA_WIDTH,
                                                              AXI_WDATA_WIDTH,
                                                              AXI_ID_WIDTH));

`ifndef QVIP_PRE_10_4_BACKWARD_COMPATIBLE
  typedef axi_agent #(AXI_ADDRESS_WIDTH,
                      AXI_RDATA_WIDTH,
                      AXI_WDATA_WIDTH,
                      AXI_ID_WIDTH
                      ) axi3_agent_t;
`else
  typedef mvc_agent axi3_agent_t;
`endif


 // This component encapsulates the master mvc_agent and provides
 //    translation from VIP transactions into custom transactions.
typedef qvip_agent_adapter #(.USE_EXTERNAL_AGENT(0),
                             .EXTERNAL_AGENT_NAME(""),
                             .AGENT_TYPE(axi3_agent_t),
                             .TRANSLATOR_TYPE(vip_axi3_example_translator_t),
                             .TRANSACTION_TYPE(wb_transaction)) axi3_master_agent_t;
  axi3_master_agent_t axi3_master_agent;

typedef vip_axi3_example_rx_tx_sorter #(.T(wb_transaction),
                                        .P0(wb_transaction),
                                        .P1(wb_transaction))
                                        vip_axi3_example_rx_tx_sorter_t;

vip_axi3_example_rx_tx_sorter_t rx_tx_sorter;

// ****************************************************************************
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction


// ****************************************************************************
// axi3_master_agent is a handle to an mvc_agent. In this function
// a new mvc_agent object is created and the handle axi3_master_agent
// is assigned to that object.
// It is named "axi3_master_agent", which is the name that will appear in
// the UVM hierearchy.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi3_master_agent  = axi3_master_agent_t::type_id::create("axi3_master_agent", this);
    rx_tx_sorter     = vip_axi3_example_rx_tx_sorter_t::type_id::create("rx_tx_sorter", this);
  endfunction

// ****************************************************************************
//  Connect the axi3_slave_agent to the rx_tx_sorter
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    axi3_master_agent.monitored_ap.connect( rx_tx_sorter.analysis_export );
  endfunction

endclass






