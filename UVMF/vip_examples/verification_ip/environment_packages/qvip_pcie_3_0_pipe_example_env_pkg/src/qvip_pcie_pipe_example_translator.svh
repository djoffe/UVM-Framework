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
// Unit            : Translator
// File            : qvip_pcie_pipe_example_translator.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This class provides type casting and translation from
//    QVIP AHB transactions into WB transactions.
//
//    This extension of the transformer creates an empty transform
//    function.  This is to satisfy the requirements of the transformer
//    class that its derived classes implement a transform function.
//    This class replaces the write function in the transformer class.
//    This was required because each transaction received does not
//    require a transaction be broadcast.  Many transactions must be
//    received before a transaction can be sent.  Because of this the
//    write function needed to store state and only broadcast a
//    transaction once a transaction from each pcie_pipe phase had been
//    received.
//
//----------------------------------------------------------------------
//

class qvip_pcie_pipe_example_translator #(

                                    type T=mvc_sequence_item_base,
                                    type P=uvmf_transaction_base)
                                    extends uvmf_predictor_base #(T,P);

  `uvm_component_param_utils(qvip_pcie_pipe_example_translator #( 

                                                             T,P))


  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  function P transform( T t );
  endfunction;

  P uvmf_transaction_base;

  virtual function void write( T t );
      // axi_rw_trans_t pcie_pipe_trans;

      // `uvm_info("Subscriber","write() called",UVM_MEDIUM);
      // if ( $cast(pcie_pipe_trans, t) ) begin
         // `uvm_info("Translator","pcie_pipe_trans", UVM_MEDIUM);
         // pcie_pipe_trans.print();
      // end else begin
         // `uvm_fatal("Translator","Incorrect type for casting");
      // end

  endfunction

endclass


typedef qvip_pcie_pipe_example_translator #(

                                      .T(mvc_sequence_item_base),
                                      .P(uvmf_transaction_base))
                                    qvip_pcie_pipe_example_translator_t;
