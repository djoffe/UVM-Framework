//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu Simulation Bench 
// Unit            : HDL top level module
// File            : hdl_top.sv
//----------------------------------------------------------------------
//                                          
// Description: This top level module instantiates all synthesizable
//    static content.  This and tb_top.sv are the two top level modules
//    of the simulation.  
//
//    This module instantiates the following:
//        DUT: The Design Under Test
//        Interfaces:  Signal bundles that contain signals connected to DUT
//        Driver BFM's: BFM's that actively drive interface signals
//        Monitor BFM's: BFM's that passively monitor interface signals
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

import alu_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;



module hdl_top;
// pragma attribute hdl_top partition_module_xrtl                                            


bit rst = 0;
bit clk;
   // Instantiate a clk driver 
   // tbx clkgen
   initial begin
      #9ns;
      clk = ~clk;
      forever #5ns clk = ~clk;
   end
   // Instantiate a rst driver
   initial begin
      #200ns;
      rst <= ~rst;
   end



// Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
// The signal bundle, _if, contains signals to be connected to the DUT.
// The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
// The driver, driver_bfm, drives transactions onto the bus, _if.

alu_in_if  alu_in_agent_bus(.clk(clk), .rst(rst));
alu_out_if  alu_out_agent_bus(.clk(clk), .rst(rst));

alu_in_monitor_bfm  alu_in_agent_mon_bfm(alu_in_agent_bus);
alu_out_monitor_bfm  alu_out_agent_mon_bfm(alu_out_agent_bus);

alu_in_driver_bfm  alu_in_agent_drv_bfm(alu_in_agent_bus);


// UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
// Instantiate DUT here
  alu   #(.OP_WIDTH(8), .RESULT_WIDTH(16)) DUT  (
       // AHB connections
      .clk    (alu_in_agent_bus.clk ) ,
      .rst    (alu_in_agent_bus.alu_rst ) ,
      .ready  (alu_in_agent_bus.ready ) ,
      .valid  (alu_in_agent_bus.valid ) ,
      .op     (alu_in_agent_bus.op ) ,
      .a      (alu_in_agent_bus.a ) ,
      .b      (alu_in_agent_bus.b ) ,
      .done   (alu_out_agent_bus.done ) ,
      .result (alu_out_agent_bus.result ) );

initial begin  // tbx vif_binding_block 
    import uvm_pkg::uvm_config_db;
// The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
// They are placed into the uvm_config_db using the string names defined in the parameters package.
// The string names are passed to the agent configurations by test_top through the top level configuration.
// They are retrieved by the agents configuration class for use by the agent.

uvm_config_db #( virtual alu_in_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , alu_in_pkg_alu_in_agent_BFM , alu_in_agent_mon_bfm ); 
uvm_config_db #( virtual alu_out_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , alu_out_pkg_alu_out_agent_BFM , alu_out_agent_mon_bfm ); 

uvm_config_db #( virtual alu_in_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , alu_in_pkg_alu_in_agent_BFM , alu_in_agent_drv_bfm  );


  end

endmodule

