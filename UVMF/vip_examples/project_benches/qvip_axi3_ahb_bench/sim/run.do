rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
rm -rfv veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
rm -rfv sv_connect.*
test -e work || vlib work 
echo "Compiling infrastructure files"
vlog -sv /home/student/tools/QVIP/10.4b/include/questa_mvc_svapi.svh
vlog  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/mvc_pkg.sv
echo "Compiling protocol package"
vlog +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ahb /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ahb/mgc_ahb_v2_0_pkg.sv
vlog +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/axi /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/axi/mgc_axi_v1_0_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/common/fli_pkg /mnt/hgfs/vmware/UVMF_Q/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/common/utility_packages/qvip_utils_pkg /mnt/hgfs/vmware/UVMF_Q/common/utility_packages/qvip_utils_pkg/qvip_utils_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/interface_packages/wb_pkg -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/interface_packages/wb_pkg/wb_filelist_hvl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/interface_packages/wb_pkg -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/interface_packages/wb_pkg/wb_filelist_hdl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/vip_axi3_ahb_env_pkg /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/vip_axi3_ahb_env_pkg/vip_axi3_ahb_env_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/parameters /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/parameters/axi3_ahb_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/sequences /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/sequences/axi3_ahb_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/tests /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/tests/axi3_ahb_test_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv /mnt/hgfs/vmware/UVMF_Q/common/modules/AXI_slave_v.v /mnt/hgfs/vmware/UVMF_Q/common/modules/ahb_memory_slave_module.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/testbench/clk_reset.sv /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/testbench/ahb_arbiter.sv  
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_axi3_ahb_bench/tb/testbench/top_filelist_hdl.f
vopt  +cover=sbcef+/hdl_top/DUT  hvl_top hdl_top   -o optimized_batch_top_tb
vopt  +acc   hvl_top hdl_top   -o optimized_debug_top_tb
vsim  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -t 1ns -coverage +notimingchecks -suppress 8887 -mvchome /home/student/tools/QVIP/10.4b -permit_unmatched_virtual_intf -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1  -do "run 0; do wave.do; radix hex showbase; run -all" optimized_debug_top_tb  &
