//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_out interface agent
// Unit            : Interface HVL package
// File            : alu_out_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    interface package that will run on the host simulator.
//
// CONTAINS:
//    - <alu_out_typedefs_hdl>
//    - <alu_out_typedefs.svh>
//    - <alu_out_transaction.svh>

//    - <alu_out_configuration.svh>
//    - <alu_out_driver.svh>
//    - <alu_out_monitor.svh>

//    - <alu_out_transaction_coverage.svh>
//    - <alu_out_sequence_base.svh>
//    - <alu_out_random_sequence.svh>

//    - <alu_out_responder_sequence.svh>
//    - <alu_out2reg_adapter.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package alu_out_pkg;
  
   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg_hdl::*;
   import uvmf_base_pkg::*;
   import alu_out_pkg_hdl::*;
   `include "uvm_macros.svh"
   
   export alu_out_pkg_hdl::*;
   

   `include "src/alu_out_typedefs.svh"
   `include "src/alu_out_transaction.svh"

   `include "src/alu_out_configuration.svh"
   `include "src/alu_out_driver.svh"
   `include "src/alu_out_monitor.svh"

   `include "src/alu_out_transaction_coverage.svh"
   `include "src/alu_out_sequence_base.svh"
   `include "src/alu_out_random_sequence.svh"

   `include "src/alu_out_responder_sequence.svh"
   `include "src/alu_out2reg_adapter.svh"

   `include "src/alu_out_agent.svh"

   typedef uvm_reg_predictor #(alu_out_transaction) alu_out2reg_predictor;


endpackage

