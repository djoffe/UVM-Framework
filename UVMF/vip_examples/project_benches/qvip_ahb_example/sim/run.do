rm -rfv *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf transcript covhtmlreport VRMDATA
rm -rfv veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
rm -rfv sv_connect.*
test -e work || vlib work 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/common/fli_pkg /mnt/hgfs/vmware/UVMF_Q/common/fli_pkg/fli_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg -F /mnt/hgfs/vmware/UVMF_Q/uvmf_base_pkg/uvmf_base_pkg_filelist_hdl.f
echo "Compiling infrastructure files"
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  -sv /home/student/tools/QVIP/10.4b/include/questa_mvc_svapi.svh
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv  /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/mvc_pkg.sv
echo "Compiling protocol package"
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ahb /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ahb/mgc_ahb_v2_0_pkg.sv
echo "Compiling protocol modules"
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ahb/modules/ahb_master.sv /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ahb/modules/ahb_slave.sv /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ahb/modules/ahb_decoder.sv /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/ahb/modules/ahb_monitor.sv 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv /home/student/tools/QVIP/10.4b/include/questa_mvc_svapi.svh /home/student/tools/QVIP/10.4b/questa_mvc_src/sv/mvc_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/parameters /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/parameters/qvip_ahb_example_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/qvip_ahb_example_env_pkg /mnt/hgfs/vmware/UVMF_Q/qvip_examples/verification_ip/environment_packages/qvip_ahb_example_env_pkg/qvip_ahb_example_env_pkg.sv 
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/sequences /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/sequences/qvip_ahb_example_sequences_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/tests /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/tests/qvip_ahb_example_test_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/rtl/verilog/ahb_verilog_decoder.v /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/rtl/verilog/ahb_verilog_master.v /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/rtl/verilog/ahb_verilog_slave.v /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/rtl/verilog/clk_reset.sv
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/home/student/tools/QVIP/10.4b/questa_mvc_src/sv +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/testbench/top_filelist_hvl.f
vlog -sv -suppress 2223 -suppress 2286 -timescale 1ns/10ps  +incdir+/mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/testbench -F /mnt/hgfs/vmware/UVMF_Q/qvip_examples/project_benches/qvip_ahb_example/tb/testbench/top_filelist_hdl.f
vopt  +cover=sbcef+/hdl_top/DUT  hvl_top hdl_top   -o optimized_batch_top_tb
vopt  +acc   hvl_top hdl_top   -o optimized_debug_top_tb
vsim  -sv_seed random +UVM_TESTNAME=test_top +UVM_VERBOSITY=UVM_HIGH  -t 1ns -coverage +notimingchecks -suppress 8887 -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 -mvchome /home/student/tools/QVIP/10.4b -do "set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; radix hex showbase; run -all" optimized_debug_top_tb  &
