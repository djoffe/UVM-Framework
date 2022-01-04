//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface Transaction Coverage
// File            : alu_in_transaction_coverage.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records alu_in transaction information using
//       a covergroup named alu_in_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
// ****************************************************************************
//----------------------------------------------------------------------
//
class alu_in_transaction_coverage  #(
      int ALU_IN_OP_WIDTH = 8                                
      ) extends uvm_subscriber #(.T(alu_in_transaction  #(
                                            .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                                            ) ));

  `uvm_component_param_utils( alu_in_transaction_coverage #(
                              ALU_IN_OP_WIDTH
                            ))

  alu_in_op_t op;
  bit [ALU_IN_OP_WIDTH-1:0] a;
  bit [ALU_IN_OP_WIDTH-1:0] b;

// ****************************************************************************
  // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
  covergroup alu_in_transaction_cg;
    option.auto_bin_max=1024;
    coverpoint op;
    coverpoint a;
    coverpoint b;
  endgroup

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    alu_in_transaction_cg=new;
    alu_in_transaction_cg.set_inst_name($sformatf("alu_in_transaction_cg_%s",get_full_name()));
 endfunction

// ****************************************************************************
// FUNCTION: write (T t)
// This function is automatically executed when a transaction arrives on the
// analysis_export.  It copies values from the variables in the transaction 
// to local variables used to collect functional coverage.  
//
  virtual function void write (T t);
    `uvm_info("Coverage","Received transaction",UVM_HIGH);
    op = t.op;
    a = t.a;
    b = t.b;
    alu_in_transaction_cg.sample();
  endfunction

endclass
