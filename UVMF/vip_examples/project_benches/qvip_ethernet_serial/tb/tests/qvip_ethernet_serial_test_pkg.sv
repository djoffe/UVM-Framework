//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : dbole
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_serial Simulation Bench 
// Unit            : Test package
// File            : qvip_ethernet_serial_test_pkg.sv
//----------------------------------------------------------------------
//
// DESCRIPTION: This package contains all tests currently written for
//     the simulation project.  Once compiled, any test can be selected
//     from the vsim command line using +UVM_TESTNAME=yourTestNameHere
//
// CONTAINS:
//     -<test_top>
//     -<example_derived_test>
//
//----------------------------------------------------------------------
//

package qvip_ethernet_serial_test_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import qvip_ethernet_serial_parameters_pkg::*;
   import qvip_ethernet_serial_env_pkg::*;
   import qvip_ethernet_serial_sequences_pkg::*;
   `include "uvm_macros.svh"

   `include "src/test_top.svh"
   `include "src/example_derived_test.svh"

endpackage

