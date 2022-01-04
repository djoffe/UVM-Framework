#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>,{environmentParameter:value})
ben = uvmf_gen.BenchClass('block_b','block_b', {'CP_IN_DATA_WIDTH': 'TEST_CP_IN_DATA_WIDTH',
                                                'CP_IN_ADDR_WIDTH': 'TEST_CP_IN_ADDR_WIDTH',
                                                'CP_OUT_ADDR_WIDTH': 'TEST_CP_OUT_ADDR_WIDTH',
                                                'UDP_DATA_WIDTH': 'TEST_UDP_DATA_WIDTH'})

# Load shared objects from pkt_pkg C functions and block_b_env_pkg C functions
ben.addDPILibName('pktPkgCFunctions')
ben.addDPILibName('blockBEnvPkgCFunctions')

# Let bench know that top-env underneath has a register model
ben.topEnvHasRegisterModel = True

## Add external imports to hdl_top, test package and top level sequence package.
# ben.addImport('myImport')

## Specify parameters for this bench.
## These parameters can be used when defining signal and variable sizes.
# ben.addParamDef(<name>,<type>,<value>)
ben.addParamDef('TEST_CP_IN_DATA_WIDTH','int','20')
ben.addParamDef('TEST_CP_IN_ADDR_WIDTH','int','10')
ben.addParamDef('TEST_CP_OUT_ADDR_WIDTH','int','21')
ben.addParamDef('TEST_UDP_DATA_WIDTH','int','40')

## Specify clock and reset details
ben.clockHalfPeriod = '6ns'
ben.clockPhaseOffset = '21ns'
ben.resetAssertionLevel = True
ben.resetDuration = '250ns'

## Specify the agents contained in this bench
##   addBfm(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>,<{bfmParameter:value})
ben.addBfm('control_plane_in',       'mem', 'clock', 'reset','ACTIVE', {'ADDR_WIDTH':'TEST_CP_IN_ADDR_WIDTH','DATA_WIDTH':'TEST_CP_IN_DATA_WIDTH'}, agentInstName="control_plane_in")
ben.addBfm('control_plane_out',      'mem', 'clock', 'reset','ACTIVE', {'ADDR_WIDTH':'TEST_CP_OUT_ADDR_WIDTH'}, agentInstName="control_plane_out")
ben.addBfm('unsecure_data_plane_in', 'pkt', 'pclk', 'prst','ACTIVE',   {'DATA_WIDTH':'TEST_UDP_DATA_WIDTH'}, agentInstName="unsecure_data_plane_in")
ben.addBfm('unsecure_data_plane_out','pkt', 'pclk', 'prst','ACTIVE', agentInstName="unsecure_data_plane_out")

# This API identifies make targets that compile C code.
# Compilation of c code is needed as a dependency for using the VINFO flow
ben.addVinfoDependency('comp_pkt_pkg_c_files')
ben.addVinfoDependency('comp_block_b_env_pkg_c_files')

# Identify scoreboards to disable during register test
ben.addScoreboard("environment.control_plane_sb")
ben.addScoreboard("environment.unsecure_data_plane_sb")


## This will prompt the creation of all bench files in their specified
##  locations
## ben.useCoEmuClkRstGen = True
ben.create()
