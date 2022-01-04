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
// File            : vip_ahb_example_translator.svh
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
//    transaction once a transaction from each ahb phase had been
//    received.
//
//----------------------------------------------------------------------
//

class vip_ahb_example_translator #(int AHB_NUM_MASTERS     =  1,
                                   int AHB_NUM_MASTER_BITS =  1,
                                   int AHB_NUM_SLAVES      =  1,
                                   int AHB_ADDRESS_WIDTH   = 32,
                                   int AHB_WDATA_WIDTH     = 32,
                                   int AHB_RDATA_WIDTH     = 32,
                                   type T=mvc_sequence_item_base,
                                   type P=wb_transaction)
                                  extends uvmf_predictor_base #(T,P);

  `uvm_component_param_utils(vip_ahb_example_translator #( AHB_NUM_MASTERS,
                                                           AHB_NUM_MASTER_BITS,
                                                           AHB_NUM_SLAVES,
                                                           AHB_ADDRESS_WIDTH,
                                                           AHB_WDATA_WIDTH,
                                                           AHB_RDATA_WIDTH,
                                                           T,P))

 typedef ahb_slave_slave_control_phase #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS,
                                          AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH,
                                          AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_control_ph_t;

   typedef ahb_slave_slave_response_phase #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS,
                                          AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH,
                                          AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_response_ph_t;

   typedef ahb_slave_slave_rd_data_phase #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS,
                                          AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH,
                                          AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_rd_data_phase_t;

   typedef ahb_slave_slave_wr_data_phase #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS,
                                          AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH,
                                          AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_wr_data_phase_t;

   typedef ahb_slave_slave_hsplit_cycle #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS,
                                          AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH,
                                          AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) slave_split_cycle_t;

  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

  function P transform( T t );
    P p;
    return p;
  endfunction;

  P wb_trans;

  virtual function void write( T t );
      slave_control_ph_t     slave_control_ph;
      slave_response_ph_t    slave_response_ph;
      slave_rd_data_phase_t  slave_rd_data_phase;
      slave_wr_data_phase_t  slave_wr_data_phase;
      slave_split_cycle_t    slave_split_cycle;

      `uvm_info("PRED","write() called",UVM_MEDIUM);
      if ( $cast(slave_control_ph, t) ) begin
         `uvm_info("PRED","slave_control_ph", UVM_MEDIUM);
         slave_control_ph.print();
         wb_trans = new();
         wb_trans.addr = slave_control_ph.addr;
         if ( slave_control_ph.write == AHB_WRITE) wb_trans.op = WB_WRITE;
         else                                      wb_trans.op = WB_READ;
      end else if ( $cast(slave_response_ph, t) ) begin
         `uvm_info("PRED","slave_response_ph", UVM_MEDIUM);
         slave_response_ph.print();
      end else if ( $cast(slave_rd_data_phase, t) ) begin
         `uvm_info("PRED","slave_rd_data_phase", UVM_MEDIUM);
         slave_rd_data_phase.print();
         wb_trans.data = slave_rd_data_phase.data;
         transformed_result_analysis_port.write(wb_trans);
      end else if ( $cast(slave_wr_data_phase, t) ) begin
         `uvm_info("PRED","slave_wr_data_phase", UVM_MEDIUM);
         slave_wr_data_phase.print();
         wb_trans.data = slave_wr_data_phase.data;
         transformed_result_analysis_port.write(wb_trans);
      end else if ( $cast(slave_split_cycle, t) ) begin
         `uvm_info("PRED","slave_split_cycle", UVM_MEDIUM);
         slave_split_cycle.print();
      end else begin
         `uvm_fatal("PRED","Incorrect type for casting");
      end

  endfunction

endclass


typedef vip_ahb_example_translator #(.AHB_NUM_MASTERS     (  1),
                                     .AHB_NUM_MASTER_BITS (  1),
                                     .AHB_NUM_SLAVES      (  1),
                                     .AHB_ADDRESS_WIDTH   ( 32),
                                     .AHB_WDATA_WIDTH     ( 32),
                                     .AHB_RDATA_WIDTH     ( 32),
                                     .T(mvc_sequence_item_base),
                                     .P(wb_transaction))
                                    vip_ahb_example_translator_t;
