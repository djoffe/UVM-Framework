//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_out interface agent
// Unit            : Interface Transaction Coverage
// File            : alu_out_transaction_coverage.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class records alu_out transaction information using
//       a covergroup named alu_out_transaction_cg.  An instance of this
//       coverage component is instantiated in the uvmf_parameterized_agent
//       if the has_coverage flag is set.
//
// ****************************************************************************
//----------------------------------------------------------------------
//
class alu_out_transaction_coverage  #(
      int ALU_OUT_RESULT_WIDTH = 16                                
      ) extends uvm_subscriber #(.T(alu_out_transaction  #(
                                            .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
                                            ) ));

  `uvm_component_param_utils( alu_out_transaction_coverage #(
                              ALU_OUT_RESULT_WIDTH
                            ))

  bit [ALU_OUT_RESULT_WIDTH-1:0] result;

// ****************************************************************************
  // UVMF_CHANGE_ME : Add coverage bins, crosses, exclusions, etc. according to coverage needs.
  covergroup alu_out_transaction_cg;
    option.auto_bin_max=1024;
    coverpoint result;
  endgroup

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new(string name="", uvm_component parent=null);
    super.new(name,parent);
    alu_out_transaction_cg=new;
    alu_out_transaction_cg.set_inst_name($sformatf("alu_out_transaction_cg_%s",get_full_name()));
 endfunction

// ****************************************************************************
// FUNCTION: write (T t)
// This function is automatically executed when a transaction arrives on the
// analysis_export.  It copies values from the variables in the transaction 
// to local variables used to collect functional coverage.  
//
  virtual function void write (T t);
    `uvm_info("Coverage","Received transaction",UVM_HIGH);
    result = t.result;
    alu_out_transaction_cg.sample();
  endfunction

endclass
