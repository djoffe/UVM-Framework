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
/*****************************************************************************
 *
 * Copyright 2007-2013 Mentor Graphics Corporation
 * All Rights Reserved.
 *
 * THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE
 * PROPERTY OF MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT
 * TO LICENSE TERMS.
 *
 *****************************************************************************/
//
// Class: qvip_pcie_pipe_example_sequence_base
//
// This is a top level sequence which starts PCI Express MVC agent sequences for RC.
// The bring_up sequence automatically does link training followed by bus enumeration.
// Any user specific sequences can be added here and as an example, 
// a simple_rd_wr_sequence is started after bring up is complete.
//
class qvip_pcie_pipe_example_sequence_base  #(int LANES = 4,
                                              int PIPE_BYTES_MAX = 1,
                                              int CONFIG_NUM_OF_FUNCTIONS = 1,
                                              type REQ=uvm_sequence_item,
                                              type RSP=uvm_sequence_item
                                             ) extends uvmf_sequence_base #(REQ,RSP);

  typedef qvip_pcie_pipe_example_sequence_base #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS,REQ,RSP) this_t;
  typedef pcie_vip_config                      #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS) pcie_vip_config_t;
  typedef pcie_bring_up_sequence               #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) pcie_bring_up_sequence_t;
  typedef pcie_simple_rd_wr_sequence           #(LANES, PIPE_BYTES_MAX, CONFIG_NUM_OF_FUNCTIONS) pcie_simple_rd_wr_sequence_t;

  mvc_sequencer pcie_pipe_rc_sqr;
  mvc_sequencer pcie_pipe_ep_sqr;

  pcie_vip_config_t                      pcie_pipe_rc_cfg;

  //UVM Factory Registration
  `uvm_object_param_utils( this_t );

  function new(string name = "" );
    super.new(name);
  endfunction

  //
  // Task: body
  //
  extern task body();

endclass

task qvip_pcie_pipe_example_sequence_base::body();
  pcie_bring_up_sequence_t bring_up_seq = pcie_bring_up_sequence_t::type_id::create("bring_up_sequence");
  pcie_simple_rd_wr_sequence rd_wr_seq = pcie_simple_rd_wr_sequence_t::type_id::create("simple_rd_wr_sequence");

  bring_up_seq.start(pcie_pipe_rc_sqr);

  rd_wr_seq.start(pcie_pipe_rc_sqr);

endtask

