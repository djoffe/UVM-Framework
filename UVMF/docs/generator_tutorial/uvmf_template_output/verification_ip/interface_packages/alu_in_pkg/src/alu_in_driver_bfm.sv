//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface Driver BFM
// File            : alu_in_driver_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the alu_in signal driving.  It is
//     accessed by the uvm alu_in driver through a virtual interface
//     handle in the alu_in configuration.  It drives the singals passed
//     in through the port connection named bus of type alu_in_if.
//
//     Input signals from the alu_in_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within alu_in_if based on INITIATOR/RESPONDER and/or
//     ARBITRATION/GRANT status.  
//
//     The output signal connections are as follows:
//        signal_o -> bus.signal
//
//                                                                                           
//      Interface functions and tasks used by UVM components:                                
//             configure(uvmf_initiator_responder_t mst_slv);                                       
//                   This function gets configuration attributes from the                    
//                   UVM driver to set any required BFM configuration                        
//                   variables such as 'initiator_responder'.                                       
//                                                                                           
//             access(
//       alu_in_op_t op,
//       bit [ALU_IN_OP_WIDTH-1:0] a,
//       bit [ALU_IN_OP_WIDTH-1:0] b );//                   );
//                   This task receives transaction attributes from the                      
//                   UVM driver and then executes the corresponding                          
//                   bus operation on the bus. 
//
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import alu_in_pkg_hdl::*;

interface alu_in_driver_bfm       #(
      int ALU_IN_OP_WIDTH = 8                                
      )
(alu_in_if  bus);
// pragma attribute alu_in_driver_bfm partition_interface_xif
// The above pragma and additional ones in-lined below are for running this BFM on Veloce

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;

  tri        clk_i;
  tri        rst_i;

// Signal list (all signals are capable of being inputs and outputs for the sake
// of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
// directionality in the config file was from the point-of-view of the INITIATOR

// INITIATOR mode input signals
  tri         ready_i;
  bit         ready_o;

// INITIATOR mode output signals
  tri         alu_rst_i;
  bit         alu_rst_o = 1'b1;
  tri         valid_i;
  bit         valid_o;
  tri       [2:0]  op_i;
  bit       [2:0]  op_o;
  tri       [ALU_IN_OP_WIDTH-1:0]  a_i;
  bit       [ALU_IN_OP_WIDTH-1:0]  a_o;
  tri       [ALU_IN_OP_WIDTH-1:0]  b_i;
  bit       [ALU_IN_OP_WIDTH-1:0]  b_o;

// Bi-directional signals
  

  assign     clk_i    =   bus.clk;
  assign     rst_i    =   bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign     ready_i = bus.ready;
  assign     bus.ready = (initiator_responder == RESPONDER) ? ready_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.
  assign bus.alu_rst = (initiator_responder == INITIATOR) ? (alu_rst_o && rst_i) : 'bz;
  assign alu_rst_i = bus.alu_rst;
  assign bus.valid = (initiator_responder == INITIATOR) ? valid_o : 'bz;
  assign valid_i = bus.valid;
  assign bus.op = (initiator_responder == INITIATOR) ? op_o : 'bz;
  assign op_i = bus.op;
  assign bus.a = (initiator_responder == INITIATOR) ? a_o : 'bz;
  assign a_i = bus.a;
  assign bus.b = (initiator_responder == INITIATOR) ? b_o : 'bz;
  assign b_i = bus.b;

   // Proxy handle to UVM driver
   alu_in_pkg::alu_in_driver  #(
              .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                    )  proxy;
  // pragma tbx oneway proxy.my_function_name_in_uvm_driver                 

//******************************************************************                         
   function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   init_resp
); // pragma tbx xtf                   
      initiator_responder = init_resp;
   
   endfunction                                                                               


// ****************************************************************************
  task do_transfer(                input alu_in_op_t op,
                input bit [ALU_IN_OP_WIDTH-1:0] a,
                input bit [ALU_IN_OP_WIDTH-1:0] b               );                                                  
  // UVMF_CHANGE_ME : Implement protocol signaling.
  // Transfers are protocol specific and therefore not generated by the templates.
  // Use the following as examples of transferring data between a sequence and the bus
  // In the wb_pkg - wb_master_access_sequence.svh, wb_driver_bfm.sv
  // Reference code;
  //    while (control_signal == 1'b1) @(posedge clk_i);
  //    INITIATOR mode input signals
  //    ready_i;        //    
  //    ready_o <= xyz; //     
  //    INITIATOR mode output signals
  //    alu_rst_i;        //     
  //    alu_rst_o <= xyz; //     
  //    valid_i;        //     
  //    valid_o <= xyz; //     
  //    op_i;        //   [2:0]  
  //    op_o <= xyz; //   [2:0]  
  //    a_i;        //   [ALU_IN_OP_WIDTH-1:0]  
  //    a_o <= xyz; //   [ALU_IN_OP_WIDTH-1:0]  
  //    b_i;        //   [ALU_IN_OP_WIDTH-1:0]  
  //    b_o <= xyz; //   [ALU_IN_OP_WIDTH-1:0]  
  //    Bi-directional signals
 

     @(posedge clk_i);
     case (op)
        rst_op  : do_assert_rst(op);
        default : alu_in_op(op, a, b);
     endcase
	 $display("alu_in_driver_bfm: Inside do_transfer()");

endtask        

// ****************************************************************************
  task do_assert_rst(input alu_in_op_t op);
  $display("%g ***************   Starting Reset", $time);
     op_o <= op;
     alu_rst_o <= 1'b0;
     repeat (10) @(posedge clk_i);
     alu_rst_o <= 1'b1;
     repeat (5) @(posedge clk_i);
  $display("%g ***************   Ending Reset", $time);
  endtask

// ****************************************************************************
  task alu_in_op(input alu_in_op_t op,
                 input bit [ALU_IN_OP_WIDTH-1:0] a,
                 input bit [ALU_IN_OP_WIDTH-1:0] b);
      
     while ( ready_i == 1'b0 ) @(posedge clk_i) ;
     valid_o <= 1'b1;
     op_o <= op;
     a_o <= a;
     b_o <= b;
      
     @(posedge clk_i);
     valid_o <= 1'b0;
     op_o <= {3{1'bx}};
     a_o <= {ALU_IN_OP_WIDTH{1'bx}};
     b_o <= {ALU_IN_OP_WIDTH{1'bx}};
     
   endtask       

  // UVMF_CHANGE_ME : Implement response protocol signaling.
  // Templates also do not generate protocol specific response signaling. Use the 
  // following as examples for transferring data between a sequence and the bus
  // In wb_pkg - wb_memory_slave_sequence.svh, wb_driver_bfm.sv

  task do_response(                 output alu_in_op_t op,
                 output bit [ALU_IN_OP_WIDTH-1:0] a,
                 output bit [ALU_IN_OP_WIDTH-1:0] b       );
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);
    @(posedge clk_i);
  endtask

  // The resp_ready bit is intended to act as a simple event scheduler and does
  // not have anything to do with the protocol. It is intended to be set by
  // a proxy call to do_response_ready() and ultimately cleared somewhere within the always
  // block below.  In this simple situation, resp_ready will be cleared on the
  // clock cycle immediately following it being set.  In a more complex protocol,
  // the resp_ready signal could be an input to an explicit FSM to properly
  // time the responses to transactions.  
  bit resp_ready;
  always @(posedge clk_i) begin
    if (resp_ready) begin
      resp_ready <= 1'b0;
    end
  end

  function void do_response_ready(    );  // pragma tbx xtf
    // UVMF_CHANGE_ME : Implement response - drive BFM outputs based on the arguments
    // passed into this function.  IMPORTANT - Must not consume time (it must remain
    // a function)
    resp_ready <= 1'b1;
  endfunction

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the access
//   task as inputs.  Some of these may need to be changed to outputs based on
//   protocol needs.
//
  task access(
    input   alu_in_op_t op,
    input   bit [ALU_IN_OP_WIDTH-1:0] a,
    input   bit [ALU_IN_OP_WIDTH-1:0] b );
  // pragma tbx xtf                    
  @(posedge clk_i);                                                                     
  $display("alu_in_driver_bfm: Inside access()");
  do_transfer(
    op,
    a,
    b          );                                                  
  endtask      

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the response
//   task as outputs.  Some of these may need to be changed to inputs based on
//   protocol needs.
  task response(
 output alu_in_op_t op,
 output bit [ALU_IN_OP_WIDTH-1:0] a,
 output bit [ALU_IN_OP_WIDTH-1:0] b );
  // pragma tbx xtf
     @(posedge clk_i);
     $display("alu_in_driver_bfm: Inside response()");
    do_response(
      op,
      a,
      b        );
  endtask             
  
endinterface
