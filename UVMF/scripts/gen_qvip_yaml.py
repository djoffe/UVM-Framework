#! /usr/bin/env python

import os
import fnmatch
import re
import sys
from optparse import OptionParser
import yaml
import datetime

__version__ = '0.9'

if __name__ == '__main__':
  cl = OptionParser(version=__version__,usage="gen_qvip_yaml.py [options] <qvip_config_output_dir>")
  cl.add_option("-o","--outfile",dest="outfile",action="store",type="string",default="",help="Specify output filename")
  cl.add_option("-q","--quiet",dest="quiet",action="store_true",default=False,help="Mute output")
  (options,args) = cl.parse_args()
  try:
    qvip_dir = args[0]
  except IndexError:
    cl.error("Must specify configurator output directory")
  if not os.path.isdir(qvip_dir):
    cl.error("Directory \""+qvip_dir+"\" is not valid")
  qvip_dir = os.path.abspath(qvip_dir)  
  (trash,qvip_leaf_dir) = os.path.split(qvip_dir)
  ## If a valid QVIP configurator output directory then there will be a file named ./uvmf/<bench_name>_pkg.sv
  ## underneath the specified path. Find that and figure out the bench name (only one file should match this search)
  file_name = ""
  for file in os.listdir(qvip_dir+"/uvmf"):
    if fnmatch.fnmatch(file,"*_pkg.sv"):
      file_name = file
      break
  if file_name == "":
    cl.error("Provided directory \""+qvip_dir+"\" does not appear to be a valid QVIP Configurator output directory")
  match = re.search(r"(\S+)_pkg.sv",file_name)
  bench_name = match.group(1)
  if options.quiet==False:
    print "  Parsing \""+file_name+"\" for information on \""+bench_name+"\" environment"
  with open(qvip_dir+"/uvmf/"+file_name) as f:
    lines = f.read().splitlines()
  f.close()
  for l in lines:
    match = re.search(r"'sub_env_instance_name', '(\S+)', (\[.*\])",l)
    if match:
      subenv_type = match.group(1)
      agents = eval(match.group(2))
      break
  if match==None:
    print "ERROR: Unable to find expected generated content in "+file_name
    sys.exit(1)
  if subenv_type != bench_name:
    print "ERROR: Name of bench found in "+file_name+" did not match structure"
    print "   Expected \""+bench_name+"\" but found \""+subenv_type+"\" in file"
    sys.exit(1)
  ## Build up required data structure
  agent_list = []
  for a in agents:
    agent_list = agent_list + [ { 'name': a } ]
  data_struct = { 'uvmf': { 'qvip_environments': { subenv_type: { 'agents': agent_list } } } }
  if (options.outfile != ""):
    outfile = options.outfile
  else:
    outfile = bench_name+"_subenv_config.yaml"
  if options.quiet==False:
    print "  Generating output YAML \""+outfile+"\""
  with open(outfile,'w') as outfile:
    outfile.write("# Generated with gen_qvip_yaml.py version "+__version__+"\n")
    outfile.write("# Generated on "+str(datetime.datetime.now())+"\n")
    outfile.write("# Command line: \""+" ".join(sys.argv)+"\"\n")
    outfile.write("#\n")
    outfile.write("# Use the following YAML snippet in the higher level environment YAML definition\n")
    outfile.write("# to instantiate this QVIP environment as a sub-environment\n")
    outfile.write("#\n")
    outfile.write("# qvip_subenvs:\n")
    outfile.write("#   - { name: \""+subenv_type+"_inst\", type: \""+subenv_type+"\" }\n")
    outfile.write("#\n")
    yaml.dump(data_struct,outfile,default_flow_style=False)
