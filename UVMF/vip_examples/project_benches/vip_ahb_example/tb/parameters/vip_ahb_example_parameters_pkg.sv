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
// Project         : AHB VIP Bench
// Unit            : Parameters Package
// File            : vip_ahb_example_parameters_pkg.sv
//----------------------------------------------------------------------
// Creation Date   : 04.21.2014
//----------------------------------------------------------------------
// Description: This package contains all parameterss currently written for
//     the simulation project. 
//
//----------------------------------------------------------------------
//
package vip_ahb_example_parameters_pkg;

parameter int TEST_AHB_NUM_MASTERS = 1;
parameter int TEST_AHB_NUM_MASTER_BITS = 1;
parameter int TEST_AHB_NUM_SLAVES = 1;
parameter int TEST_AHB_ADDRESS_WIDTH = 32;
parameter int TEST_AHB_WDATA_WIDTH = 32;
parameter int TEST_AHB_RDATA_WIDTH = 32;

parameter string VIP_AHB_BFM_MSTR = "VIP_AHB_BFM_MSTR";
parameter string VIP_AHB_BFM_SLV = "VIP_AHB_BFM_SLV";

endpackage
