//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : daerne
// Creation Date   : 2017 Nov 02
// Created with uvmf_gen version 3.6g
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : axi4_2x2_fabric environment agent
// Unit            : Environment HVL package
// File            : axi4_2x2_fabric_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <axi4_2x2_fabric_configuration.svh>
//     - <axi4_2x2_fabric_environment.svh>
//     - <axi4_2x2_fabric_env_sequence_base.svh>
//     - <axi4_2x2_fabric_infact_env_sequence.svh>
//     - <axi4_master_predictor.svh>
//     - <axi4_slave_predictor.svh>
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package axi4_2x2_fabric_env_pkg;

   import uvm_pkg::*;
   
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
   import mgc_axi4_v1_0_pkg::*;
   import rw_txn_pkg::*;



   import mvc_pkg::*;
   import axi4_2x2_fabric_qvip_pkg::*;

 

   `uvm_analysis_imp_decl(_axi4_master_ae)
   `uvm_analysis_imp_decl(_axi4_slave_ae)

   `include "src/axi4_2x2_fabric_env_typedefs.svh"

   `include "src/axi4_2x2_fabric_env_configuration.svh"
   `include "src/axi4_master_predictor.svh"
   `include "src/axi4_slave_predictor.svh"
   `include "src/axi4_master_rw_adapter.svh"
   `include "src/axi4_slave_rw_adapter.svh"
   `include "src/axi4_2x2_fabric_environment.svh"
   `include "src/axi4_2x2_fabric_env_sequence_base.svh"
   `include "src/axi4_2x2_fabric_infact_env_sequence.svh"
  
endpackage

