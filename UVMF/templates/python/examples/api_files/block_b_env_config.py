#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('block_b')

## Specify DPI information
env.setDPISOName('blockBEnvPkgCFunctions',compArgs='-c -DPRINT32 -O2',linkArgs='-shared')
env.addDPIFile('myFirstFile.c')
env.addDPIFile('mySecondFile.c')
env.addDPIImport('void','void', 'hello_world_from_environment','(unsigned int variable1, unsigned int variable2)',
               [{'name':'variable1',
                 'type':'int unsigned',
                 'dir':'input'},
                {'name':'variable2',
                 'type':'int unsigned',
                 'dir':'input'}])
env.addDPIImport('void','void', 'good_bye_world_from_environment','(unsigned int variable3, unsigned int variable4)',
               [{'name':'variable3',
                 'type':'int unsigned',
                 'dir':'input'},
                {'name':'variable4',
                 'type':'int unsigned',
                 'dir':'input'}])

## Specify parameters for this environment.
# addParamDef(<name>,<type>,<value>)
env.addParamDef('CP_IN_DATA_WIDTH','int','120')
env.addParamDef('CP_IN_ADDR_WIDTH','int','110')
env.addParamDef('CP_OUT_ADDR_WIDTH','int','111')
env.addParamDef('UDP_DATA_WIDTH','int','140')

## Specify parameters that will be included in the environment package declaration
env.addHvlPkgParamDef('ENV_HVL_PKG_PARAMETER1','integer','92')
env.addHvlPkgParamDef('ENV_HVL_PKG_PARAMETER2','integer','29')

# addRegisterModel(   sequencer,                    transactionType,                                                                   adapterType,                                                                     busMap,  useAdapter=True, useExplicitPrediction=True)
env.addRegisterModel('control_plane_in', 'mem_transaction#(.ADDR_WIDTH(CP_IN_ADDR_WIDTH),.DATA_WIDTH(CP_IN_DATA_WIDTH))' , 'mem2reg_adapter#(.ADDR_WIDTH(CP_IN_ADDR_WIDTH),.DATA_WIDTH(CP_IN_DATA_WIDTH))', 'bus_map',useAdapter=True,useExplicitPrediction=True)

## Specify the agents contained in this environment
##   addAgent(<agent_handle_name>,<agent_package_name>,<clock_name>,<reset_name>,<{interfaceParameter1:value1,interfaceParameter2:value2}>, initResp = 'RESPONDER')
# Note: the agent_package_name will have _pkg appended to it.
env.addAgent('control_plane_in',       'mem', 'clock', 'reset',{'ADDR_WIDTH':'CP_IN_ADDR_WIDTH','DATA_WIDTH':'CP_IN_DATA_WIDTH'})
env.addAgent('control_plane_out',      'mem', 'clock', 'reset',{'ADDR_WIDTH':'CP_OUT_ADDR_WIDTH'})
env.addAgent('unsecure_data_plane_in', 'pkt', 'pclk', 'prst',{'DATA_WIDTH':'UDP_DATA_WIDTH'})
env.addAgent('unsecure_data_plane_out','pkt', 'pclk', 'prst')

## Define the predictors contained in this environment (not instantiate, yet)
## addAnalysisComponent(<keyword>,<predictor_type_name>,<dict_of_exports>,<dict_of_ports>) - 
## List any parameters of the transaction when listing the transaction.
## doing this will add the requested analysis component to the list, enabling the use of the given template (identified by <keyword>)
env.defineAnalysisComponent('predictor','control_plane_predictor',{'control_plane_in_ae':'mem_transaction #(.ADDR_WIDTH(CP_IN_ADDR_WIDTH),.DATA_WIDTH(CP_IN_DATA_WIDTH))'},
                                                                  {'control_plane_sb_ap':'mem_transaction #(.ADDR_WIDTH(CP_OUT_ADDR_WIDTH))'})
env.defineAnalysisComponent('predictor','unsecure_data_plane_predictor',{'control_plane_in_ae':'mem_transaction #(.ADDR_WIDTH(CP_IN_ADDR_WIDTH),.DATA_WIDTH(CP_IN_DATA_WIDTH))',
                                                                         'unsecure_data_plane_in_ae':'pkt_transaction #(.DATA_WIDTH(UDP_DATA_WIDTH))'},
                                                                        {'unsecure_data_plane_sb_ap':'pkt_transaction'})

## Instantiate the components in this environment
## addAnalysisComponent(<name>,<type>)
env.addAnalysisComponent('control_plane_pred','control_plane_predictor')
env.addAnalysisComponent('unsecure_data_plane_pred','unsecure_data_plane_predictor')

## Specify the scoreboards contained in this environment
## addUvmfScoreboard(<scoreboard_handle_name>, <uvmf_scoreboard_type_name>, <transaction_type_name>)
env.addUvmfScoreboard('control_plane_sb','uvmf_in_order_race_scoreboard','mem_transaction #(.ADDR_WIDTH(CP_OUT_ADDR_WIDTH))')
env.addUvmfScoreboard('unsecure_data_plane_sb', 'uvmf_in_order_race_scoreboard','pkt_transaction')

## Specify the connections in the environment
## addConnection(<output_component>, < output_port_name>, <input_component>, <input_component_export_name>)
## Connection 00
env.addConnection('control_plane_in', 'monitored_ap', 'control_plane_pred', 'control_plane_in_ae')
## Connection 01
env.addConnection('control_plane_in', 'monitored_ap', 'unsecure_data_plane_pred', 'control_plane_in_ae')
## Connection 02
env.addConnection('unsecure_data_plane_in', 'monitored_ap', 'unsecure_data_plane_pred', 'unsecure_data_plane_in_ae')
## Connection 03
env.addConnection('control_plane_pred', 'control_plane_sb_ap', 'control_plane_sb', 'expected_analysis_export')
## Connection 04
env.addConnection('unsecure_data_plane_pred', 'unsecure_data_plane_sb_ap', 'unsecure_data_plane_sb', 'expected_analysis_export')
## Connection 05
env.addConnection('control_plane_out','monitored_ap',  'control_plane_sb', 'actual_analysis_export')
## Connection 06
env.addConnection('unsecure_data_plane_out', 'monitored_ap', 'unsecure_data_plane_sb', 'actual_analysis_export')

## Specify configuration variables for the interface.
##   addConfigVar(<name>,<type>)
##     optionally can specify if this variable may be specified as 'rand'
env.addConfigVar('block_b_cfgVar1','bit',isrand=False)
env.addConfigVar('block_b_cfgVar3','bit [3:0]',isrand=True)
env.addConfigVar('block_b_cfgVar4','int',isrand=True)
env.addConfigVar('block_b_cfgVar5','int',isrand=True)

## Specify configuration variable constraint
## addConfigVarConstraint(<constraint_body_name>,<constraint_body_definition>)
env.addConfigVarConstraint('element_range_c','{ block_b_cfgVar4>block_b_cfgVar5; }')
env.addConfigVarConstraint('non_negative_c','{ (block_b_cfgVar1==0) -> block_b_cfgVar4==0;}')

env.create() 

