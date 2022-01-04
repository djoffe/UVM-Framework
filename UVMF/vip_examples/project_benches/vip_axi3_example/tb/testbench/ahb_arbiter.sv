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
// Unit            : AHB Arbiter
// File            : ahb_arbiter.sv
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This module performs basic arbitration.
//
//----------------------------------------------------------------------
//
module ahb_arbiter(output HGRANT, HMASTER, HMASTLOCK, input HLOCK,HCLK);

  reg ilock;
  assign HGRANT    = 1;
  assign HMASTER   = 0;
  assign HMASTLOCK = ilock;


initial
ilock=0;
   
   always @(posedge HCLK)
    if((HGRANT == 1'b1)&&(HLOCK == 1'b1))
    ilock <= HLOCK ;
    else
    ilock <= 0 ;
endmodule

