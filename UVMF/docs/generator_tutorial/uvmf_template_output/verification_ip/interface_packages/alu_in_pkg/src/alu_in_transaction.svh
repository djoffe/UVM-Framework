//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface Transaction
// File            : alu_in_transaction.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class defines the variables required for an alu_in
//    transaction.  Class variables to be displayed in waveform transaction
//    viewing are added to the transaction viewing stream in the add_to_wave
//    function.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class alu_in_transaction       #(
      int ALU_IN_OP_WIDTH = 8                                
      ) extends uvmf_transaction_base;

  `uvm_object_param_utils( alu_in_transaction #(
                           ALU_IN_OP_WIDTH
                            ))

  rand alu_in_op_t op;
  rand bit [ALU_IN_OP_WIDTH-1:0] a;
  rand bit [ALU_IN_OP_WIDTH-1:0] b;

//Constraints for the transaction variables:
  constraint valid_op_c { op inside {no_op, add_op, and_op, xor_op, mul_op}; }

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "" );
    super.new( name );
  endfunction

// ****************************************************************************
// FUNCTION: convert2string()
// This function converts all variables in this class to a single string for 
// logfile reporting.
//
  virtual function string convert2string();
    // UVMF_CHANGE_ME : Customize format if desired.
    return $sformatf("op:0x%x a:0x%x b:0x%x ",op,a,b);
  endfunction

//*******************************************************************
// FUNCTION: do_print()
// This function is automatically called when the .print() function
// is called on this class.
//
  virtual function void do_print(uvm_printer printer);
    if (printer.knobs.sprint==0)
      $display(convert2string());
    else
      printer.m_string = convert2string();
  endfunction

//*******************************************************************
// FUNCTION: do_compare()
// This function is automatically called when the .compare() function
// is called on this class.
//
  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    alu_in_transaction   #(
            .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)
             ) RHS;
    if (!$cast(RHS,rhs)) return 0;
// UVMF_CHANGE_ME : Eliminate comparison of variables not to be used for compare
    return (super.do_compare(rhs,comparer)
            &&(this.op == RHS.op)
            &&(this.a == RHS.a)
            &&(this.b == RHS.b)
            );
  endfunction

// ****************************************************************************
// FUNCTION: add_to_wave()
// This function is used to display variables in this class in the waveform 
// viewer.  The start_time and end_time variables must be set before this 
// function is called.  If the start_time and end_time variables are not set
// the transaction will be hidden at 0ns on the waveform display.
// 
  virtual function void add_to_wave(int transaction_viewing_stream_h);
    if (transaction_view_h == 0)
      transaction_view_h = $begin_transaction(transaction_viewing_stream_h,"alu_in_transaction",start_time);
    case (op)
      no_op :   $add_color(transaction_view_h,"grey");
      add_op :  $add_color(transaction_view_h,"green");
      and_op :  $add_color(transaction_view_h,"orange");
      xor_op :  $add_color(transaction_view_h,"red");
      mul_op :  $add_color(transaction_view_h,"yellow");
      rst_op :  $add_color(transaction_view_h,"blue");
      default : $add_color(transaction_view_h,"grey");
    endcase
    super.add_to_wave(transaction_view_h);
// UVMF_CHANGE_ME : Eliminate transaction variables not wanted in transaction viewing in the waveform viewer
    $add_attribute(transaction_view_h,op,"op");
    $add_attribute(transaction_view_h,a,"a");
    $add_attribute(transaction_view_h,b,"b");
    $end_transaction(transaction_view_h,end_time);
    $free_transaction(transaction_view_h);
  endfunction

endclass
