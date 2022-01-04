//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface Monitor BFM
// File            : alu_in_monitor_bfm.sv
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface performs the alu_in signal monitoring.
//      It is accessed by the uvm alu_in monitor through a virtual
//      interface handle in the alu_in configuration.  It monitors the
//      signals passed in through the port connection named bus of
//      type alu_in_if.
//
//     Input signals from the alu_in_if are assigned to an internal input
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
//                   blocks until an operation on the alu_in bus is complete.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
import uvmf_base_pkg_hdl::*;
import alu_in_pkg_hdl::*;

interface alu_in_monitor_bfm       #(
      int ALU_IN_OP_WIDTH = 8                                
      )
( alu_in_if  bus );
// pragma attribute alu_in_monitor_bfm partition_interface_xif                                  
// The above pragma and additional ones in-lined below are for running this BFM on Veloce


   tri        clk_i;
   tri        rst_i;
   tri         alu_rst_i;
   tri         ready_i;
   tri         valid_i;
   tri        [2:0] op_i;
   tri        [ALU_IN_OP_WIDTH-1:0] a_i;
   tri        [ALU_IN_OP_WIDTH-1:0] b_i;

   assign     clk_i    =   bus.clk;
   assign     rst_i    =   bus.rst;
   assign     alu_rst_i = bus.alu_rst;
   assign     ready_i = bus.ready;
   assign     valid_i = bus.valid;
   assign     op_i = bus.op;
   assign     a_i = bus.a;
   assign     b_i = bus.b;

   // Proxy handle to UVM monitor
   alu_in_pkg::alu_in_monitor  #(
              .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
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
        alu_in_op_t op;
        bit [ALU_IN_OP_WIDTH-1:0] a;
        bit [ALU_IN_OP_WIDTH-1:0] b;
        @(posedge clk_i);                                                                   

        do_monitor(
                   op,
                   a,
                   b                  );
        proxy.notify_transaction(
                   op,
                   a,
                   b                                );     
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
                   output alu_in_op_t op,
                   output bit [ALU_IN_OP_WIDTH-1:0] a,
                   output bit [ALU_IN_OP_WIDTH-1:0] b                    );
// UVMF_CHANGE_ME : Implement protocol monitoring.
// Reference code;
//    while (control_signal == 1'b1) @(posedge clk_i);
//    xyz = alu_rst_i;  //     
//    xyz = ready_i;  //     
//    xyz = valid_i;  //     
//    xyz = op_i;  //    [2:0] 
//    xyz = a_i;  //    [ALU_IN_OP_WIDTH-1:0] 
//    xyz = b_i;  //    [ALU_IN_OP_WIDTH-1:0] 

      //-start_time = $time;
        // Hold here until signal event happens to capture bus values
	  while (valid_i == 1'b0 && alu_rst_i == 1'b1) begin
	    @(posedge clk_i);
	  end
      op = alu_in_op_t'(op_i);
      a  = a_i;
      b  = b_i;

      if (alu_rst_i == 1'b0) begin
	  	  while (alu_rst_i == 1'b0) begin
    		  @(posedge clk_i);
		  end
	  end else
         @(posedge clk_i);
      //-end_time = $time;

     endtask         
  
endinterface
