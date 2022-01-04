//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : dbole
// Creation Date   : 2015 Oct 14
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : qvip_ethernet_serial Simulation Bench 
// Unit            : Bench level parameters package
// File            : qvip_ethernet_serial_parameters_pkg.sv
//----------------------------------------------------------------------
//                                          
//----------------------------------------------------------------------
//

package qvip_ethernet_serial_parameters_pkg;

// These parameters are used to uniquely identify each interface.  The monitor_bfm and
// driver_bfm are placed into and retrieved from the uvm_config_db using these string 
// names as the field_name. The parameter is also used to enable transaction viewing 
// from the command line for selected interfaces using the UVM command line processing.

parameter string ETH_10G_IF  = "ETH_10G_IF";
endpackage

