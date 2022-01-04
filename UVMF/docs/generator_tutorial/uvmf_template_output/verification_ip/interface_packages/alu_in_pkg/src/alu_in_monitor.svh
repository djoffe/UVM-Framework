//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu_in interface agent
// Unit            : Interface UVM monitor
// File            : alu_in_monitor.svh
//----------------------------------------------------------------------
//     
// DESCRIPTION: This class receives alu_in transactions observed by the
//     alu_in monitor BFM and broadcasts them through the analysis port
//     on the agent. It accesses the monitor BFM through the monitor
//     task. This UVM component captures transactions
//     for viewing in the waveform viewer if the
//     enable_transaction_viewing flag is set in the configuration.
//
// ****************************************************************************
// ****************************************************************************
//----------------------------------------------------------------------
//
class alu_in_monitor  #(
      int ALU_IN_OP_WIDTH = 8                                
      ) extends uvmf_monitor_base #(
                    .CONFIG_T(alu_in_configuration  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ),
                    .BFM_BIND_T(virtual alu_in_monitor_bfm  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ),
                    .TRANS_T(alu_in_transaction  #(
                             .ALU_IN_OP_WIDTH(ALU_IN_OP_WIDTH)                                
                             ) ));

  `uvm_component_param_utils( alu_in_monitor #(
                              ALU_IN_OP_WIDTH
                            ))

// ****************************************************************************
// FUNCTION : new()
// This function is the standard SystemVerilog constructor.
//
  function new( string name = "", uvm_component parent = null );
    super.new( name, parent );
  endfunction

// ****************************************************************************
   virtual function void configure(input CONFIG_T cfg);
      bfm.configure(

          cfg.active_passive,
          cfg.initiator_responder
);                    
   
   endfunction

// ****************************************************************************
   virtual function void set_bfm_proxy_handle();
      bfm.proxy = this;
   endfunction

 // ****************************************************************************              
  virtual task run_phase(uvm_phase phase);                                                   
  // Start monitor BFM thread and don't call super.run() in order to                       
  // override the default monitor proxy 'pull' behavior with the more                      
  // emulation-friendly BFM 'push' approach using the notify_transaction                   
  // function below                                                                        
  bfm.start_monitoring();                                                   
  endtask                                                                                    
  
  // ****************************************************************************              
  virtual function void notify_transaction(
                        input alu_in_op_t op,  
                        input bit [ALU_IN_OP_WIDTH-1:0] a,  
                        input bit [ALU_IN_OP_WIDTH-1:0] b 
                        );
    trans = new("trans");                                                                   
    trans.start_time = time_stamp;                                                          
    trans.end_time = $time;                                                                 
    time_stamp = trans.end_time;                                                            
    trans.op = op;
    trans.a = a;
    trans.b = b;
    analyze(trans);                                                                         
  endfunction  

endclass
