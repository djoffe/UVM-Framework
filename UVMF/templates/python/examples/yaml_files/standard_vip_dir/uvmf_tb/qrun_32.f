export STANDARD_VIP_DIR_NAME=$(pwd)/../uvmf

qrun -f standard_vip_test_filelist.f \
../uvmf/hdl_standard_vip.sv \
../uvmf/hvl_standard_vip.sv \
-debug \
-designfile design.bin \
-c \
-mvchome ${QUESTA_MVC_HOME} \
+nowarnTSCALE -t 1ns \
-do "run -all; quit" \
+UVM_TESTNAME=standard_vip_test_base \
+SEQ=standard_vip_vseq_base \
-qwavedb=+signal+transaction+class+uvm_schematic
