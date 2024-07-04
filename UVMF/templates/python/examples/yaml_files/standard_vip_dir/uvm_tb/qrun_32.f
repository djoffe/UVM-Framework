${QUESTA_MVC_HOME}/include/questa_mvc_svapi.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv +define+MAP_PROT_ATTR ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4 ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/mgc_axi4_v1_0_pkg.sv
+incdir+../config_policies ../config_policies/standard_vip_params_pkg.sv
standard_vip_pkg.sv
+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules ${QUESTA_MVC_HOME}/questa_mvc_src/sv/axi4/modules/axi4_master.sv
default_clk_gen.sv
default_reset_gen.sv
hdl_standard_vip.sv
hvl_standard_vip.sv
-debug
-designfile design.bin
-c
-mvchome ${QUESTA_MVC_HOME}
+nowarnTSCALE -t 1ns
-do "run -all; quit"
+UVM_TESTNAME=standard_vip_test_base
+SEQ=standard_vip_vseq_base
-qwavedb=+signal+transaction+class+uvm_schematic
