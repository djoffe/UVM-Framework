//----------------------------------------------------------------------
//   Copyright 2013 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                   Mentor Graphics Inc
//----------------------------------------------------------------------
// Project         : UVMF_3_4a_Templates
// Unit            : qvip_ahb_example_parameters_pkg
// File            : qvip_ahb_example_parameters_pkg.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2015/05/05
//----------------------------------------------------------------------

// Description: This package contains all parameterss currently written for
//     the simulation project. 
//
package qvip_ahb_example_parameters_pkg;

// These parameters are used to uniquely identify each interface.  The monitor_bfm and
// driver_bfm are placed into and retrieved from the uvm_config_db using these string 
// names as the field_name. The parameter is also used to enable transaction viewing 
// from the command line for selected interfaces using the UVM command line processing.

  parameter int AHB_NUM_MASTERS     =  2;
  parameter int AHB_NUM_MASTER_BITS =  2;
  parameter int AHB_NUM_SLAVES      =  2;
  parameter int AHB_ADDRESS_WIDTH   = 32;
  parameter int AHB_WDATA_WIDTH     = 32;
  parameter int AHB_RDATA_WIDTH     = 32;

  parameter int S0_START_ADDRESS    = 0;
  parameter int S0_END_ADDRESS      = 1023;
  parameter int S1_START_ADDRESS    = 1024;
  parameter int S1_END_ADDRESS      = 2047;

  parameter string qvip_ahb_BFM          = "qvip_ahb_BFM"; 
  parameter string qvip_ahb_monitor_BFM  = "qvip_ahb_monitor_BFM"; 

endpackage

