//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : vgill
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_parallel Simulation Bench 
// Unit            : Sequence for example derived test
// File            : example_derived_test_sequence.svh
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains the top level sequence used in  example_derived_test.
// It is an example of a sequence that is extended from %(benchName)_sequence_base
// and can override %(benchName)_sequence_base.
//
//----------------------------------------------------------------------
//

class example_derived_test_sequence extends qvip_example_ethernet_parallel_sequence_base;

  `uvm_object_utils( example_derived_test_sequence );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

