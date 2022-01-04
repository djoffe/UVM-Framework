package clock_test_pkg;
  import uvm_pkg::*;
  import clock_pkg::*;
  import reset_pkg::*;

`include "uvm_macros.svh"
  
  timeunit 1ps;
  timeprecision 1ps;

`include "base_test.svh"
`include "clock_test.svh"
`include "reset_test.svh"
`include "manual_reset_test.svh"
  
endpackage : clock_test_pkg
