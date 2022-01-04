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
// File            : vip_axi3_example_translator.svh
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
//    transaction once a transaction from each axi3 phase had been
//    received.
//
//----------------------------------------------------------------------
//

class vip_axi3_example_translator #(int AXI_ADDRESS_WIDTH  =  32,
                                    int AXI_RDATA_WIDTH =  32,
                                    int AXI_WDATA_WIDTH =  32,
                                    int AXI_ID_WIDTH = 2,
                                    type T=mvc_sequence_item_base,
                                    type P=wb_transaction)
                                    extends uvmf_predictor_base #(T,P);

  `uvm_component_param_utils(vip_axi3_example_translator #( AXI_ADDRESS_WIDTH ,
                                                            AXI_RDATA_WIDTH,
                                                            AXI_WDATA_WIDTH,
                                                            AXI_ID_WIDTH,
                                                            T,P))

    typedef axi_master_rw_transaction #(AXI_ADDRESS_WIDTH,
                                      AXI_RDATA_WIDTH,
                                      AXI_WDATA_WIDTH,
                                      AXI_ID_WIDTH
                                      ) axi_rw_trans_t;


  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  function P transform( T t );
  endfunction;

  P wb_trans;

  virtual function void write( T t );
      axi_rw_trans_t axi3_trans;

      `uvm_info("PRED","write() called",UVM_MEDIUM);
      if ( $cast(axi3_trans, t) ) begin
         `uvm_info("PRED","axi3_trans", UVM_MEDIUM);
         axi3_trans.print();
      end else begin
         `uvm_fatal("PRED","Incorrect type for casting");
      end

  endfunction

endclass


typedef vip_axi3_example_translator #(
                                     .AXI_ADDRESS_WIDTH   ( 32),
                                     .AXI_RDATA_WIDTH     ( 32),
                                     .AXI_WDATA_WIDTH     ( 32),
                                     .AXI_ID_WIDTH        (  2),
                                     .T(mvc_sequence_item_base),
                                     .P(wb_transaction))
                                    vip_axi3_example_translator_t;
