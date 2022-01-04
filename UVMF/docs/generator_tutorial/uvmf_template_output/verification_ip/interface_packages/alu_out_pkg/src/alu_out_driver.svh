//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_out interface agent
// Unit            : Interface UVM Driver
// File            : alu_out_driver.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class passes transactions between the sequencer
//        and the BFM driver interface.  It accesses the driver BFM 
//        through the bfm handle. This driver
//        passes transactions to the driver BFM through the access
//        task.  
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class alu_out_driver  #(
      int ALU_OUT_RESULT_WIDTH = 16                                
      ) extends uvmf_driver_base #(
                   .CONFIG_T(alu_out_configuration  #(
                             .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
                             ) ),
                   .BFM_BIND_T(virtual alu_out_driver_bfm #(
                             .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
                             ) ),
                   .REQ(alu_out_transaction  #(
                             .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
                             ) ),
                   .RSP(alu_out_transaction  #(
                             .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( alu_out_driver #(
                              ALU_OUT_RESULT_WIDTH
                            ))

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent=null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure(

          cfg.active_passive,
          cfg.initiator_responder
);                    
   
   endfunction

// ****************************************************************************
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;
   endfunction

// ****************************************************************************              
  virtual task access( inout REQ txn );
      if (configuration.initiator_responder==RESPONDER) begin
        if (1'b1) begin
          bfm.do_response_ready(
                      );
        end
        bfm.response(
      txn.result        
          );
      end else begin    
        bfm.access(
      txn.result            );
    end
  endtask

endclass
