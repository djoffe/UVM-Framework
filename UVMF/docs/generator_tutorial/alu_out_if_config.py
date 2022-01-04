#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('alu_out')

## Disable generation of InFact specific files [required for 3.6f only]
intf.inFactReady = False

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# addHdlParamDef(<name>,<type>,<value>)
intf.addParamDef('ALU_OUT_RESULT_WIDTH','int','16')

## Specify the clock and reset signal for the interface
intf.clock = 'clk'
intf.reset = 'rst'
intf.resetAssertionLevel = False

## Specify the ports associated with this interface.
## The direction is from the perspective of the test bench as an INITIATOR on the bus.
##   addPort(<name>,<width>,[input|output|inout])
intf.addPort('done',1,'input')
intf.addPort('result','ALU_OUT_RESULT_WIDTH','input')

## Specify typedef for inclusion in typedefs_hdl file
# addHdlTypedef(<name>,<type>)
# intf.addHdlTypedef('result_t','bit [ALU_OUT_RESULT_WIDTH-1:0]')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
##     optionally can specify if this variable may be specified as used in do_compare()
intf.addTransVar('result','bit [ALU_OUT_RESULT_WIDTH-1:0]',isrand=False,iscompare=True)

## Specify transaction variable constraint
## addTransVarConstraint(<constraint_body_name>,<constraint_body_definition>)
##intf.addTransVarConstraint('valid_op_c','{ op inside {no_op, add_op, and_op, xor_op, mul_op, rst_op}; }')

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
##intf.addConfigVar('error_mode','bit',isrand=False)
##intf.addConfigVar('src_address','bit [DATA_WIDTH-1:0]',isrand=True)

## Specify configuration variable constraint
## addConfigVarConstraint(<constraint_body_name>,<constraint_body_definition>)
##intf.addConfigVarConstraint('valid_dst_c','{ src_address inside {[63:16], 1025}; }')

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
