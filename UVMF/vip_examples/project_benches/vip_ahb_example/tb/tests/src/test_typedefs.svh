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
  typedef vip_ahb_example_configuration #(.AHB_NUM_MASTERS (TEST_AHB_NUM_MASTERS),
                                           .AHB_NUM_MASTER_BITS (TEST_AHB_NUM_MASTER_BITS),
                                           .AHB_NUM_SLAVES (TEST_AHB_NUM_SLAVES),
                                           .AHB_ADDRESS_WIDTH (TEST_AHB_ADDRESS_WIDTH),
                                           .AHB_WDATA_WIDTH (TEST_AHB_WDATA_WIDTH),
                                           .AHB_RDATA_WIDTH (TEST_AHB_RDATA_WIDTH))
                                       vip_ahb_example_configuration_t;
  typedef vip_ahb_example_environment  #(.AHB_NUM_MASTERS (TEST_AHB_NUM_MASTERS),
                                          .AHB_NUM_MASTER_BITS (TEST_AHB_NUM_MASTER_BITS),
                                          .AHB_NUM_SLAVES (TEST_AHB_NUM_SLAVES),
                                          .AHB_ADDRESS_WIDTH (TEST_AHB_ADDRESS_WIDTH),
                                          .AHB_WDATA_WIDTH (TEST_AHB_WDATA_WIDTH),
                                          .AHB_RDATA_WIDTH (TEST_AHB_RDATA_WIDTH),
                                          .AHB_SLAVE_NAME (VIP_AHB_BFM_SLV))
                                         vip_ahb_example_environment_t;
  typedef vip_ahb_example_sequence_base #(.AHB_NUM_MASTERS (TEST_AHB_NUM_MASTERS),
                                           .AHB_NUM_MASTER_BITS (TEST_AHB_NUM_MASTER_BITS),
                                           .AHB_NUM_SLAVES (TEST_AHB_NUM_SLAVES),
                                           .AHB_ADDRESS_WIDTH (TEST_AHB_ADDRESS_WIDTH),
                                           .AHB_WDATA_WIDTH (TEST_AHB_WDATA_WIDTH),
                                           .AHB_RDATA_WIDTH (TEST_AHB_RDATA_WIDTH),
                                           .REQ(uvm_sequence_item), 
                                           .RSP(uvm_sequence_item) )
                                         vip_ahb_example_sequence_base_t;
  typedef example_derived_test_sequence #(.AHB_NUM_MASTERS (TEST_AHB_NUM_MASTERS),
                                           .AHB_NUM_MASTER_BITS (TEST_AHB_NUM_MASTER_BITS),
                                           .AHB_NUM_SLAVES (TEST_AHB_NUM_SLAVES),
                                           .AHB_ADDRESS_WIDTH (TEST_AHB_ADDRESS_WIDTH),
                                           .AHB_WDATA_WIDTH (TEST_AHB_WDATA_WIDTH),
                                           .AHB_RDATA_WIDTH (TEST_AHB_RDATA_WIDTH),
                                           .REQ(uvm_sequence_item), 
                                           .RSP(uvm_sequence_item) )
                                         example_derived_test_sequence_t;

