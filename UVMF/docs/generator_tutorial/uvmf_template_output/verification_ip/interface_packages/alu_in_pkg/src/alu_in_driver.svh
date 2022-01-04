//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface UVM Driver
// File            : alu_in_driver.svh
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
class alu_in_driver  #(
      int ALU_IN_OP_WIDTH = 8                                
      ) extends uvmf_driver_base #(
                   .CONFIG_T(alu_in_configuration  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ),
                   .BFM_BIND_T(virtual alu_in_driver_bfm #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ),
                   .REQ(alu_in_transaction  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ),
                   .RSP(alu_in_transaction  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( alu_in_driver #(
                              ALU_IN_OP_WIDTH
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
      txn.op,
      txn.a,
      txn.b        
          );
      end else begin    
        bfm.access(
      txn.op,
      txn.a,
      txn.b            );
    end
  endtask

endclass
