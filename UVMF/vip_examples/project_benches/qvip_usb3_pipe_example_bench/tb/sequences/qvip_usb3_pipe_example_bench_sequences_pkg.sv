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
// Unit            : qvip_usb3_pipe_example_bench_sequences_pkg
// File            : qvip_usb3_pipe_example_bench_sequences_pkg.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/05
//----------------------------------------------------------------------

// DESCRIPTION: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
// CONTAINS:
//     -<qvip_usb3_pipe_example_bench_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
package qvip_usb3_pipe_example_bench_sequences_pkg;

   import uvm_pkg::*;
   import questa_uvm_pkg::*;
   import uvmf_base_pkg::*;
   import mvc_pkg::*;
   import mgc_usb_ss_v3_0_pkg::*;

   import qvip_usb3_pipe_example_bench_parameters_pkg::*;
  
   `include "uvm_macros.svh"

   `include "src/protocol_random.svh"
   `include "src/usb_ss_host_burst_test_sequence_local.svh"
   `include "src/qvip_usb3_pipe_example_bench_sequence_base.svh"
   `include "src/example_derived_test_sequence.svh"

endpackage


