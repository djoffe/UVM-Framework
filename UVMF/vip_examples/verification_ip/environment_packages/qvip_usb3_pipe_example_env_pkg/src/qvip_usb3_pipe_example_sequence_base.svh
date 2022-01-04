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
// Unit            : qvip_usb3_pipe_example_sequence_base
// File            : qvip_usb3_pipe_example_sequence_base.svh
//----------------------------------------------------------------------
// Created by      : student
// Creation Date   : 2014/11/05
//----------------------------------------------------------------------

// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
class qvip_usb3_pipe_example_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( qvip_usb3_pipe_example_sequence_base );

  function new(string name = "" );
    super.new(name);
  endfunction

endclass

