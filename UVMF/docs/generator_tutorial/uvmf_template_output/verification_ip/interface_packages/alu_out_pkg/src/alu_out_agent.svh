//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_out interface agent
// Unit            : Interface UVM agent
// File            : alu_out_agent.svh
//----------------------------------------------------------------------
//     
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class alu_out_agent #( int ALU_OUT_RESULT_WIDTH = 16)extends uvmf_parameterized_agent #(
                    .CONFIG_T(alu_out_configuration #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH))),
                    .DRIVER_T(alu_out_driver #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH))),
                    .MONITOR_T(alu_out_monitor #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH))),
                    .COVERAGE_T(alu_out_transaction_coverage #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH))),
                    .TRANS_T(alu_out_transaction #(.ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)))
                    );

  `uvm_component_param_utils (alu_out_agent #(ALU_OUT_RESULT_WIDTH) )

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

endclass
