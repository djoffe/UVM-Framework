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
// Unit            : Reusable environment package
// File            : qvip_pcie_pipe_example_env_pkg.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This file contains all the class definitions used to
//    define the package that includes the reusable environment.
//
//    The pcie_pipe_pkg is imported for use of the pcie_pipe_transaction class.
//    The pcie_pipe_pkg is not required for use by the AHB QVIP.  The pcie_pipe_pkg
//    class is imported so that the standard AHB transactions contained
//    in the QVIP can be translated into the pcie_pipe_transaction for
//    scoreboarding, prediction and coverage.  The pcie_pipe_transaction
//    contains debug utilities used by this library.
//
//----------------------------------------------------------------------
//
package qvip_pcie_3_0_pipe_example_env_pkg;

import uvm_pkg::*;
import questa_uvm_pkg::*;
import mvc_pkg::*;
import mgc_pcie_v2_0_pkg::*;
import qvip_utils_pkg::*;

`include "uvm_macros.svh"
`include "mvc_macros.svh"

`include "pcie_macros.svh"

import uvmf_base_pkg::*;

   `include "src/qvip_pcie_pipe_example_configuration.svh"
   `include "src/qvip_pcie_pipe_example_translator.svh"
   `include "src/qvip_pcie_pipe_example_environment.svh"
   `include "src/qvip_pcie_pipe_example_env_sequence_base.svh"

endpackage
