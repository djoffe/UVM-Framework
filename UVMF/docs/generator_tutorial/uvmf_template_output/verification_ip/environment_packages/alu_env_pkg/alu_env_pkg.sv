//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu environment agent
// Unit            : Environment HVL package
// File            : alu_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <alu_configuration.svh>
//     - <alu_environment.svh>
//     - <alu_env_sequence_base.svh>
//     - <alu_infact_env_sequence.svh>
//     - <alu_predictor.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package alu_env_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
   import alu_in_pkg::*;
   import alu_out_pkg::*;



   `uvm_analysis_imp_decl(_alu_in_agent_ae)

   `include "src/alu_env_configuration.svh"
   `include "src/alu_predictor.svh"
   `include "src/alu_environment.svh"
   `include "src/alu_env_sequence_base.svh"
   `include "src/alu_infact_env_sequence.svh"
  
endpackage

