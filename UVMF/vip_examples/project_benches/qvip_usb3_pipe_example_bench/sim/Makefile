# *********************************************************************************************
# UVMF library directory:
# This variable points to the UVMF release where uvmf_base_pkg directory resides.
# This variable points to release code that is not user modified.
# This variable allows for UVMF release directories to reside independent of project related verification_ip and project_benches directories.
# This code below looks "upward" for directory starting with UVMF_* and returns first match for use with the release examples.
UVMF_HOME ?= $(firstword $(wildcard $(addsuffix /UVMF_*,. .. ../.. ../../.. ../../../.. ../../../../..)))

# Project(s) specific verification_ip library:
# Directory where reusable verification packages for interfaces, environments, utilities, etc. reside.
# This variable allows for verification_ip to reside independent of project bench and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/verification_ip
export UVMF_VIP_LIBRARY_HOME ?= ../../../verification_ip

# Project specific bench:
# Directory where bench specific code is located.
# This variable allows for project_benches to reside independent of verification_ip and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/project_benches/<example_bench>
export UVMF_PROJECT_DIR ?= ../../../project_benches/qvip_usb3_pipe_example_bench

#
# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

# Set project Variables
TEST_PLAN_NAME       = qvip_usb3_pipe_example_bench_TestPlan
REPORTING_DO_FILE    = qvip_usb3_pipe_example_bench_reports_script

# Include Makefile that includes targets for UVM Framework packages
include ${UVMF_HOME}/scripts/Makefile

include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/qvip_usb3_pipe_example_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS             += 
VLOG_ARGS             +=
VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=
BATCH_VOPT_ARGS       +=
DEBUG_VOPT_ARGS       +=
BATCH_VSIM_ARGS       += -mvchome ${QUESTA_MVC_HOME}
DEBUG_VSIM_ARGS       += -mvchome ${QUESTA_MVC_HOME}

# Do commands
DEBUG_DO_COMMANDS =     -do "set NoQuitOnFinish 1; onbreak {resume}; run 0; do wave.do; radix hex showbase; run -all"

# Project bench package source
qvip_usb3_pipe_example_bench_PARAMETERS_PKG = \
+incdir+${UVMF_PROJECT_DIR}/tb/parameters \
${UVMF_PROJECT_DIR}/tb/parameters/qvip_usb3_pipe_example_bench_parameters_pkg.sv

qvip_usb3_pipe_example_bench_SEQUENCES_PKG = \
+incdir+${UVMF_PROJECT_DIR}/tb/sequences \
${UVMF_PROJECT_DIR}/tb/sequences/qvip_usb3_pipe_example_bench_sequences_pkg.sv

qvip_usb3_pipe_example_bench_TEST_PKG = \
+incdir+${UVMF_PROJECT_DIR}/tb/tests \
${UVMF_PROJECT_DIR}/tb/tests/qvip_usb3_pipe_example_bench_test_pkg.sv

qvip_usb3_pipe_example_bench_DUT = \
${UVMF_PROJECT_DIR}/rtl/verilog/mac_device_dut.sv

.PHONY: all build common wrappers test run clean 

# Project bench package targets
comp_qvip_usb3_pipe_example_bench_parameters_pkg:
	vlog ${VLOG_ARGS} $(qvip_usb3_pipe_example_bench_PARAMETERS_PKG)

comp_qvip_usb3_pipe_example_bench_sequence_pkg:
	vlog ${VLOG_ARGS} $(qvip_usb3_pipe_example_bench_SEQUENCES_PKG)

comp_qvip_usb3_pipe_example_bench_test_pkg:
	vlog ${VLOG_ARGS} $(qvip_usb3_pipe_example_bench_TEST_PKG)

comp_qvip_usb3_pipe_example_bench_dut:
	vlog ${VLOG_ARGS} $(qvip_usb3_pipe_example_bench_DUT)

build_mvc:
	vlog  -sv ${QUESTA_MVC_HOME}/include/questa_mvc_svapi.svh
	vlog   +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv  ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv
	vlog   +define+USB_SS_USE_HOST_DB +define+BACKDOOR_ENUMERATION  +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv \
	+incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/USB3_0_SS +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/USB3_0_SS/host_sequence \
	${QUESTA_MVC_HOME}/questa_mvc_src/sv/USB3_0_SS/mgc_usb_ss_v3_0_pkg.sv
	vlog  +define+USB_SS_USE_HOST_DB +define+BACKDOOR_ENUMERATION  -sv \
	${QUESTA_MVC_HOME}/questa_mvc_src/sv/USB3_0_SS/analysis/usb_ss_ltssm_coverage_module.sv
	vlog  +define+USB_SS_USE_HOST_DB +define+BACKDOOR_ENUMERATION  -sv \
	${QUESTA_MVC_HOME}/questa_mvc_src/sv/USB3_0_SS/modules/usb_ss_phy_host.sv \
	${QUESTA_MVC_HOME}/questa_mvc_src/sv/USB3_0_SS/modules/usb_ss_mac_device.sv

build: comp_uvm_pkg build_mvc comp_fli_pkg comp_uvmf_base_pkg comp_qvip_utils_pkg comp_qvip_usb3_pipe_example_env_pkg comp_qvip_usb3_pipe_example_bench_parameters_pkg comp_qvip_usb3_pipe_example_bench_sequence_pkg comp_qvip_usb3_pipe_example_bench_test_pkg comp_qvip_usb3_pipe_example_bench_dut comp_test_bench


