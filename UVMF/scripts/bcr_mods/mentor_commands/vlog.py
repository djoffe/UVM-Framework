from command_helper import *
import os
import sys

class Vlog(Generator):
  def __init__(self,v={}):
    super(Vlog,self).__init__
    self.keys = '''
                 cmd      arch   filelists      modelsimini   extra    timescale  suppress  logfile   msglimit lint
                '''.split()

  def set_cmd(self,v={}):
    return 'vlog'

  def set_filelists(self,v={}):
    if 'filelists' not in v:
      logger.error("No filelists variable specified for vlog operation")
      sys.exit(1)
    return filelists(val=v['filelists'],assoc='vlog')+" "+filelists(v['filelists'],assoc='c')

  def set_lint(self,v={}):
    if 'lint' in v and v['lint']:
      return '-tbxhvllint+ignorepkgs=uvm_pkg'
    else:
      return ''

  def elaborate(self,v={}):
    self.cmd                     = self.set_cmd(v)         
    self.arch                    = self.set_arch(v)  
    self.filelists               = self.set_filelists(v)     
    self.modelsimini             = self.set_modelsimini(v)   
    self.extra                   = self.set_extra(v)         
    self.timescale               = self.set_timescale(v)     
    self.suppress                = self.set_suppress(v)      
    self.logfile                 = self.set_logfile(v)       
    self.msglimit                = self.set_msglimit(v)     
    self.lint                    = self.set_lint(v) 

  def __repr__(self):
    if not self.filelists:
      return ''
    return super(Vlog,self).__repr__()

  def command(self,v):
    if not self.filelists:
      return []
    return super(Vlog,self).command(v)      
