#! /usr/bin/env python

import uvmf_gen


## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>)
ben = uvmf_gen.BenchClass('block_c','block_c',{})

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# ben.addParamDef(<name>,<type>,<value>)

# Load shared objects from pkt_pkg C functions and block_b_env_pkg C functions
ben.addDPILibName('pktPkgCFunctions')

## Specify clock and reset details
ben.clockHalfPeriod = '6ns'
ben.clockPhaseOffset = '21ns'
ben.resetAssertionLevel = True
ben.resetDuration = '250ns'

## Import QVIP protocol packages so that the test bench can use sequence items and sequences from QVIP library.
ben.addImport('mvc_pkg')
ben.addImport('mgc_pcie_v2_0_pkg')
ben.addImport('mgc_axi4_v1_0_pkg')
ben.addImport('mgc_apb3_v1_0_pkg')


## The addQvipBfm() lines below were copied from comments in the QVIP Configurator generated package named qvip_agents_pkg.sv.
## qvip sub environment agents
##   addQvipBfm(<protocol agent name>,<qvip_sub_env_package_name>,<activity>)
ben.addQvipBfm('pcie_ep', 'qvip_agents', 'ACTIVE',           unique_id='uvm_test_top.environment.qvip_env.')
ben.addQvipBfm('axi4_master_0', 'qvip_agents', 'ACTIVE',     unique_id='uvm_test_top.environment.qvip_env.')
ben.addQvipBfm('axi4_master_1', 'qvip_agents', 'ACTIVE',     unique_id='uvm_test_top.environment.qvip_env.')
ben.addQvipBfm('axi4_slave', 'qvip_agents', 'ACTIVE',        unique_id='uvm_test_top.environment.qvip_env.')
ben.addQvipBfm('apb3_config_master', 'qvip_agents', 'ACTIVE',unique_id='uvm_test_top.environment.qvip_env.')

## Specify the agents contained in this bench
##   addBfm(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>)
ben.addBfm('mem_in',  'mem', 'clock', 'reset', 'ACTIVE',agentInstName='mem_in')
ben.addBfm('mem_out', 'mem', 'clock', 'reset', 'ACTIVE',agentInstName='mem_out')
ben.addBfm('pkt_out', 'pkt', 'pclk', 'prst', 'ACTIVE',agentInstName='pkt_out')

# This API identifies make targets that compile C code.
# Compilation of c code is needed as a dependency for using the VINFO flow
ben.addVinfoDependency('comp_pkt_pkg_c_files')

# Identify scoreboards to be disabled during register test
ben.addScoreboard("environment.mem_sb")
ben.addScoreboard("environment.pkt_sb")
ben.addScoreboard("environment.axi4_slave_sb")
ben.addScoreboard("environment.apb3_cfg_sb")

## This will prompt the creation of all bench files in their specified
##  locations
ben.create()
