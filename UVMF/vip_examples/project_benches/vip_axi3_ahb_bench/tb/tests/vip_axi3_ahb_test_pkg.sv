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
// Project         : VIP Integration example
// Unit            : Test package
// File            : vip_axi3_ahb_test_pkg.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This package contains all tests written for the VIP
//    AHB example environment.  Placing all tests in this package allows
//    all tests to be run after a single compilation.  All tests should
//    be extended from test_top.  Test_top is an extension of uvmf_test_base
//    which is an extension of uvm_test.  This allows specifying the 
//    test to be run on the commandline using +UVM_TESTNAME=test_name.
//
//----------------------------------------------------------------------
//
package vip_axi3_ahb_test_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import vip_axi3_ahb_env_pkg::*;
   import vip_axi3_ahb_parameters_pkg::*;
   import vip_axi3_ahb_sequences_pkg::*;
   `include "uvm_macros.svh"

   `include "src/test_typedefs.svh"
   `include "src/test_top.svh"
   `include "src/example_derived_test.svh"

endpackage
