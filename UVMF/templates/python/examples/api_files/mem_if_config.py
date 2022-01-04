#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired interface
intf = uvmf_gen.InterfaceClass('mem')

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
## These parameters become class and interface parameters
# addHdlParamDef(<name>,<type>,<value>)
intf.addParamDef('DATA_WIDTH','int','220')
intf.addParamDef('ADDR_WIDTH','int','210')

## Specify parameters that will be included in the hvl package declaration
intf.addHvlPkgParamDef('MEM_HVL_PKG_PARAMETER1','integer','21')
intf.addHvlPkgParamDef('MEM_HVL_PKG_PARAMETER2','integer','22')

## Specify parameters that will be included in the hdl package declaration
intf.addHdlPkgParamDef('MEM_HDL_PKG_PARAMETER1','byte','27')
intf.addHdlPkgParamDef('MEM_HDL_PKG_PARAMETER2','byte','28')



## Specify the clock and reset signal for the interface
intf.clock = 'clock'
intf.reset = 'reset'
intf.resetAssertionLevel = True

## Specify the ports associated with this interface.
## The direction is from the perspective of the test bench as an INITIATOR on the bus.
##   addPort(<name>,<width>,[input|output|inout],rstValue)
intf.addPort('cs',1,'output','1\'b0')
intf.addPort('rwn',1,'output','1\'b1')
intf.addPort('rdy',1,'input','1\'b0')
intf.addPort('addr','ADDR_WIDTH','output','\'bz')
intf.addPort('wdata','DATA_WIDTH','output','\'bz')
intf.addPort('rdata','DATA_WIDTH','input')

## Specify typedef for inclusion in typedefs_hdl file
# addHdlTypedef(<name>,<type>)
intf.addHdlTypedef('my_byte_t','byte')
intf.addHdlTypedef('my_word_t','bit [15:0] ')

## Specify typedef for inclusion in typedefs file
# addHvlTypedef(<name>,<type>)
intf.addHvlTypedef('my_object_t','uvm_object')

## Specify transaction variables for the interface.
##   addTransVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
##     optionally can specify if this variable may be specified as used in do_compare()
intf.addTransVar('read_data','bit [DATA_WIDTH-1:0]',isrand=False,iscompare=True)
intf.addTransVar('write_data','bit [DATA_WIDTH-1:0]',isrand=False,iscompare=True)
intf.addTransVar('address','bit [ADDR_WIDTH-1:0]',isrand=True,iscompare=True)
intf.addTransVar('byte_enable','bit [3:0]',isrand=True,iscompare=False)
intf.addTransVar('chksum','int',isrand=False,iscompare=False)

intf.specifyResponseOperation('1\'b1')
intf.specifyResponseData(['read_data'])

## Specify transaction variable constraint
## addTransVarConstraint(<constraint_body_name>,<constraint_body_definition>)
# intf.addTransVarConstraint('valid_address_range_c','{ address inside {[2048:1055], [1024:555], [511:0]}; }')
intf.addTransVarConstraint('address_word_align_c','{ address[1:0]==0; }')

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
intf.addConfigVar('transfer_gap','bit [3:0]',isrand=True)
intf.addConfigVar('speed_grade','bit [3:0]',isrand=False, value='35')

## Specify configuration variable constraint
## addConfigVarConstraint(<constraint_body_name>,<constraint_body_definition>)
intf.addConfigVarConstraint('valid_packet_gap_range_c','{ transfer_gap inside {0, 2, 4, 8, 15}; }')

## This will prompt the creation of all interface files in their specified
##  locations
intf.create()
