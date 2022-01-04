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
// Unit            : Clock and reset generator
// File            : clk_reset.sv
//----------------------------------------------------------------------
// Creation Date   : 01.16.2013
//----------------------------------------------------------------------
// Description: This module generates a clock and reset.
//
//----------------------------------------------------------------------
//
module clk_reset (output bit clk, reset);

  reg iclk, irst;
  
  assign clk = iclk;
  assign reset = irst;
  
  initial
  begin
    iclk = 0;
        forever #5 iclk = ~iclk;
  end
  
  initial
  begin
    irst = 0;
        #37 irst = 1;
  end
  
endmodule
