rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
rm -rfv veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
rm -rfv sv_connect.*
test -e work || vlib work 
vlog  -sv /home/student/tools/QVIP/10.4b/include/questa_mvc_svapi.svh
vlog   +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv  /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/mvc_pkg.sv
vlog   +define+USB_SS_USE_HOST_DB +define+BACKDOOR_ENUMERATION  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv \
	+incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/USB3_0_SS +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/USB3_0_SS/host_sequence \
	/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/USB3_0_SS/mgc_usb_ss_v3_0_pkg.sv
vlog  +define+USB_SS_USE_HOST_DB +define+BACKDOOR_ENUMERATION  -sv \
	/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/USB3_0_SS/analysis/usb_ss_ltssm_coverage_module.sv
vlog  +define+USB_SS_USE_HOST_DB +define+BACKDOOR_ENUMERATION  -sv \
	/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/USB3_0_SS/modules/usb_ss_phy_host.sv \
	/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/USB3_0_SS/modules/usb_ss_mac_device.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/common/fli_pkg /mnt/hgfs/vmware/UVMF_Q/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/common/utility_packages/qvip_utils_pkg /mnt/hgfs/vmware/UVMF_Q/common/utility_packages/qvip_utils_pkg/qvip_utils_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/qvip_usb3_pipe_example_env_pkg /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/qvip_usb3_pipe_example_env_pkg/qvip_usb3_pipe_example_env_pkg.sv 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/parameters /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/parameters/qvip_usb3_pipe_example_bench_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/sequences /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/sequences/qvip_usb3_pipe_example_bench_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/tests /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/tests/qvip_usb3_pipe_example_bench_test_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/rtl/verilog/mac_device_dut.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_usb3_pipe_example_bench/tb/testbench/top_filelist_hdl.f
vopt  +cover=sbcef+/hdl_top/DUT  hvl_top hdl_top   -o optimized_batch_top_tb
vopt  +acc   hvl_top hdl_top   -o optimized_debug_top_tb
vsim  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -t 1ns -coverage +notimingchecks -suppress 8887 -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 -mvchome /home/student/tools/QVIP/10.4b -do "set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; radix hex showbase; run -all" optimized_debug_top_tb  &
