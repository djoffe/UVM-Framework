from uvmf_gen import UserError
import re

class Dumper:

  def __init__(self,generatorObj):
    if (generatorObj.gen_type == 'interface'):
      dumper = InterfaceDumper(generatorObj)
    elif (generatorObj.gen_type == 'environment'):
      dumper = EnvironmentDumper(generatorObj)
      ## Look for any underlying utility component definitions as well
      util_dumpers = []
      for obj in generatorObj.analysisComponentTypes:
        util_dumpers.append(ComponentDumper(obj))
    elif (generatorObj.gen_type == 'bench'):
      dumper = BenchDumper(generatorObj)
    else:
      raise UserError("Dumper - Unknown type "+str(generatorObj.gen_type))
    self.data = dumper.data
    self.util_data = []
    if (generatorObj.gen_type == 'environment'):
      for d in util_dumpers:
        self.util_data.append(d.data)

class BenchDumper:

  def __init__(self,benchObj):
    self.obj = benchObj;
    self.data = dict({'uvmf':dict({'benches':dict({self.obj.name:self.parseBench()})})})

  def parseBench(self):
    data = {}
    data['top_env'] = self.obj.env_name
    data['clock_half_period'] = self.obj.clockHalfPeriod
    data['clock_phase_offset'] = self.obj.clockPhaseOffset
    data['reset_assertion_level'] = str(self.obj.resetAssertionLevel)
    data['use_dpi_link'] = str(self.obj.useDpiLink)
    data['reset_duration'] = self.obj.resetDuration
    if (len(self.obj.paramDefs)):
      data['parameters'] = []
      for i in self.obj.paramDefs:
        data['parameters'].append({'name':i.name,'type':i.type,'value':i.value})
    if (len(self.obj.envParamDefs)):
      data['top_env_params'] = []
      for i in self.obj.envParamDefs:
        data['top_env_params'].append({'name':i.name,'value':i.value})
    data['interface_params'] = []
    data['active_passive'] = []
    for i in self.obj.bfms:
      data['active_passive'].append({'bfm_name':i.name,'value':i.activity})
      if (len(i.parameters)==0):
        ## No parameters on this BFM, skip and move to the next one
        continue
      params = []
      for j in i.parameters:
        params.append({'name':j.name,'value':j.value})
      data['interface_params'].append({'bfm_name':i.name,'value':params})
    if (len(self.obj.external_imports)):
      data['imports'] = []
      for i in self.obj.external_imports:
        data['imports'].append({'name':i})
    if (self.obj.useCoEmuClkRstGen == True):
      data['use_co_emu_clk_rst_gen'] = 'True'
    return data

class EnvironmentDumper:

  def __init__(self,environmentObj):
    self.obj = environmentObj
    self.data = dict({'uvmf':dict({'environments':dict({self.obj.name:self.parseEnvironment()})})})

  def parseEnvironment(self):
    data = {}
    data['qvip_memory_agents'] = []
    for i in self.obj.qvipMemoryAgents:
      params = []
      for p in i.parameters:
        params.append({'name':p.name,'value':p.value})
      data['qvip_memory_agents'].append({'name':i.name,'type':i.type,'qvip_environment':i.qvipEnv,'parameters':params})
    data['non_uvmf_components'] = []
    for i in self.obj.nonUvmfComponents:
      if (len(i.parameters)>0):
        params = []
        for p in i.parameters:
          params.append({'name':p.name,'value':p.value})
        data['non_uvmf_components'].append({'name':i.name,'type':i.type,'parameters':params})
      else:
        data['non_uvmf_components'].append({'name':i.name,'type':i.type})

    data['agents'] = []
    for i in self.obj.agents:
      if (len(i.parameters)>0):
        params = []
        for p in i.parameters:
          params.append({'name':p.name,'value':p.value})
        data['agents'].append({'name':i.name,'type':i.ifPkg,'parameters':params,'initiator_responder':i.initResp})
      else:
        data['agents'].append({'name':i.name,'type':i.ifPkg,'initiator_responder':i.initResp}) 
    data['subenvs'] = []
    for i in self.obj.subEnvironments:
      params = []
      for p in i.parameters:
        params.append({'name':p.name,'value':p.value})
      data['subenvs'].append({'name':i.name,'type':i.envPkg,'parameters':params})
    data['analysis_components'] = []
    for i in self.obj.analysisComponents:
      data['analysis_components'].append({'name':i.name,'type':i.type}) # ,'extdef':'True'})
    data['scoreboards'] = []
    for i in self.obj.scoreboards:
      if (len(i.parameters)>0):
        params = []
        for p in i.parameters:
          params.append({'name':p.name,'value':p.value})
        data['scoreboards'].append({'name':i.name,'sb_type':i.sType,'trans_type':i.tType,'parameters':params})
      else:      
        data['scoreboards'].append({'name':i.name,'sb_type':i.sType,'trans_type':i.tType})
    data['analysis_ports'] = []
    for i in self.obj.analysis_ports:
      data['analysis_ports'].append({'name':i.name,'trans_type':i.tType,'connected_to':i.connection})
    data['analysis_exports'] = []
    for i in self.obj.analysis_exports:
      data['analysis_exports'].append({'name':i.name,'trans_type':i.tType,'connected_to':i.connection})
    data['config_vars'] = []
    for i in self.obj.configVars:
      data['config_vars'].append({'name':i.name,'type':i.type,'isrand':str(i.isrand),'value':str(i.value)})
    data['config_constraints'] = []
    for i in self.obj.configVarsConstraints:
      data['config_constraints'].append({'name':i.name,'value':i.type})
    data['parameters'] = []
    for i in self.obj.paramDefs:
      data['parameters'].append({'name':i.name,'type':i.type,'value':i.value})
    data['hvl_pkg_parameters'] = []
    for i in self.obj.hvlPkgParamDefs:
      data['hvl_pkg_parameters'].append({'name':i.name,'type':i.type,'value':i.value})
    data['tlm_connections'] = []
    for i in self.obj.connections:
      driverHier = i.name;
      driverPort = i.pName;
      receiverHier = i.subscriberName;
      receiverPort = i.aeName;
      data['tlm_connections'].append({'driver':driverHier+"."+driverPort,'receiver':receiverHier+"."+receiverPort})
    if len(self.obj.regModels)>0:
      rm = self.obj.regModels[0]
      if rm.sequencer == None:
        data['register_model'] = { 'use_adapter': str(rm.useAdapter),
                                   'use_explicit_prediction': str(rm.useExplicitPrediction),
                                 }
      else:
        match = re.match(r"(.*)",rm.sequencer)
        ifname = match.group(1)
        data['register_model'] = { 'use_adapter': str(rm.useAdapter),
                                   'use_explicit_prediction': str(rm.useExplicitPrediction),
                                   'maps': [ { 'name': rm.busMap, 'interface': ifname } ]
                                  }
      if self.obj.soName!="":
        data['dpi_define'] = {}
        data['dpi_define']['name'] = self.obj.soName
        data['dpi_define']['comp_args'] = self.obj.DPICompArgs
        data['dpi_define']['link_args'] = self.obj.DPILinkArgs
        data['dpi_define']['files'] = []
        for i in self.obj.DPIFiles:
          data['dpi_define']['files'].append(i)
        if len(self.obj.DPIExports):
          data['dpi_define']['exports'] = self.obj.DPIExports
        if len(self.obj.DPIImports):
          data['dpi_define']['imports'] = []
          for i in self.obj.DPIImports:
            v = {}
            v['name'] = i.name
            v['c_return_type'] = i.cType
            v['sv_return_type'] = i.svType
            v['c_args'] = i.cArgs
            v['sv_args'] = i.arguments
            data['dpi_define']['imports'].append(v)
    if len(self.obj.qvipSubEnvironments):
      data['qvip_subenvs'] = []
      for i in self.obj.qvipSubEnvironments:
        data['qvip_subenvs'].append({'name':i.name,'type':i.envPkg})
    if len(self.obj.qvipConnections):
      data['qvip_connections'] = []
      for i in self.obj.qvipConnections:
        data['qvip_connections'].append({'driver':i.output_component,'ap_key':i.output_port_name,'receiver':i.input_component+"."+i.input_component_export_name})
    if (len(self.obj.external_imports)):
      data['imports'] = []
      for i in self.obj.external_imports:
        data['imports'].append({'name':i})
    if (len(self.obj.typedefs)):
      data['typedefs'] = []
      for i in self.obj.typedefs:
        data['typedefs'].append({'name':i.name,'type':i.type})
    return data

class ComponentDumper:

  def __init__(self,obj):
    self.obj = obj
    self.data = dict({'uvmf':dict({'util_components':dict({self.obj.name:self.parseComponent()})})})

  def parseComponent(self):
    data = {}
    data['type'] = self.obj.keyword
    data['analysis_exports'] = []
    for i in self.obj.analysisExports:
      data['analysis_exports'].append({'name':i.name,'type':i.tType})
    data['analysis_ports'] = []
    for i in self.obj.analysisPorts:
      data['analysis_ports'].append({'name':i.name,'type':i.tType})
    return data

class InterfaceDumper:

  def __init__(self,interfaceObj):
    self.obj = interfaceObj
    self.data = dict({'uvmf':dict({'interfaces':dict({self.obj.name:self.parseInterface()})})})

  def parseInterface(self):
    data = {}
    data['clock'] = str(self.obj.clock)
    data['reset'] = str(self.obj.reset)
    data['reset_assertion_level'] = str(self.obj.resetAssertionLevel)
    data['use_dpi_link'] = str(self.obj.useDpiLink)
    data['hdl_typedefs'] = []
    for i in self.obj.hdlTypedefs:
      data['hdl_typedefs'].append({'name':str(i.name),'type':str(i.type)})
    data['hvl_typedefs'] = []
    for i in self.obj.hvlTypedefs:
      data['hvl_typedefs'].append({'name':str(i.name),'type':str(i.type)})
    data['parameters'] = []
    for i in self.obj.paramDefs:
      data['parameters'].append({'name':str(i.name),'type':str(i.type),'value':str(i.value)})
    data['hdl_pkg_parameters'] = []
    for i in self.obj.hdlPkgParamDefs:
      data['hdl_pkg_parameters'].append({'name':i.name,'type':i.type,'value':i.value})
    data['hvl_pkg_parameters'] = []
    for i in self.obj.hvlPkgParamDefs:
      data['hvl_pkg_parameters'].append({'name':i.name,'type':i.type,'value':i.value})
    data['ports'] = []
    for i in self.obj.ports:
      data['ports'].append({'name':str(i.name),'width':str(i.width),'dir':str(i.dir),'reset_value':str(i.rstValue)})
    data['transaction_vars'] = []
    for i in self.obj.transVars:
      data['transaction_vars'].append({'name':i.name,'type':i.type,'isrand':str(i.isrand),'iscompare':str(i.iscompare),'unpacked_dimension':i.unpackedDim})
    data['transaction_constraints'] = []
    for i in self.obj.transVarsConstraints:
      data['transaction_constraints'].append({'name':i.name,'value':i.type})
    data['config_vars'] = []
    for i in self.obj.configVars:
      data['config_vars'].append({'name':str(i.name),'type':str(i.type),'isrand':str(i.isrand),'value':str(i.value)})
    data['config_constraints'] = []
    for i in self.obj.configVarsConstraints:
      data['config_constraints'].append({'name':i.name,'value':i.type})
    data['response_info'] = {}
    data['response_info']['operation'] = self.obj.responseOperation
    data['response_info']['data'] = []
    for i in self.obj.responseList:
      data['response_info']['data'].append(i['name'])
    if self.obj.soName != "":
      data['dpi_define'] = {}
      data['dpi_define']['name'] = self.obj.soName
      data['dpi_define']['comp_args'] = self.obj.DPICompArgs
      data['dpi_define']['link_args'] = self.obj.DPILinkArgs
      data['dpi_define']['files'] = []
      for i in self.obj.DPIFiles:
        data['dpi_define']['files'].append(i)
      if len(self.obj.DPIExports):
        data['dpi_define']['exports'] = self.obj.DPIExports
      if len(self.obj.DPIImports):
        data['dpi_define']['imports'] = []
        for i in self.obj.DPIImports:
          v = {}
          v['name'] = i.name
          v['sv_return_type'] = i.svType
          v['c_return_type'] = i.cType
          v['c_args'] = i.cArgs
          v['sv_args'] = i.arguments
          data['dpi_define']['imports'].append(v)
    if (len(self.obj.external_imports)):
      data['imports'] = []
      for i in self.obj.external_imports:
        data['imports'].append({'name':i})
    return data

import yaml

class YAMLGenerator:
  def __init__(self,data,outfilename):
    with open(outfilename,'w') as outfile:
      yaml.dump(data,outfile,default_flow_style=False)


