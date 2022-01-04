//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu Environment 
// Unit            : Environment Sequence Base
// File            : alu_env_sequence_base.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//
class alu_env_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( alu_env_sequence_base );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

