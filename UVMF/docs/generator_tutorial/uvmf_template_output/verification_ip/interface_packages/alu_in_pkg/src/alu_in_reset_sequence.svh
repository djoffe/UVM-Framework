//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface random sequence
// File            : alu_in_reset_sequence.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
// This sequences randomizes the alu_in transaction but then fixes it to RST_OP  
// before sending it to the UVM driver.
//
// ****************************************************************************
// This sequence constructs and randomizes a alu_in_transaction.
// 
class alu_in_reset_sequence  #(
      int ALU_IN_OP_WIDTH = 8                                
      )
extends alu_in_sequence_base  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ;

  `uvm_object_param_utils( alu_in_reset_sequence #(
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
      if(!req.randomize()) `uvm_fatal("RANDOMIZE_FAILURE", "alu_in_reset_sequence::body()-alu_in_transaction")
	  // Fix the alu operation to 'rst_op'
	  req.op = rst_op;
      // Send the transaction to the alu_in_driver_bfm via the sequencer and alu_in_driver.
      finish_item(req);
      `uvm_info("random_seq response from driver", req.convert2string(),UVM_MEDIUM)
    end

  endtask: body

endclass: alu_in_reset_sequence
//----------------------------------------------------------------------
//
