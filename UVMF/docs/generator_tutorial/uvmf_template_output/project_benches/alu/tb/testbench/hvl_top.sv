//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu Simulation Bench 
// Unit            : Top level HVL module
// File            : hvl_top.sv
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This module loads the test package and starts the UVM phases.
//
//----------------------------------------------------------------------
//

import uvm_pkg::*;
import alu_test_pkg::*;

module hvl_top;

initial run_test();

endmodule

