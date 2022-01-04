//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : vgill
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_parallel Environment 
// Unit            : Environment Sequence Base
// File            : qvip_ethernet_parallel_sequence_base.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//
class qvip_ethernet_parallel_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( qvip_ethernet_parallel_sequence_base );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

