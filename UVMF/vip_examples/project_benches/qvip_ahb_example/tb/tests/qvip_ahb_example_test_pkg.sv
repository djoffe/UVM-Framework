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
// Unit            : qvip_ahb_example_test_pkg
// File            : qvip_ahb_example_test_pkg.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/05
//----------------------------------------------------------------------

// DESCRIPTION: This package contains all tests currently written for
//     the simulation project.  Once compiled, any test can be selected
//     from the vsim command line using +UVM_TESTNAME=yourTestNameHere
//
// CONTAINS:
//     -<test_top>
//     -<example_derived_test>
//
package qvip_ahb_example_test_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import qvip_ahb_example_parameters_pkg::*;
   import qvip_ahb_example_env_pkg::*;
   import qvip_ahb_example_sequences_pkg::*;

   `include "uvm_macros.svh"

   typedef qvip_ahb_example_configuration #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) qvip_ahb_example_configuration_t;
   typedef qvip_ahb_example_environment   #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) qvip_ahb_example_environment_t;
   typedef qvip_ahb_example_sequence_base #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) qvip_ahb_example_sequence_base_t;
   typedef example_derived_test_sequence #(AHB_NUM_MASTERS, AHB_NUM_MASTER_BITS, AHB_NUM_SLAVES, AHB_ADDRESS_WIDTH, AHB_WDATA_WIDTH, AHB_RDATA_WIDTH) example_derived_test_sequence_t;

   `include "src/test_top.svh"
   `include "src/example_derived_test.svh"
endpackage

