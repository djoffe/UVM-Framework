//----------------------------------------------------------------------
//----------------------------------------------------------------------
// Created by      : graemej
// Creation Date   : 2017 Sep 03
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
// Project         : alu Simulation Bench 
// Unit            : Bench level parameters package
// File            : alu_parameters_pkg.sv
//----------------------------------------------------------------------
// 
//                                         
//----------------------------------------------------------------------
//

package alu_parameters_pkg;

import uvmf_base_pkg_hdl::*;


// These parameters are used to uniquely identify each interface.  The monitor_bfm and
// driver_bfm are placed into and retrieved from the uvm_config_db using these string 
// names as the field_name. The parameter is also used to enable transaction viewing 
// from the command line for selected interfaces using the UVM command line processing.

parameter string alu_in_pkg_alu_in_agent_BFM  = "alu_in_pkg_alu_in_agent_BFM"; /* [0] */
parameter string alu_out_pkg_alu_out_agent_BFM  = "alu_out_pkg_alu_out_agent_BFM"; /* [1] */

string interface_names[] = {
    alu_in_pkg_alu_in_agent_BFM /* alu_in_agent     [0] */ , 
    alu_out_pkg_alu_out_agent_BFM /* alu_out_agent     [1] */ 
};

uvmf_active_passive_t interface_activities[] = { 
    ACTIVE /* alu_in_agent     [0] */ , 
    PASSIVE /* alu_out_agent     [1] */ 
};



endpackage

