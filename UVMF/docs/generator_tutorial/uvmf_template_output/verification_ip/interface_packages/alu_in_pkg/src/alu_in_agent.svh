//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface UVM agent
// File            : alu_in_agent.svh
//----------------------------------------------------------------------
//     
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class alu_in_agent #( int ALU_IN_OP_WIDTH = 8)extends uvmf_parameterized_agent #(
                    .CONFIG_T(alu_in_configuration #(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH))),
                    .DRIVER_T(alu_in_driver #(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH))),
                    .MONITOR_T(alu_in_monitor #(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH))),
                    .COVERAGE_T(alu_in_transaction_coverage #(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH))),
                    .TRANS_T(alu_in_transaction #(.ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)))
                    );

  `uvm_component_param_utils (alu_in_agent #(ALU_IN_OP_WIDTH) )

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

endclass
