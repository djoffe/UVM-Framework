//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : dbole
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_serial environment agent
// Unit            : Environment HVL package
// File            : qvip_ethernet_serial_pkg.sv
//----------------------------------------------------------------------
//     
// PACKAGE: This file defines all of the files contained in the
//    environment package that will run on the host simulator.
//
// CONTAINS:
//     - <qvip_ethernet_serial_configuration.svh"
//     - <qvip_ethernet_serial_environment.svh"
//     - <qvip_ethernet_serial_env_sequence_base.svh"
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
package qvip_ethernet_serial_env_pkg;

    import uvm_pkg::*;
   import questa_uvm_pkg::*;
   `include "uvm_macros.svh"

   import uvmf_base_pkg::*;
//   import ethernet_agent_pkg::*;

   import mvc_pkg::*;
   import mgc_ethernet_v1_0_pkg::*;


   `include "src/qvip_ethernet_serial_configuration.svh"
   `include "src/qvip_ethernet_serial_environment.svh"
   `include "src/qvip_ethernet_serial_sequence_base.svh"
  
endpackage

