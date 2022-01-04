rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
rm -rfv veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
rm -rfv sv_connect.*
test -e work || vlib work 
vlog  -sv /home/student/tools/QVIP/10.4b/include/questa_mvc_svapi.svh
vlog   +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv  /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/mvc_pkg.sv
vlog   +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/uart /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ethernet/mgc_ethernet_v1_0_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/common/fli_pkg /mnt/hgfs/vmware/UVMF_Q/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/qvip_ethernet_parallel_env_pkg /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/qvip_ethernet_parallel_env_pkg/qvip_ethernet_parallel_env_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/parameters /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/parameters/qvip_ethernet_parallel_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/sequences /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/sequences/qvip_ethernet_parallel_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/tests /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/tests/qvip_ethernet_parallel_test_pkg.sv
echo "Compiling QVIP Ethernet Parallel DUT"
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/rtl/verilog/ethernet_dummy_dut.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ethernet_parallel/tb/testbench/top_filelist_hdl.f
vopt  +cover=sbcef+/hdl_top/DUT  hvl_top hdl_top   -o optimized_batch_top_tb
vopt  +acc   hvl_top hdl_top   -o optimized_debug_top_tb
vsim  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -t 1ns -coverage +notimingchecks -suppress 8887  -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 -mvchome /home/student/tools/QVIP/10.4b -do " set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; radix hex showbase; " optimized_debug_top_tb  &
