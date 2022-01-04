//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_out interface agent
// Unit            : Interface Driver BFM
// File            : alu_out_driver_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: 
//    This interface performs the alu_out signal driving.  It is
//     accessed by the uvm alu_out driver through a virtual interface
//     handle in the alu_out configuration.  It drives the singals passed
//     in through the port connection named bus of type alu_out_if.
//
//     Input signals from the alu_out_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//     This bfm drives signals with a _o suffix.  These signals
//     are driven onto signals within alu_out_if based on INITIATOR/RESPONDER and/or
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
//       bit [ALU_OUT_RESULT_WIDTH-1:0] result );//                   );
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
import alu_out_pkg_hdl::*;

interface alu_out_driver_bfm       #(
      int ALU_OUT_RESULT_WIDTH = 16                                
      )
(alu_out_if  bus);
// pragma attribute alu_out_driver_bfm partition_interface_xif
// The above pragma and additional ones in-lined below are for running this BFM on Veloce

  // Config value to determine if this is an initiator or a responder 
  uvmf_initiator_responder_t initiator_responder;

  tri        clk_i;
  tri        rst_i;

// Signal list (all signals are capable of being inputs and outputs for the sake
// of supporting both INITIATOR and RESPONDER mode operation. Expectation is that 
// directionality in the config file was from the point-of-view of the INITIATOR

// INITIATOR mode input signals
  tri         done_i;
  bit         done_o;
  tri       [ALU_OUT_RESULT_WIDTH-1:0]  result_i;
  bit       [ALU_OUT_RESULT_WIDTH-1:0]  result_o;

// INITIATOR mode output signals

// Bi-directional signals
  

  assign     clk_i    =   bus.clk;
  assign     rst_i    =   bus.rst;

  // These are signals marked as 'input' by the config file, but the signals will be
  // driven by this BFM if put into RESPONDER mode (flipping all signal directions around)
  assign     done_i = bus.done;
  assign     bus.done = (initiator_responder == RESPONDER) ? done_o : 'bz;
  assign     result_i = bus.result;
  assign     bus.result = (initiator_responder == RESPONDER) ? result_o : 'bz;


  // These are signals marked as 'output' by the config file, but the outputs will
  // not be driven by this BFM unless placed in INITIATOR mode.

   // Proxy handle to UVM driver
   alu_out_pkg::alu_out_driver  #(
              .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
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
  task do_transfer(                input bit [ALU_OUT_RESULT_WIDTH-1:0] result               );                                                  
  // UVMF_CHANGE_ME : Implement protocol signaling.
  // Transfers are protocol specific and therefore not generated by the templates.
  // Use the following as examples of transferring data between a sequence and the bus
  // In the wb_pkg - wb_master_access_sequence.svh, wb_driver_bfm.sv
  // Reference code;
  //    while (control_signal == 1'b1) @(posedge clk_i);
  //    INITIATOR mode input signals
  //    done_i;        //    
  //    done_o <= xyz; //     
  //    result_i;        //   [ALU_OUT_RESULT_WIDTH-1:0] 
  //    result_o <= xyz; //   [ALU_OUT_RESULT_WIDTH-1:0]  
  //    INITIATOR mode output signals
  //    Bi-directional signals
 

  @(posedge clk_i);
  @(posedge clk_i);
  @(posedge clk_i);
  @(posedge clk_i);
  @(posedge clk_i);
  $display("alu_out_driver_bfm: Inside do_transfer()");
endtask        

  // UVMF_CHANGE_ME : Implement response protocol signaling.
  // Templates also do not generate protocol specific response signaling. Use the 
  // following as examples for transferring data between a sequence and the bus
  // In wb_pkg - wb_memory_slave_sequence.svh, wb_driver_bfm.sv

  task do_response(                 output bit [ALU_OUT_RESULT_WIDTH-1:0] result       );
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
    input   bit [ALU_OUT_RESULT_WIDTH-1:0] result );
  // pragma tbx xtf                    
  @(posedge clk_i);                                                                     
  $display("alu_out_driver_bfm: Inside access()");
  do_transfer(
    result          );                                                  
  endtask      

// ****************************************************************************              
// UVMF_CHANGE_ME : Note that all transaction variables are passed into the response
//   task as outputs.  Some of these may need to be changed to inputs based on
//   protocol needs.
  task response(
 output bit [ALU_OUT_RESULT_WIDTH-1:0] result );
  // pragma tbx xtf
     @(posedge clk_i);
     $display("alu_out_driver_bfm: Inside response()");
    do_response(
      result        );
  endtask             
  
endinterface
