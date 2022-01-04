//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_out interface agent
// Unit            : Interface random sequence
// File            : alu_out_random_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the alu_out transaction and sends it 
// to the UVM driver.
//
// ****************************************************************************
// This sequence constructs and randomizes a alu_out_transaction.
// 
class alu_out_random_sequence  #(
      int ALU_OUT_RESULT_WIDTH = 16                                
      )
extends alu_out_sequence_base  #(
                             .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
                             ) ;

  `uvm_object_param_utils( alu_out_random_sequence #(
                           ALU_OUT_RESULT_WIDTH
                            ))

//*****************************************************************
  function new(string name = "");
    super.new(name);
  endfunction: new

// ****************************************************************************
// TASK : body()
// This task is automatically executed when this sequence is started using the 
// start(sequencerHandle) task.
//
  task body();

    begin
      // Construct the transaction
      req=alu_out_transaction #( 
                .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
               ) ::type_id::create("req");

      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("RANDOMIZE_FAILURE", "alu_out_random_sequence::body()-alu_out_transaction")
      // Send the transaction to the alu_out_driver_bfm via the sequencer and alu_out_driver.
      finish_item(req);
      `uvm_info("random_seq response from driver", req.convert2string(),UVM_MEDIUM)
    end

  endtask: body

endclass: alu_out_random_sequence
//----------------------------------------------------------------------
//
