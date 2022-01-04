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
// Project         : QVIP Integration example
// Unit            : Sequence package
// File            : qvip_pcie_pipe_example_sequences_pkg.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This package contains all test and environment level
//   sequences.  Protocol level sequences are provided by the QVIP
//   AHB package.
//
//----------------------------------------------------------------------
//
package qvip_pcie_3_0_pipe_example_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import mvc_pkg::*;
   import mgc_pcie_v2_0_pkg::*;

   `include "uvm_macros.svh"

   `include "src/pcie_test_sequence.svh"
   `include "src/pcie_simple_rd_wr_sequence.svh"
   `include "src/qvip_pcie_pipe_example_sequence_base.svh"
   `include "src/example_derived_test_sequence.svh"

endpackage
