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
// Project         : QVIP AHB Example
// Unit            : Rx/Tx Sorter
// File            : vip_axi3_example_rx_tx_sorter.svh
//----------------------------------------------------------------------
// Creation Date   : 01.22.2013
//----------------------------------------------------------------------
// Description: This class performs sorting of Rx and Tx transactions 
//    received from the agent.  Rx transactions are sent out port 0.
//    Tx transactions are sent out port 1.
//
//----------------------------------------------------------------------
class vip_axi3_example_rx_tx_sorter #(type T  = wb_transaction, 
                                      type P0 = wb_transaction, 
                                      type P1 = wb_transaction) 
                                     extends uvmf_sorting_predictor_base #(T,P0,P1);

  `uvm_component_param_utils (vip_axi3_example_rx_tx_sorter #(T, P0, P1))

//----------------------------------------------------------------------
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction : new

//----------------------------------------------------------------------
  virtual function P0 port_0_transform( input T t );
     P0 p0;
     `uvm_info("PRED", "P0 transfomr", UVM_MEDIUM)
     t.print();
     if (t.op == WB_READ ) begin
        p0 = t;
     end
     return p0;
  endfunction

//----------------------------------------------------------------------
  virtual function P1 port_1_transform( input T t );
     P1 p1;
     `uvm_info("PRED", "P1 transfomr", UVM_MEDIUM)
     t.print();
     if (t.op == WB_WRITE )begin
        p1 = t;
     end
     return p1;
  endfunction

endclass 
