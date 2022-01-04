#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>,{envParameter:value})
ben = uvmf_gen.BenchClass('chip','chip', {'CHIP_CP_IN_DATA_WIDTH':'TEST_CP_IN_DATA_WIDTH',
                                          'CHIP_CP_IN_ADDR_WIDTH':'TEST_CP_IN_ADDR_WIDTH',
                                          'CHIP_CP_OUT_ADDR_WIDTH':'TEST_CP_OUT_ADDR_WIDTH',
                                          'CHIP_UDP_DATA_WIDTH':'TEST_UDP_DATA_WIDTH'})


# Load shared objects from pkt_pkg C functions and block_b_env_pkg C functions
ben.addDPILibName('pktPkgCFunctions')
ben.addDPILibName('blockBEnvPkgCFunctions')

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# ben.addParamDef(<name>,<type>,<value>)
ben.addParamDef('TEST_CP_IN_DATA_WIDTH','int','28')
ben.addParamDef('TEST_CP_IN_ADDR_WIDTH','int','37')
ben.addParamDef('TEST_CP_OUT_ADDR_WIDTH','int','37')
ben.addParamDef('TEST_UDP_DATA_WIDTH','int','28')

## Specify clock and reset details
ben.clockHalfPeriod = '6ns'
ben.clockPhaseOffset = '21ns'
ben.resetAssertionLevel = True
ben.resetDuration = '250ns'

# Let bench know that top-env underneath has a register model
ben.topEnvHasRegisterModel = True

## Specify the BFM's contained in this bench
##   addAgent(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>,<{bfmParameter:value},<pathToSubEnvironmentsForTransactionViewing>)

## block a environment BFM's in the same order listed in block a config file
ben.addBfm('block_a_env_control_plane_in',      'mem', 'clock', 'reset','ACTIVE', {},'environment.block_a_env', agentInstName="control_plane_in")
ben.addBfm('block_a_env_control_plane_out',     'mem', 'clock', 'reset','PASSIVE', {},'environment.block_a_env', agentInstName="control_plane_out")
ben.addBfm('block_a_env_secure_data_plane_in',  'pkt', 'pclk', 'prst','ACTIVE',   {},'environment.block_a_env', agentInstName="secure_data_plane_in")
ben.addBfm('block_a_env_secure_data_plane_out', 'pkt', 'pclk', 'prst', 'ACTIVE', {},'environment.block_a_env',  initResp = 'RESPONDER', agentInstName="secure_data_plane_out")

## block b environment BFM's in the same order listed in block b config file
ben.addBfm('block_b_env_control_plane_in',       'mem', 'clock', 'reset','PASSIVE',{'ADDR_WIDTH':'TEST_CP_IN_ADDR_WIDTH','DATA_WIDTH':'TEST_CP_IN_DATA_WIDTH'},'environment.block_b_env', agentInstName="control_plane_in")
ben.addBfm('block_b_env_control_plane_out',      'mem', 'clock', 'reset','ACTIVE',{'ADDR_WIDTH':'TEST_CP_OUT_ADDR_WIDTH'},'environment.block_b_env', agentInstName="control_plane_out")
ben.addBfm('block_b_env_unsecure_data_plane_in', 'pkt', 'pclk', 'prst','ACTIVE',{'DATA_WIDTH':'TEST_UDP_DATA_WIDTH'},'environment.block_b_env', agentInstName="unsecure_data_plane_in")
ben.addBfm('block_b_env_unsecure_data_plane_out','pkt', 'pclk', 'prst','ACTIVE',{},'environment.block_b_env', agentInstName="unsecure_data_plane_out")

# This API identifies make targets that compile C code.
# Compilation of c code is needed as a dependency for using the VINFO flow
ben.addVinfoDependency('comp_pkt_pkg_c_files')
ben.addVinfoDependency('comp_block_b_env_pkg_c_files')

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()

