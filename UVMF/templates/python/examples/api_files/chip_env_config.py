#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('chip')

env.addParamDef('CHIP_CP_IN_DATA_WIDTH','int','20')
env.addParamDef('CHIP_CP_IN_ADDR_WIDTH','int','10')
env.addParamDef('CHIP_CP_OUT_ADDR_WIDTH','int','25')
env.addParamDef('CHIP_UDP_DATA_WIDTH','int','40')

# The sequencer, transaction type, adapter type, and bus mapping are all null since this env only contains sub environments
# addRegisterModel(   sequencer,  transactionType,  adapterType,  busMap, useAdapter=True, useExplicitPrediction=True)
env.addRegisterModel(None,        None ,             None,        None,   useAdapter=False,useExplicitPrediction=False)

##   addSubEnv(<sub_env_handle_name>,<sub_env_package_name>,<number_of_agents_in_the_sub_env>)
# This chip level env does not use the block level register model associated with block a
env.addSubEnv('block_a_env', 'block_a', 4,{})

#addSubEnv(    name,          envPkg,   numAgents,parametersDict={}, regSubBlock='null',regSubBlockType='null',regSubBlockPkg='null'):
env.addSubEnv('block_b_env', 'block_b', 4, {'CP_IN_DATA_WIDTH':'CHIP_CP_IN_DATA_WIDTH',
                                            'CP_IN_ADDR_WIDTH':'CHIP_CP_IN_ADDR_WIDTH',
					    					'CP_OUT_ADDR_WIDTH':'CHIP_CP_OUT_ADDR_WIDTH',
					  					    'UDP_DATA_WIDTH':'CHIP_UDP_DATA_WIDTH'},'block_b_rm')

env.create() 

