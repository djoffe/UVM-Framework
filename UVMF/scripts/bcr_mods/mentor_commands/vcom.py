from command_helper import *
import os
import sys

class Vcom(Generator):
  def __init__(self,v={}):
    super(Vcom,self).__init__
    self.keys = '''
                 cmd       filelists     modelsimini    extra    suppress  logfile    msglimit
                '''.split()

  def set_cmd(self,v={}):
    return 'vcom'

  def set_filelists(self,v={}):
    if 'filelists' not in v:
      logger.error("No filelists variable specified for vcom operation")
      sys.exit(1)
    return filelists(val=v['filelists'],assoc='vhdl')

  def elaborate(self,v={}): 
    self.cmd           = self.set_cmd(v)          
    self.filelists     = self.set_filelists(v)    
    self.modelsimini   = self.set_modelsimini(v)  
    self.extra         = self.set_extra(v)        
    self.suppress      = self.set_suppress(v)     
    self.logfile       = self.set_logfile(v)      
    self.msglimit      = self.set_msglimit(v)     

  def __repr__(self):
    if not self.filelists:
      return ''
    return super(Vcom,self).__repr__()

  def command(self,v):
    if not self.filelists:
      return []
    return super(Vcom,self).command(v)   