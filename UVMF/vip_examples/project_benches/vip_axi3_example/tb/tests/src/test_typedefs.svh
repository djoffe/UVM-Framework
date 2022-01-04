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
// Unit            : Test typedefs
// File            : test_typedefs.svh
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: These typedefs define parameters used by the AHB VIP.
//   They are used when instantiating the environment, the environments
//   configuration and the sequences.
//
//----------------------------------------------------------------------

  typedef vip_axi3_example_configuration #(.AXI_ADDRESS_WIDTH (TEST_AXI_ADDRESS_WIDTH),
                                           .AXI_RDATA_WIDTH (TEST_AXI_RDATA_WIDTH),
                                           .AXI_WDATA_WIDTH (TEST_AXI_WDATA_WIDTH),
                                           .AXI_ID_WIDTH (TEST_AXI_ID_WIDTH))
                                         vip_axi3_example_configuration_t;
  typedef vip_axi3_example_environment   #(.AXI_ADDRESS_WIDTH (TEST_AXI_ADDRESS_WIDTH),
                                           .AXI_RDATA_WIDTH (TEST_AXI_RDATA_WIDTH),
                                           .AXI_WDATA_WIDTH (TEST_AXI_WDATA_WIDTH),
                                           .AXI_ID_WIDTH (TEST_AXI_ID_WIDTH))
                                         vip_axi3_example_environment_t;
  typedef vip_axi3_example_sequence_base #(.AXI_ADDRESS_WIDTH (TEST_AXI_ADDRESS_WIDTH),
                                           .AXI_RDATA_WIDTH (TEST_AXI_RDATA_WIDTH),
                                           .AXI_WDATA_WIDTH (TEST_AXI_WDATA_WIDTH),
                                           .AXI_ID_WIDTH (TEST_AXI_ID_WIDTH),
                                           .REQ(uvm_sequence_item),
                                           .RSP(uvm_sequence_item) )
                                         vip_axi3_example_sequence_base_t;
  typedef example_derived_test_sequence #(.AXI_ADDRESS_WIDTH (TEST_AXI_ADDRESS_WIDTH),
                                           .AXI_RDATA_WIDTH (TEST_AXI_RDATA_WIDTH),
                                           .AXI_WDATA_WIDTH (TEST_AXI_WDATA_WIDTH),
                                           .AXI_ID_WIDTH (TEST_AXI_ID_WIDTH),
                                           .REQ(uvm_sequence_item),
                                           .RSP(uvm_sequence_item) )
                                         example_derived_test_sequence_t;
