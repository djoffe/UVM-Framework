from command_helper import *
import os
import sys

class Vopt(Generator):
  def __init__(self,v={}):
    super(Vopt,self).__init__
    self.keys = '''
            cmd    arch     tops      work      out    coverage_build  visibility   vis_designfile extra    modelsimini  suppress  lib  logfile lint
            '''.split()

  def set_cmd(self,v={}):
    return 'vopt'

  def set_out(self,v={}):
    if 'out' in v and v['out']:
      return '-o '+v['out']
    return ''

  def set_lint(self,v={}):
    if 'lint' in v and v['lint']:
      return '-reporthrefs+hdl_top'
    else:
      return ''

  def elaborate(self,v={}):
    self.cmd                  = self.set_cmd(v)
    self.arch                 = self.set_arch(v)
    self.tops                 = self.set_tops(v)
    self.work                 = self.set_work(v)
    self.out                  = self.set_out(v)
    self.visibility           = self.set_visibility(v)
    self.extra                = self.set_extra(v)
    self.modelsimini          = self.set_modelsimini(v)
    self.suppress             = self.set_suppress(v)
    self.lib                  = self.set_lib(v)
    self.logfile              = self.set_logfile(v)
    self.coverage_build       = self.set_coverage_build(v)
    self.vis_designfile       = self.set_vis_designfile(v)
    self.lint                 = self.set_lint(v)

# Invoke vopt
def generate_command(v=None):
  obj = Vopt()
  obj.elaborate(v)
  logger.debug(obj)
  return obj.command(v)