#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>,{environmentParameter:value})
ben = uvmf_gen.BenchClass('block_a','block_a',{})

# Load shared objects from pkt_pkg C functions
ben.addDPILibName('pktPkgCFunctions')

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# ben.addParamDef(<name>,<type>,<value>)

## Specify clock and reset details
ben.clockHalfPeriod = '6ns'
ben.clockPhaseOffset = '21ns'
ben.resetAssertionLevel = True
ben.resetDuration = '250ns'

## Specify the agents contained in this bench
##   addBfm(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>,<{bfmParameter:value})
ben.addBfm('control_plane_in',      'mem',  'clock', 'reset','ACTIVE')
ben.addBfm('control_plane_out',     'mem',  'clock', 'reset','ACTIVE')
ben.addBfm('secure_data_plane_in',  'pkt',  'pclk',  'prst', 'ACTIVE')
ben.addBfm('secure_data_plane_out', 'pkt',  'pclk',  'prst', 'ACTIVE')
## ben.addBfm('dma',                   'dma',  'clock', 'reset','ACTIVE', initResp = 'RESPONDER')

## This will prompt the creation of all bench files in their specified
##  locations
## ben.inFactReady = False
ben.create()

