#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('alu')


## Specify parameters for this interface package.
## These parameters can be used when defining signal and variable sizes.
# addParamDef(<name>,<type>,<value>)


## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>,<{interfaceParameter1:value1,interfaceParameter2:value2}>, initResp = 'RESPONDER')
# Note: the agent_package_name will have _pkg appended to it.
env.addAgent('alu_in_agent',  'alu_in',   'clk', 'rst')
env.addAgent('alu_out_agent', 'alu_out',  'clk', 'rst')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## If the transaction types are parameterized and the default parameter values are desired then
## the #() is required as part of defining the transaction type used by the analysis component.
## doing this will add the requested analysis component to the list, enabling the use of the 
## given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','alu_predictor',{'alu_in_agent_ae':'alu_in_transaction #()'},
                                                        {'alu_sb_ap':'alu_out_transaction #()'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('alu_pred','alu_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('alu_sb','uvmf_in_order_scoreboard','alu_out_transaction')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
## Connection 00
env.addConnection('alu_in_agent', 'monitored_ap', 'alu_pred', 'alu_in_agent_ae')
## Connection 01
env.addConnection('alu_pred', 'alu_sb_ap', 'alu_sb', 'expected_analysis_export')
## Connection 02
env.addConnection('alu_out_agent', 'monitored_ap', 'alu_sb', 'actual_analysis_export')



## Specify configuration variables for the environment.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
#env.addConfigVar('block_a_cfgVar1','bit',isrand=False)
#env.addConfigVar('block_a_cfgVar3','bit [3:0]',isrand=True)
#env.addConfigVar('block_a_cfgVar4','int',isrand=True)
#env.addConfigVar('block_a_cfgVar5','int',isrand=True)

## Specify configuration variable constraint
## addConfigVarConstraint(<constraint_body_name>,<constraint_body_definition>)
##env.addConfigVarConstraint('element_range_c','{ block_a_cfgVar4>block_a_cfgVar5; }')
##env.addConfigVarConstraint('non_negative_c','{ (block_a_cfgVar1==0) -> block_a_cfgVar4==0;}')

env.create() 
