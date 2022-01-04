//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface HVL package
// File            : alu_in_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that will run on the host simulator.
//
// CONTAINS:
//    - <alu_in_typedefs_hdl>
//    - <alu_in_typedefs.svh>
//    - <alu_in_transaction.svh>

//    - <alu_in_configuration.svh>
//    - <alu_in_driver.svh>
//    - <alu_in_monitor.svh>

//    - <alu_in_transaction_coverage.svh>
//    - <alu_in_sequence_base.svh>
//    - <alu_in_random_sequence.svh>

//    - <alu_in_responder_sequence.svh>
//    - <alu_in2reg_adapter.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package alu_in_pkg;
  
   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import alu_in_pkg_hdl::*;
   `include "uvm_macros.svh"
   
   export alu_in_pkg_hdl::*;
   

   `include "src/alu_in_typedefs.svh"
   `include "src/alu_in_transaction.svh"

   `include "src/alu_in_configuration.svh"
   `include "src/alu_in_driver.svh"
   `include "src/alu_in_monitor.svh"

   `include "src/alu_in_transaction_coverage.svh"
   `include "src/alu_in_sequence_base.svh"
   `include "src/alu_in_random_sequence.svh"
   `include "src/alu_in_reset_sequence.svh"

   `include "src/alu_in_responder_sequence.svh"
   `include "src/alu_in2reg_adapter.svh"

   `include "src/alu_in_agent.svh"

   typedef uvm_reg_predictor #(alu_in_transaction) alu_in2reg_predictor;


endpackage

