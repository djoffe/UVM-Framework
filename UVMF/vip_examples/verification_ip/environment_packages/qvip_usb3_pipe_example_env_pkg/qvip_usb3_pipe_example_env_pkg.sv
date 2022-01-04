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
// Unit            : qvip_usb3_pipe_example_env_pkg
// File            : qvip_usb3_pipe_example_env_pkg.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/05
//----------------------------------------------------------------------


// DESCRIPTION: This package contains all files that define the 
//   environment and its configuration.  These components are 
//   reusable from block to chip level simulation without modification.
//
// CONTAINS:
//   -<qvip_usb3_pipe_example_configuration>
//   -<qvip_usb3_pipe_example_environment>
//
package qvip_usb3_pipe_example_env_pkg;

import uvm_pkg::*;
import questa_uvm_pkg::*;
`include "uvm_macros.svh"

import uvmf_base_pkg_hdl::*;
import uvmf_base_pkg::*;

import mvc_pkg::*;
import mgc_usb_ss_v3_0_pkg::*;
import QUESTA_MVC::*;

`include "src/qvip_usb3_pipe_example_configuration.svh"
`include "src/qvip_usb3_pipe_example_environment.svh"
`include "src/qvip_usb3_pipe_example_sequence_base.svh"

endpackage

