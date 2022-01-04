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
// Unit            : Test typedefs
// File            : test_typedefs.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: These typedefs define parameters used by the AHB QVIP.
//   They are used when instantiating the environment, the environments
//   configuration and the sequences.
//
//----------------------------------------------------------------------
//

parameter string PCIE_RC_IF = "PCIE_RC_IF";
parameter string PCIE_EP_IF = "PCIE_EP_IF";

`define PCIE_B2B_IF

parameter LANES = 4;
parameter PIPE_BYTES_MAX = 1;
parameter CONFIG_NUM_OF_FUNCTIONS = 1;



  typedef qvip_pcie_pipe_example_configuration #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS
                                      ) qvip_pcie_pipe_example_configuration_t;

  typedef qvip_pcie_pipe_example_environment  #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS
                                           ) qvip_pcie_pipe_example_environment_t;

  typedef qvip_pcie_pipe_example_sequence_base #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS)
                                         qvip_pcie_pipe_example_sequence_base_t;

  typedef example_derived_test_sequence #(LANES,PIPE_BYTES_MAX,CONFIG_NUM_OF_FUNCTIONS)
                                         example_derived_test_sequence_t;
