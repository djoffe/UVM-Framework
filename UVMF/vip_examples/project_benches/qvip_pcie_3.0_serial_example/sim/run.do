rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
rm -rfv veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
rm -rfv sv_connect.*
test -e work || vlib work 
echo "Compiling infrastructure files"
vlog -sv /home/student/tools/QVIP/10.4b/include/questa_mvc_svapi.svh
vlog  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/mvc_pkg.sv
echo "Compiling protocol package"
vlog  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/pcie /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/pcie/mgc_pcie_v2_0_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/common/fli_pkg /mnt/hgfs/vmware/UVMF_Q/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/common/utility_packages/qvip_utils_pkg /mnt/hgfs/vmware/UVMF_Q/common/utility_packages/qvip_utils_pkg/qvip_utils_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/interface_packages/wb_pkg -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/interface_packages/wb_pkg/wb_filelist_hvl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/interface_packages/wb_pkg -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/interface_packages/wb_pkg/wb_filelist_hdl.f 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/home/student/tools/QVIP/10.4b/examples/pcie/common +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/qvip_pcie_3_0_serial_example_env_pkg /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/qvip_pcie_3_0_serial_example_env_pkg/qvip_pcie_3_0_serial_example_env_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/examples/pcie/common +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/parameters /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/parameters/qvip_pcie_3_0_serial_example_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/examples/pcie/common +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/sequences /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/sequences/qvip_pcie_3_0_serial_example_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/tests /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/tests/qvip_pcie_3_0_serial_example_test_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/examples/pcie/common +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/pcie/modules/pcie_rc_serial.sv /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/pcie/modules/ref_clk_generator.sv 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv /home/student/tools/QVIP/10.4b/examples/pcie/common/pcie_ep_serial_dummy_dut.sv 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_pcie_3.0_serial_example/tb/testbench/top_filelist_hdl.f
vopt  +cover=sbcef+/hdl_top/DUT  hvl_top hdl_top   -o optimized_batch_top_tb
vopt  +acc   hvl_top hdl_top   -o optimized_debug_top_tb
vsim  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -t 1ns -coverage +notimingchecks -suppress 8887 -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 -mvchome /home/student/tools/QVIP/10.4b  -t 1fs -do "set IterationLimit 140000; run 0; do wave.do; radix hex showbase; run -all" optimized_debug_top_tb  &
