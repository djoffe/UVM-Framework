//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_out interface agent
// Unit            : Interface Monitor BFM
// File            : alu_out_monitor_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the alu_out signal monitoring.
//      It is accessed by the uvm alu_out monitor through a virtual
//      interface handle in the alu_out configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type alu_out_if.
//
//     Input signals from the alu_out_if are assigned to an internal input
//     signal with a _i suffix.  The _i signal should be used for sampling.
//
//     The input signal connections are as follows:
//       bus.signal -> signal_i 
//
//      Interface functions and tasks used by UVM components:
//             monitor(inout TRANS_T txn);
//                   This task receives the transaction, txn, from the
//                   UVM monitor and then populates variables in txn
//                   from values observed on bus activity.  This task
//                   blocks until an operation on the alu_out bus is complete.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import alu_out_pkg_hdl::*;

interface alu_out_monitor_bfm       #(
      int ALU_OUT_RESULT_WIDTH = 16                                
      )
( alu_out_if  bus );
// pragma attribute alu_out_monitor_bfm partition_interface_xif                                  
// The above pragma and additional ones in-lined below are for running this BFM on Veloce


   tri        clk_i;
   tri        rst_i;
   tri         done_i;
   tri        [ALU_OUT_RESULT_WIDTH-1:0] result_i;

   assign     clk_i    =   bus.clk;
   assign     rst_i    =   bus.rst;
   assign     done_i = bus.done;
   assign     result_i = bus.result;

   // Proxy handle to UVM monitor
   alu_out_pkg::alu_out_monitor  #(
              .ALU_OUT_RESULT_WIDTH(ALU_OUT_RESULT_WIDTH)                                
                    )  proxy;
  // pragma tbx oneway proxy.notify_transaction                 

//******************************************************************                         
   task wait_for_reset(); // pragma tbx xtf                                                  
      @(posedge clk_i) ;                                                                    
      do_wait_for_reset();                                                                   
   endtask                                                                                   

// ****************************************************************************              
   task do_wait_for_reset();                                                                 
      wait ( rst_i == 1 ) ;                                                              
      @(posedge clk_i) ;                                                                    
   endtask    
   
//******************************************************************                         
   task wait_for_num_clocks( input int unsigned count); // pragma tbx xtf                           
      @(posedge clk_i);                                                                     
      repeat (count-1) @(posedge clk_i);                                                    
   endtask      

//******************************************************************                         
  event go;                                                                                 
  function void start_monitoring(); // pragma tbx xtf      
     -> go;                                                                                 
  endfunction                                                                               
  
  // ****************************************************************************              
  initial begin                                                                             
     @go;                                                                                   
     forever begin                                                                          
        bit [ALU_OUT_RESULT_WIDTH-1:0] result;
        @(posedge clk_i);                                                                   

        do_monitor(
                   result                  );
        proxy.notify_transaction(
                   result                                );     
     end                                                                                    
  end                                                                                       

//******************************************************************
   function void configure(
          uvmf_active_passive_t active_passive,
          uvmf_initiator_responder_t   initiator_responder
); // pragma tbx xtf

   endfunction


// ****************************************************************************              
     task do_monitor(
                   output bit [ALU_OUT_RESULT_WIDTH-1:0] result);
// UVMF_CHANGE_ME : Implement protocol monitoring.
// Reference code;
//    while (control_signal == 1'b1) @(posedge clk_i);
//    xyz = done_i;  //     
//    xyz = result_i;  //    [ALU_OUT_RESULT_WIDTH-1:0] 

      //-start_time = $time + 1;
      while ( done_i == 1'b0 ) @(posedge clk_i);
      result = result_i;
      //-end_time = $time - 1;

     endtask         
  
endinterface
