#! /usr/bin/env python

import uvmf_gen

## The input to this call is the name of the desired bench and the name of the top 
## environment package
##   BenchClass(<bench_name>,<env_name>,{environmentParameter:value})
ben = uvmf_gen.BenchClass('alu','alu',{})

## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# ben.addParamDef(<name>,<type>,<value>)

## Specify the agents contained in this bench
##   addBfm(<agent_handle_name>,<agent_type_name>,<clock_name>,<reset_name>,<activity>,<{bfmParameter:value})
ben.addBfm('alu_in_agent',   'alu_in',  'clk', 'rst','ACTIVE')
ben.addBfm('alu_out_agent',  'alu_out', 'clk', 'rst','PASSIVE')

## This will prompt the creation of all bench files in their specified
##  locations
## ben.inFactReady = False
ben.create()

