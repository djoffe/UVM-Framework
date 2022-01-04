import sys

try:
  from voluptuous import Required,Optional,Any,In,Schema
  from voluptuous.humanize import humanize_error
except ImportError:
  print "ERROR : voluptuous package not found. See templates.README for more information"
  sys.exit(1)

class BaseValidator(object):

  def __init__(self):
    self.dpiArgumentSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('unpacked_dimension'): str,
      Required('dir'): Any('input','output','inout','')
    }
    self.dpiImportSchema = {
      Required('sv_return_type'): str,
      Required('c_return_type'): str,
      Required('name'): str,
      Required('c_args'): str,
      Required('sv_args'): [ self.dpiArgumentSchema ]
    }
    self.dpiDefSchema = {
      Required('name'): str ,
      Required('files'): [ str ],
      Optional('comp_args'): str,
      Optional('link_args'): str,
      Optional('exports'): [ str ],
      Optional('imports'): [ self.dpiImportSchema ]
    }
    self.configVarSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('isrand'): Any("True","False"),
    }
    self.constraintSchema = {
      Required('name'): str,
      Required('value'): str
    }
    self.parameterDefSchema = { 
      Required('name'): str, 
      Required('type'): str, 
      Required('value'): str 
    }
    self.typedefSchema = { 
      Required('name'): str, 
      Required('type'): str 
    }
    self.parameterUseSchema = {
      Required('name'): str,
      Required('value'): str
    }
    self.componentSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('extdef'): Any('True','False'),
      Optional('parameters'): [ self.parameterUseSchema ]
    }
    self.TLMPortSchema = {
      Required('name'): str,
      Required('trans_type'): str,
      Required('connected_to'): str
    }
    self.importSchema = {
      Required('name'): str
    }
    self.schema = None

class BenchValidator(BaseValidator):

  def __init__(self):
    super(BenchValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    activePassiveSchema = {
      Required('bfm_name'): str,
      Required('value') : Any('ACTIVE','PASSIVE')
    }
    interfaceParamSchema = {
      Required('bfm_name'): str,
      Required('value'): [ self.parameterUseSchema ]
    }
    mainSchema = {
      Required('top_env'): str,
      Optional('veloce_ready'): Any('True','False'),
      Optional('catapult_ready'): Any('True','False'),
      Optional('infact_ready'): Any('True','False'),
      Optional('clock_half_period'): str,
      Optional('use_coemu_clk_rst_gen'): Any('True','False'),
      Optional('clock_phase_offset'): str,
      Optional('reset_assertion_level'): str,
      Optional('use_dpi_link'): str,
      Optional('reset_duration'): str,
      Optional('active_passive'): [ activePassiveSchema ],
      Optional('parameters'): [ self.parameterDefSchema ],
      Optional('top_env_params'):  [ self.parameterUseSchema ],
      Optional('interface_params'): [ interfaceParamSchema ],
      Optional('imports'): [ self.importSchema ],
    }
    self.schema = Schema(mainSchema)

class ComponentValidator(BaseValidator):

  def __init__(self):
    super(ComponentValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    analysisSchema = {
      Required('name'): str,
      Required('type'): str
    }
    mainSchema = {
      Required('type'): Any("predictor","coverage"),
      Optional('analysis_exports'):  [ analysisSchema ],
      Optional('analysis_ports'): [ analysisSchema ]
    }
    self.schema = Schema(mainSchema)

class QVIPEnvValidator(BaseValidator):

  def __init__(self):
    super(QVIPEnvValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    apInfoSchema = {
      Required('port_name'): str,
      Required('key'): str,
      Required('type'): str
    }
    agentsSchema = {
      Required('name'): str,
      Optional('active_passive'): Any("ACTIVE","PASSIVE"),
      Optional('initial_sequence'): str,
      Optional('imports'): [ str ],
      Optional('ap_info'): [ apInfoSchema ]
    }
    mainSchema = {
      Required('agents'): [ agentsSchema ] 
    }
    self.schema = Schema(mainSchema)

class EnvironmentValidator(BaseValidator):

  def __init__(self):
    super(EnvironmentValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    regModelMapSchema = {
      Required('name'): str,
      Required('interface'): str
    }
    regModelSchema = {
      Optional('use_adapter'): Any("True","False"),
      Optional('use_explicit_prediction'): Any("True","False"),
      Optional('maps'): [ regModelMapSchema ]
    }
    scoreboardSchema = {
      Required('name'): str,
      Required('sb_type'): str,
      Required('trans_type'): str
    }
    tlmSchema = {
      Required('driver'): str,
      Required('receiver'): str
    }
    qvipTlmSchema = {
      Required('driver'): str,
      Required('ap_key'): str,
      Required('receiver'): str
    }
    subenvSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('extdef'): Any('True','False'),
      Optional('parameters'): [ self.parameterUseSchema ],
      Optional('use_register_model'): Any("True","False")
    }
    qvipSubenvSchema = {
      Required('name'): str,
      Required('type'): str
    }
    agentSchema = {
      Required('name'): str,
      Required('type'): str,
      Optional('extdef'): Any('True','False'),
      Optional('parameters'): [ self.parameterUseSchema ],
      Optional('initiator_responder'): Any('INITIATOR','RESPONDER')
    }
    mainSchema = {
      Optional('agents'): [ agentSchema ],
      Optional('analysis_components'): [ self.componentSchema ],
      Optional('scoreboards'): [ scoreboardSchema ],
      Optional('subenvs'): [ subenvSchema ],
      Optional('analysis_ports'): [ self.TLMPortSchema ],
      Optional('analysis_exports'): [ self.TLMPortSchema ],
      Optional('tlm_connections'): [ tlmSchema ],
      Optional('qvip_connections'): [ qvipTlmSchema ],
      Optional('config_vars'): [ self.configVarSchema ],
      Optional('config_constraints'): [ self.constraintSchema ],
      Optional('parameters'): [ self.parameterDefSchema ],
      Optional('imports'): [ self.importSchema ],
      Optional('qvip_subenvs'): [ qvipSubenvSchema ],
      Optional('imp_decls'): [ { Required('name'): str } ],
      Optional('register_model'): regModelSchema,
      Optional('dpi_define'): self.dpiDefSchema,
      Optional('typedefs'): [ self.typedefSchema ],
    }
    self.schema = Schema(mainSchema)

class InterfaceValidator(BaseValidator):

  def __init__(self):
    super(InterfaceValidator,self).__init__()
    self.initializeSchema()

  def initializeSchema(self):
    portSchema = { 
      Required('name'): str,
      Required('width'): str,
      Required('dir'): str 
    }
    transactionSchema = { 
      Required('name'): str, 
      Required('type'): str, 
      Optional('isrand'): Any("True","False"),
      Optional('iscompare'): Any("True","False"),
      Optional('unpacked_dimension'): str
    }
    responseSchema = {
      Required('operation'): str,
      Required('data'): [ str ]
    }
    mainSchema = {
      Required('clock'): str,
      Required('reset'): str,
      Optional('reset_assertion_level'): str,
      Optional('use_dpi_link'): str,
      Optional('vip_lib_env_variable'): str,
      Optional('parameters'): [ self.parameterDefSchema ],
      Optional('hdl_typedefs'): [ self.typedefSchema ],
      Optional('hvl_typedefs'): [ self.typedefSchema ],
      Optional('ports'): [ portSchema ],
      Optional('transaction_vars'): [ transactionSchema ],
      Optional('transaction_constraints'): [ self.constraintSchema ],
      Optional('config_vars'): [ self.configVarSchema ],
      Optional('config_constraints'): [ self.constraintSchema ],
      Optional('response_info'): responseSchema,
      Optional('imports'): [ self.importSchema ],
      Optional('veloce_ready'): Any("True","False"),
      Optional('infact_ready'): Any("True","False"),
      Optional('dpi_define'): self.dpiDefSchema,
    }
    self.schema = Schema(mainSchema)
