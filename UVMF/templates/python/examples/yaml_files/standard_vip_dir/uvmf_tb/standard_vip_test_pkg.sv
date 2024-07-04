//
// File: standard_vip_test_pkg.sv
//
// Generated from Mentor VIP Configurator (20230807)
// Generated using Mentor VIP Library ( 2023.3_1 : 08/18/2023:20:00 )
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated environment.  The addQvipSubEnv function is added to 
// ## the python configuration file used by the UVMF environment generator.
// env.addQvipSubEnv('sub_env_instance_name', 'standard_vip', ['axi4_master_0'])
//
// ## The following code is used to add this qvip_configurator generated output into an
// ## encapsulating UVMF Generated test bench.  The addQvipBfm function is added to 
// ## the python configuration file used by the UVMF bench generator.
// ben.addQvipBfm('axi4_master_0', 'standard_vip', 'ACTIVE')
package standard_vip_test_pkg;
    import uvm_pkg::*;
    
    `include "uvm_macros.svh"
    
    import addr_map_pkg::*;
    
    import uvmf_base_pkg::*;
    import standard_vip_params_pkg::*;
    import mvc_pkg::*;
    import mgc_axi4_v1_0_pkg::*;
    import standard_vip_pkg::*;
    
    `include "standard_vip_vseq_base.svh"
    `include "standard_vip_test_base.svh"
    
endpackage: standard_vip_test_pkg
