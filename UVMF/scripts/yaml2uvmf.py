#! /usr/bin/env python

##############################################################################
## Copyright 2017 Mentor Graphics
## All Rights Reserved Worldwide
##
##   Licensed under the Apache License, Version 2.0 (the "License"); you may
##   not use this file except in compliance with the License.  You may obtain
##   a copy of the License at
##
##    http://www.apache.org/license/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in
##   writing, software distributed under the License is
##   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
##   CONDITIONS OF ANY KIND, either express or implied.  See
##   the License for the specific language governing
##   permissions and limitations under the License.
##
##############################################################################
##
##   Mentor Graphics Inc
##
##############################################################################
##
##   Created by :    Jon Craft & Bob Oden
##   Creation date : April 12 2015
##
##############################################################################
##
##   This module facilitates the creation of UVMF interface packages, 
##   environment packages and testbench packages through the use of Jinja2-
##   based template files.  
##
##   See templates.README for more information on usage
##
##############################################################################

import os
import time
import re
import inspect
import sys
from optparse import OptionParser
from fnmatch import fnmatch
from uvmf_yaml import  *
import uvmf_gen
from uvmf_gen import (UVMFCommandLineParser,PassThroughOptionParser,UserError,InterfaceClass,EnvironmentClass,BenchClass)
from voluptuous import MultipleInvalid
from voluptuous.humanize import humanize_error

__version__ = '0.9'

try:
  import yaml
except ImportError,e:
  print "ERROR : yaml package not found.  See templates.README for more information"
  sys.exit(1)


class ConfigFileReader:
  """Reads in a .f file and builds up array of files to parse"""
  def __init__(self,fname):
    self.fname = fname
    self.files = []
    try: 
      self.fh = open(fname,'r')
    except IOError:
      raise UserError("Unable to open -f file "+fname)
    self.lines = self.fh.readlines()
    for line in self.lines:
      line = re.sub(r"(.*)#.*",r"\1",line.rstrip())
      if (line != ""):
        self.files.append(line)
    self.fh.close()

class DataClass:
  def __init__(self,parser,debug=False):
    self.data = {'interfaces':{},'environments':{},'benches':{},'util_components':{},'qvip_environments':{}}
    self.parser = parser
    self.debug = debug
    self.validators = {}

  def parseFile(self,fname):
    try:
      fs = open(fname)
    except IOError:
      raise UserError("Unable to open config file "+fname)
    d = yaml.safe_load(fs)
    fs.close()
    try:
      if 'uvmf' not in d.keys():
        raise UserError("Contents of "+fname+" not valid UVMF info")
    except:
      raise UserError("Contents of "+fname+" not valid UVMF info")
    for elem in self.data.keys():
      try: self.data[elem].update(d['uvmf'][elem])
      except KeyError:
        pass

  def validate(self):
    self.validators = {
      'interfaces':InterfaceValidator(),
      'util_components':ComponentValidator(),
      'qvip_environments':QVIPEnvValidator(),
      'environments':EnvironmentValidator(),
      'benches':BenchValidator()
    }
    for t in self.validators.keys():
      for c in self.data[t].keys():
        try:
          self.validators[t].schema(self.data[t][c])
        except MultipleInvalid as e:
           raise UserError("While validating "+t+" YAML '"+c+"', "+humanize_error(self.data[t][c],e))

  def buildElements(self,genarray):
    self.interfaceDict = {}
    try:
      arrlen = len(genarray)
    except TypeError:
      arrlen = 0
      pass
    for interface_name in self.data['interfaces']:
      if (((arrlen>0) and (interface_name in genarray)) or arrlen==0):
        self.interfaceDict[interface_name] = self.generateInterface(interface_name)
    self.environmentDict = {}
    for environment_name in self.data['environments']:
      if (((arrlen>0) and (environment_name in genarray)) or arrlen==0):
        self.environmentDict[environment_name] = self.generateEnvironment(environment_name)
    self.benchDict = {}
    for bench_name in self.data['benches']:
      if (((arrlen>0) and (bench_name in genarray)) or arrlen==0):
        self.benchDict[bench_name] = self.generateBench(bench_name)

  ## This method recursively searches all environments from the specified level down for QVIP subenvs, compiling
  ## a list of underlying QVIP agents, their subenvironment parent names and active/passive info
  def getQVIPAgents(self,topEnv):
    struct = self.data['environments']
    try:
      env = struct[topEnv]
    except KeyError:
      raise UserError("Unable to find environment \""+topEnv+"\" in defined environments (availalbe list is "+str(struct.keys()))
    agent_list = []
    ## First look for any local QVIP subenvironments and extract those agent names
    try:
      qvip_subenv_list = env['qvip_subenvs']
    except KeyError:
      qvip_subenv_list = []
      pass
    for s in qvip_subenv_list:
      try:
        d = self.data['qvip_environments'][s['type']]
      except KeyError:
        raise UserError("Definition for QVIP subenvironment \""+s['name']+"\" of type \""+s['type']+"\" is not found")
      local_agents = d['agents']
      for a in local_agents:
        try:
          active_passive = a['active_passive']
        except KeyError:
          active_passive = 'ACTIVE'
        agent_list = agent_list + [{ 'name': a['name'], 'parent': s['type'], 'active_passive': active_passive }]
    ## Next drill down and call getQVIPAgents on any non-QVIP subenvironments
    try:
      subenv_list = struct['subenvs']
    except KeyError:
      subenv_list = []
      pass
    for s in subenv_list:
      agent_list = agent_list + self.getQVIPAgents(s['type'])
    return agent_list

  ## This method will return a list of environments at the provided environment level or recursively.
  def getEnvironments(self,topEnv,recursive=True):
    struct = self.data['environments']
    try:
      env = struct[topEnv]
    except KeyError:
      raise UserError("Unable to find environment \""+topEnv+"\" in defined environments (available list is "+str(struct.keys()))
    envs = []
    try:
      envs = env['subenvs']
    except KeyError: pass
    if recursive==False:
      return envs
    for subenv in envs:
      envs = envs + self.getEnvironments(subenv['type'],recursive=True)
    return envs

  ## This method can be employed to return either a list of (non-QVIP) agents at the provided environment
  ## level or recursively, searching through all sub-environments and down. 
  def getAgents(self,topEnv,recursive=True,givePath=False,parentPath=[]):
    struct = self.data['environments']
    try:
      env = struct[topEnv]
    except KeyError:
      raise UserError("Unable to find environment \""+topEnv+"\" in defined environments (available list is "+str(struct.keys()))
    agents = []
    try:
      agents = env['agents']
    except:
      agents = []
      pass
    if (givePath==False):
      structure = agents
    else:
      structure = []
      for agent in agents:
        structure = structure + [{ 'envpath' : parentPath, 'agent' : agent }]
    if (recursive==False):
      return structure
    try:
      subEnvs = env['subenvs']
      for subEnv in subEnvs:
        structure = structure + self.getAgents(subEnv['type'],recursive=True,givePath=givePath,parentPath=parentPath+[subEnv['name']])
    except KeyError: pass
    return structure

  def dataExtract(self,keys,dictionary):
    ret = []
    for key in keys:
      ret = ret + [dictionary[key]]
    return ret

  def generateEnvironment(self,name):
    env = EnvironmentClass(name)
    struct = self.data['environments'][name]
    ## Extract any environment-level parameters and add them
    try:
      for param in struct['parameters']:
        pname,ptype,pval = self.dataExtract(['name','type','value'],param)
        env.addParamDef(pname,ptype,pval)
    except KeyError: pass
    ## Drill down into any QVIP subenvironments for import information, that'll be needed here
    try:
      s = struct['qvip_subenvs']
    except KeyError:
      s = []
      pass
    for e in s:
      try:
        d = self.data['qvip_environments'][e['type']]
      except KeyError:
        raise UserError("QVIP subenvironment \""+e['name']+"\" of type \""+e['type']+"\" is not defined anywhere")
      try:
        for i in d['imports']:
          env.addImport(i['name'])
      except KeyError: pass
    ## Call out any locally defined imports
    try:
      for imp in struct['imports']:
        env.addImport(imp['name'])
    except KeyError: pass
    ## If imp-decl macros are needed, add them
    try:
      for impdecl in struct ['imp_decls']:
        env.addImpDecl(impdecl['name'])
    except KeyError: pass
    ## Look for defined sub-environments and add them
    try:
      for subenv in struct['subenvs']:
        ename,etype = self.dataExtract(['name','type'],subenv)
        try:
          eparams_array = subenv['parameters']
        except KeyError:
          eparams_array = {}
          pass
        eparams = {}
        num = 0
        for item in eparams_array:
          n,v = self.dataExtract(['name','value'],item)
          eparams[n] = v
          num += 1
        ## Determine how many agents are defined in the subenvironment as that is a required argument going into 
        ## this API call.  This is a recursive count of agents.
        agents = self.getAgents(etype,recursive=True)
        if (agents==None):
          raise UserError("Sub-environment type \""+etype+"\" used in environment \""+name+"\" is not found")
        ## Check if subenv has a register model defined unless asked explicitly to avoid it
        try:
          v = subenv['use_register_model']=='True'
        except KeyError:
          v = True
          pass
        if v==True:
          env_def = self.data['environments'][etype]
          try:
            rm = env_def['register_model']
          except KeyError:
            rm = None
            pass
        else:
          rm = None
        if rm == None:
          rm_name = None
        else:
          rm_name = etype+'_rm'
        env.addSubEnv(ename,etype,len(agents),eparams,rm_name)  
    except KeyError: pass
    ## Do the same for QVIP sub-environments
    try:
      for subenv in struct['qvip_subenvs']:
        n,t = self.dataExtract(['name','type'],subenv)
        try:
          qvipStruct = self.data['qvip_environments'][t]
        except KeyError:
          raise UserError("QVIP environment \""+t+"\" in environment \""+name+"\" is not defined")
        alist = []
        for a in qvipStruct['agents']:
          alist = alist + [a['name']]
        env.addQvipSubEnv(n,t,alist)
    except KeyError: pass
    ## Locally defined agent instantiations
    try:
      for agent in self.getAgents(name,recursive=False):
        aname,atype = self.dataExtract(['name','type'],agent)
        try:
          aparams_list = agent['parameters']
        except KeyError:
          aparams_list = []
          pass
        aparams = {}
        for item in aparams_list:
          n,v = self.dataExtract(['name','value'],item)
          aparams[n] = v;
        try:
          intf = self.data['interfaces'][atype]
        except KeyError:
          raise UserError("Agent type \""+atype+"\" in environment \""+name+"\" is not recognized")
        env.addAgent(agent['name'],atype,intf['clock'],intf['reset'],aparams)
    except KeyError: pass
    defined_ac_items = []
    try:
      ac_items = struct['analysis_components']
    except KeyError:
      ac_items = []
      pass
    for ac_item in ac_items:
      ac_type,ac_name = self.dataExtract(['type','name'],ac_item)
      ## Don't go through the trouble of poking at the definition of the analysis component if it was already
      ## used before.  Just instantiate it
      try:
        extdef = (ac_item['extdef'] == 'True')
      except KeyError:
        extdef = False
        pass
      if ((ac_type not in defined_ac_items) and extdef==False):
        try:
          definition = self.data['util_components'][ac_type]
        except KeyError:
          raise UserError("No definition found for component \""+ac_name+"\" of type \""+ac_type)
        ac_type_type = definition['type']
        exports = {}
        try:
          for item in definition['analysis_exports']:
            exports[item['name']] = item['type']
        except KeyError: pass
        ports = {}
        try:
          for item in definition['analysis_ports']:
            ports[item['name']] = item['type'] 
        except KeyError: pass
        env.defineAnalysisComponent(ac_type_type,ac_type,exports,ports)
        defined_ac_items = defined_ac_items + [ac_type]
      env.addAnalysisComponent(ac_name,ac_type)
    try:
      sb_items = struct['scoreboards']
    except KeyError:
      sb_items = []
      pass
    for sb_item in sb_items:
      sb_name,sb_type,trans_type = self.dataExtract(['name','sb_type','trans_type'],sb_item)
      env.addUvmfScoreboard(sb_name,sb_type,trans_type)
    try:
      for item in struct['analysis_ports']:
        n,t,c = self.dataExtract(['name','trans_type','connected_to'],item)
        env.addAnalysisPort(n,t,c)
    except KeyError: pass
    try:
      for item in struct['analysis_exports']:
        n,t,c = self.dataExtract(['name','trans_type','connected_to'],item)
        env.addAnalysisExport(n,t,c)
    except KeyError: pass
    try:
      for item in struct['qvip_connections']:
        d,r,k = self.dataExtract(['driver','receiver','ap_key'],item)
        rlist = r.split(".")
        env.addQvipConnection(d,k,'.'.join(rlist[:-1]),rlist[-1])
    except KeyError: pass
    try:
      for conn in struct['tlm_connections']:
        d,r = self.dataExtract(['driver','receiver'],conn)
        ## The driver and receiver entries provided need to be split to work with the API in uvmf_gen
        dlist = d.split(".")
        rlist = r.split(".")
        env.addConnection('.'.join(dlist[:-1]),dlist[-1],'.'.join(rlist[:-1]),rlist[-1])
    except KeyError: pass
    try:
      for cfg_item in struct['config_vars']:
        n,t = self.dataExtract(['name','type'],cfg_item)
        try:
          crand = (cfg_item['isrand']=="True")
        except KeyError: 
          crand = False
          pass
        env.addConfigVar(n,t,crand)
    except KeyError: pass
    try:
      for item in struct['config_constraints']:
        n,v = self.dataExtract(['name','value'],item)
        env.addConfigVarConstraint(n,v)
    except KeyError: pass
    try:
      regInfo = struct['register_model']
    except KeyError:
      regInfo = None
      pass
    if regInfo != None:
      try:
        maps = regInfo['maps']
      except KeyError:
        maps = None
        pass
      if maps==None:
        use_adapter = False
        use_explicit_prediction = False
        sequencer = None
        trans = None
        adapter = None
        mapName = None
      else:
        try:
          use_adapter = regInfo['use_adapter'] == "True"
        except KeyError:
          use_adapter = True
        try:
          use_explicit_prediction = regInfo['use_explicit_prediction'] == "True"
        except KeyError:
          use_explicit_prediction = True
        maps = regInfo['maps']
        ## Currently only support a single map - this will change in the future, hopefully
        if len(maps) != 1:
          raise UserError("Register model in environment \""+name+"\" can only have one map defined")
        ## Extract information regarding the interface we should be attaching to.
        ## First, confirm that the name of the agent is a valid instance.  This will return a list
        ## of structures, each with an 'name' key and 'type' key. The interface we're attaching to
        ## must match up with the 'name' key in this list somewhere
        agent_list = self.getAgents(name,recursive=True)
        agent_type = ""
        for a in agent_list:
          if a['name'] == maps[0]['interface']:
            ## Testing for a defined type might be thought to be needed here but if it wasn't a
            ## valid agent type the above check would never pass
            agent_type = a['type']
            try:
              agent_params = self.parameterSyntax(a['parameters'])
            except KeyError:
              agent_params = ""
              pass
            break
        if agent_type == "":
          raise UserError("For register map \""+maps[0]['name']+"\" in environment \""+name+"\" no interface \""+maps[0]['interface']+"\" was found")
        sequencer = maps[0]['interface']+".sequencer"
        trans = agent_type+"_transaction"+agent_params
        adapter = agent_type+"2reg_adapter"+agent_params
        mapName = maps[0]['name']
      env.addRegisterModel(
        sequencer=sequencer,
        transactionType=trans,
        adapterType=adapter, 
        busMap=mapName,
        useAdapter=use_adapter,
        useExplicitPrediction=use_explicit_prediction)
    try:
      dpi_def = struct['dpi_define']
      ca = ""
      la = ""
      try:
        ca = dpi_def['comp_args']
      except KeyError: pass
      try:
        la = dpi_def['link_args']
      except KeyError: pass
      env.setDPISOName(value=dpi_def['name'],compArgs=ca,linkArgs=la)
      for f in dpi_def['files']:
        env.addDPIFile(f)
      try:
        for imp in dpi_def['imports']:
          sv_args = {}
          try:
            for a in imp['sv_args']:
              sv_args[a['name']] = a['type']
          except KeyError: pass
          env.addDPIImport(imp['return_type'],imp['name'],imp['c_args'],sv_args)
      except KeyError: pass
      try:
        for exp in dpi_def['exports']:
          intf.addDPIExport(exp)
      except KeyError: pass
    except KeyError: pass
    env.create(parser=self.parser)
    return env

  def parameterSyntax(self,parameterList):
    ## Take the parameter list provided and return the SV syntax for a parameterized type
    ## This is expected to be of "parameterUseSchema" with 'name' and a 'value' keys
    l = []
    for p in parameterList:
      s = "."+p['name']+"("+p['value']+")"
      l = l + [ s ]
    fs = "#("+','.join(l)+")"
    return fs

  def generateBench(self,name):
    ## Isolate the YAML structure for this bench
    struct = self.data['benches'][name]
    ## Get the name of the top-level environment
    top_env = struct['top_env']
    ## Top-level environment parameters
    try:
      env_params_list = struct['top_env_params']
    except KeyError: 
      env_params_list = []
      pass
    ## Build up simpler name/value pair dict of env params
    env_params = {}
    for p in env_params_list:
      env_params[p['name']] = p['value']
    ## With this information we can create the bench class object
    ben = BenchClass(name,top_env,env_params)
    ## Look for clock and reset control settings (all optional)
    try:
      ben.clockHalfPeriod = struct['clock_half_period']
    except KeyError: pass
    try:
      ben.clockPhaseOffset = struct['clock_phase_offset']
    except KeyError: pass
    try:
      ben.resetAssertionLevel = (struct['reset_assertion_level']=='True')
    except KeyError: pass
    try:
      ben.resetDuration = struct['reset_duration']
    except KeyError: pass
    ## Pull out bench-level parameter definitions, if any
    try:
      for param in struct['parameters']:
        pname,ptype,pval = self.dataExtract(['name','type','value'],param)
        ben.addParamDef(pname,ptype,pval)
    except KeyError: pass    
    ## Imports
    try:
      for imp in struct['imports']:
        ben.addImport(imp['name'])
    except KeyError: pass
    ## Pull out active/passive list and produce more easily parsed dict keyed by the BFM names
    try:
      ap_list = struct['active_passive']
    except KeyError:
      ap_list = []
      pass
    ap_dict = {}
    for i in ap_list:
      ap_dict[i['bfm_name']] = i['value']
    ## Do the same for interface parameters
    try:
      ifp_list = struct['interface_params']
    except KeyError:
      ifp_list = []
    ifp_dict = {}
    for entry in ifp_list:
      bfm_name = entry['bfm_name']
      param_list = entry['value']
      ifp_dict[bfm_name] = {}
      for p in param_list:
        ifp_dict[bfm_name][p['name']] = p['value']
    ## Find QVIP BFMs and add those - order is important, must match how we instantiated the components
    ## within the environment
    for agent_struct in self.getQVIPAgents(top_env):
      ben.addQvipBfm(name=agent_struct['name'],ifPkg=agent_struct['parent'],activity=agent_struct['active_passive'])
    ## Now drill down into top-level environment to generate a list of required BFMs to instantiate.
    ## This time we also need to get information about sub-environment names and paths in order to
    ## provide a unique BFM name as well as the path down to the subenv
    for agent_struct in self.getAgents(top_env,recursive=True,givePath=True):
      agent = agent_struct['agent']
      envpath = agent_struct['envpath']
      if (len(envpath)>0):
        ## We have sub-environments that need to be incorporated into the addBfm call as both
        ## the name of the BFM as well as debug information path.
        bfm_name = "_".join(envpath) + "_" + agent['name']
        debugpath = "environment/" + "/".join(envpath)
      else:
        bfm_name = agent['name']
        debugpath = 'environment'
      try:
        active_passive = ap_dict[bfm_name]
      except KeyError:
        active_passive = 'ACTIVE'
        pass
      try:
        agentDef = self.data['interfaces'][agent['type']]
      except:
        raise UserError("Definition for interface type \""+agent['type']+"\" for instance \""+agent['name']+"\" is not found")
      ## There may be interface parameters defined for the interface we're looking at, track those as well
      try:
        aParams = ifp_dict[bfm_name]
      except KeyError:
        aParams = {}
        pass
      ben.addBfm(name=bfm_name,ifPkg=agent['type'],clk=agentDef['clock'],rst=agentDef['reset'],activity=active_passive,parametersDict=aParams,sub_env_path=debugpath)
    ## Now drill down again but this time find any DPI packages - these could be defined at any
    ## interface or environment, so getAgents isn't good enough.  Also need to call getEnvironments
    dpi_packages = []
    for agent in self.getAgents(top_env,recursive=True):
      try:
        dpi_pkg = self.data['interfaces'][agent['type']]['dpi_define']['name']
        if dpi_pkg not in dpi_packages:
          dpi_packages.append(dpi_pkg)
      except KeyError: pass
    envs = self.getEnvironments(top_env,recursive=True)
    ## Also add the top-environment
    envs.append({'type':top_env})
    for env in envs:
      try:
        dpi_pkg = self.data['environments'][env['type']]['dpi_define']['name']
        if dpi_pkg not in dpi_packages:
          dpi_packages.append(dpi_pkg)
      except KeyError: pass
    for d in dpi_packages:
      ben.addDPILibName(d)
    ben.create(parser=self.parser)
    return ben

  def generateInterface(self,name):
    intf = InterfaceClass(name)
    struct = self.data['interfaces'][name]
    intf.clock = struct['clock']
    intf.reset = struct['reset']
    try:
      intf.resetAssertionLevel = (struct['reset_assertion_level'] == "True")
    except KeyError: pass
    try:
      for imp in struct['imports']:
        env.addImport(imp['name'])
    except KeyError: pass
    try:
      for item in struct['parameters']:
        n,t,v = self.dataExtract(['name','type','value'],item)
        intf.addParamDef(n,t,v)
    except KeyError: pass
    try:
      for item in struct['hdl_typedefs']:
        n,t = self.dataExtract(['name','type'],item)
        intf.addHdlTypedef(n,t)
    except KeyError: pass
    try:
      for item in struct['hvl_typedefs']:
        n,t = self.dataExtract(['name','type'],item)
        intf.addHvlTypedef(n,t)
    except KeyError: pass
    try:
      for port in struct['ports']:
        n,w,d = self.dataExtract(['name','width','dir'],port)
        if not re.search(r"^(input|output|inout)$",d):
          raise UserError("Direction \""+d+"\" invalid for port \""+n+"\" in interface \""+name+"\"")
        intf.addPort(n,w,d)
    except KeyError: pass
    try:
      for trans in struct['transaction_vars']:
        n,t = self.dataExtract(['name','type'],trans)
        try:
          trand = (trans['isrand']=="True")
        except KeyError: 
          trand = False
          pass
        try:
          tcomp = (trans['iscompare']=="True")
        except KeyError: 
          tcomp = True
          pass
        intf.addTransVar(n,t,isrand=trand,iscompare=tcomp)
    except KeyError: pass
    try:
      for cfg in struct['config_vars']:
        n,t = self.dataExtract(['name','type'],cfg)
        try:
          crand = (cfg['isrand']=="True")
        except KeyError: 
          crand = False
          pass
        intf.addConfigVar(n,t,crand)
    except KeyError: pass
    try:
      for item in struct['transaction_constraints']:
        n,v = self.dataExtract(['name','value'],item)
        intf.addTransVarConstraint(n,v)
    except KeyError: pass
    try:
      for item in struct['config_constraints']:
        n,v = self.dataExtract(['name','value'],item)
        intf.addConfigVarConstraint(n,v)
    except KeyError: pass
    try:
      response_info = struct['response_info']
      resp_op = response_info['operation']
      intf.specifyResponseOperation(resp_op)
      resp_data = response_info['data']
      intf.specifyResponseData(resp_data)
    except KeyError: pass
    try:
      dpi_def = struct['dpi_define']
      ca = ""
      la = ""
      try:
        ca = dpi_def['comp_args']
      except KeyError: pass
      try:
        la = dpi_def['link_args']
      except KeyError: pass
      intf.setDPISOName(value=dpi_def['name'],compArgs=ca,linkArgs=la)
      for f in dpi_def['files']:
        intf.addDPIFile(f)
      try:
        for imp in dpi_def['imports']:
          sv_args = {}
          try:
            for a in imp['sv_args']:
              sv_args[a['name']] = a['type']
          except KeyError: pass
          intf.addDPIImport(imp['return_type'],imp['name'],imp['c_args'],sv_args)
      except KeyError: pass
      try:
        for exp in dpi_def['exports']:
          intf.addDPIExport(exp)
      except KeyError: pass
    except KeyError: pass
    intf.create(parser=self.parser)
    return intf


## When invoked, this script can read a series of provided YAML-based configuration files and parse them, building
## up a database of information on the contained components. Each component will have an associated uvmf_gen class
## created around it based on the contents.  

## User can specify that a particular element(s) be created with the -g/--generate switch but the default is to produce
## everything (i.e. call "<element>.create()" against all defined elements).  Any item passed in via --generate 
## that matches the name of a defined element will be generated (if environments/benches/interfaces are named the
## same the script will match all of them)

if __name__ == '__main__':
  search_paths = ['.']
  uvmf_parser = UVMFCommandLineParser(version=__version__,usage="yaml2uvmf.py [options] [yaml_file1 [yaml_fileN]]")
  uvmf_parser.parser.add_option("-f","--file",dest="configfile",action="append",help="Specify a file list of YAML configs")
  uvmf_parser.parser.add_option("-g","--generate",dest="gen_name",action="append",help="Specify which elements to generate (default is everything")
  uvmf_parser.parser.add_option("-p","--pdb",dest="enable_pdb",action="store_true",help="Enable PDB interactive debugger (internal use only)",default=False)
  (options,args) = uvmf_parser.parser.parse_args()
  if (options.enable_pdb == True):
    import pdb
    pdb.set_trace()
  elif (options.debug == False):
    sys.tracebacklimit = 0
  if (len(args) == 0 and options.configfile == None):
    raise UserError("No configurations or config file specified as input. Must provide one or both")
  dataObj = DataClass(uvmf_parser)
  configfiles = []
  if (options.configfile != None):
    for cf in options.configfile:
      cfr = ConfigFileReader(cf)
      configfiles = configfiles + cfr.files
  try:
    configfiles = configfiles + args
  except TypeError:
    pass
  if configfiles == []:
    raise UserError("No configuration YAML specified to parse, must provide at least one")
  for cfg in configfiles:
    dataObj.parseFile(cfg)
  dataObj.validate()
  dataObj.buildElements(options.gen_name);
