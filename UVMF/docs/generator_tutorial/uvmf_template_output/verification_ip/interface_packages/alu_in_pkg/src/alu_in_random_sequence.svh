//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface random sequence
// File            : alu_in_random_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the alu_in transaction and sends it 
// to the UVM driver.
//
// ****************************************************************************
// This sequence constructs and randomizes a alu_in_transaction.
// 
class alu_in_random_sequence  #(
      int ALU_IN_OP_WIDTH = 8                                
      )
extends alu_in_sequence_base  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ;

  `uvm_object_param_utils( alu_in_random_sequence #(
                           ALU_IN_OP_WIDTH
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
      req=alu_in_transaction #( 
                .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
               ) ::type_id::create("req");

      start_item(req);
      // Randomize the transaction
      if(!req.randomize()) `uvm_fatal("RANDOMIZE_FAILURE", "alu_in_random_sequence::body()-alu_in_transaction")
      // Send the transaction to the alu_in_driver_bfm via the sequencer and alu_in_driver.
      finish_item(req);
      `uvm_info("random_seq response from driver", req.convert2string(),UVM_MEDIUM)
    end

  endtask: body

endclass: alu_in_random_sequence
//----------------------------------------------------------------------
//
