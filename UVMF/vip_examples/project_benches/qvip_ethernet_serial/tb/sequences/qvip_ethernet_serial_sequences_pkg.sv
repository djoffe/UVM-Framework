//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : dbole
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_serial Simulation Bench 
// Unit            : Sequences Package
// File            : qvip_ethernet_serial_sequences_pkg.sv
//----------------------------------------------------------------------
//
// DESCRIPTION: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
// CONTAINS:
//     -<qvip_ethernet_serial_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package qvip_ethernet_serial_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import qvip_ethernet_serial_parameters_pkg::*;
   import mvc_pkg::*;
   import mgc_ethernet_v1_0_pkg::*; 
  
   `include "uvm_macros.svh"

   `include "src/ethernet_mix_frame_sequence_finite.svh"
   `include "src/qvip_example_ethernet_serial_sequence_base.svh"
   `include "src/example_derived_test_sequence.svh"

endpackage

