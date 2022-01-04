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
export UVMF_VIP_LIBRARY_HOME ?= ../../..//verification_ip

# Project specific bench:
# Directory where bench specific code is located.
# This variable allows for project_benches to reside independent of verification_ip and UVMF release directories.
# For examples deployed with UVMF this will be $(UVMF_HOME)/<example_group>/project_benches/<example_bench>
export UVMF_PROJECT_DIR ?= ../../..//project_benches/qvip_ahb_example

#
# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

# Set project Variables
TEST_PLAN_NAME       = qvip_ahb_example_TestPlan
REPORTING_DO_FILE    = qvip_ahb_example_reports_script

# Include Makefile that includes targets for UVM Framework packages
include ${UVMF_HOME}/scripts/Makefile

include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/qvip_ahb_example_env_pkg/Makefile

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
qvip_ahb_example_PARAMETERS_PKG = ${UVMF_PROJECT_DIR}/tb/parameters/qvip_ahb_example_parameters_pkg.sv

qvip_ahb_example_SEQUENCES_PKG = ${UVMF_PROJECT_DIR}/tb/sequences/qvip_ahb_example_sequences_pkg.sv

qvip_ahb_example_TEST_PKG = ${UVMF_PROJECT_DIR}/tb/tests/qvip_ahb_example_test_pkg.sv

qvip_ahb_example_DUT = ${UVMF_PROJECT_DIR}/rtl/verilog/ahb_verilog_decoder.v \
                       ${UVMF_PROJECT_DIR}/rtl/verilog/ahb_verilog_master.v \
                       ${UVMF_PROJECT_DIR}/rtl/verilog/ahb_verilog_slave.v \
                       ${UVMF_PROJECT_DIR}/rtl/verilog/clk_reset.sv

qvip_ahb_connectivity_modules = ${QUESTA_MVC_HOME}/questa_mvc_src/sv/ahb/modules/ahb_master.sv \
                                ${QUESTA_MVC_HOME}/questa_mvc_src/sv/ahb/modules/ahb_slave.sv \
                                ${QUESTA_MVC_HOME}/questa_mvc_src/sv/ahb/modules/ahb_decoder.sv \
                                ${QUESTA_MVC_HOME}/questa_mvc_src/sv/ahb/modules/ahb_monitor.sv 

.PHONY: all build common wrappers test run clean 

# Project bench package targets
comp_qvip_ahb_example_parameters_pkg:
	vlog ${VLOG_ARGS} +incdir+${UVMF_PROJECT_DIR}/tb/parameters $(qvip_ahb_example_PARAMETERS_PKG)

vel_comp_qvip_ahb_example_parameters_pkg:
	vlog ${VLOG_ARGS} +incdir+${UVMF_PROJECT_DIR}/tb/parameters $(qvip_ahb_example_PARAMETERS_PKG)
	velanalyze ${VELANALYZE_ARGS} +incdir+${UVMF_PROJECT_DIR}/tb/parameters $(qvip_ahb_example_PARAMETERS_PKG)

comp_qvip_ahb_example_sequence_pkg:
	vlog ${VLOG_ARGS} +incdir+${UVMF_PROJECT_DIR}/tb/sequences $(qvip_ahb_example_SEQUENCES_PKG)

comp_qvip_ahb_example_test_pkg:
	vlog ${VLOG_ARGS} +incdir+${UVMF_PROJECT_DIR}/tb/tests $(qvip_ahb_example_TEST_PKG)

comp_qvip_ahb_example_dut:
	vlog ${VLOG_ARGS} $(qvip_ahb_example_DUT)

vel_comp_qvip_ahb_example_dut:
	velanalyze ${VELANALYZE_ARGS} $(qvip_ahb_example_DUT)

comp_qvip_infrastructure:
	echo "Compiling infrastructure files"
	vlog ${VLOG_ARGS} -sv ${QUESTA_MVC_HOME}/include/questa_mvc_svapi.svh
	vlog ${VLOG_ARGS} +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv  ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv

comp_qvip_ahb_protocol:
	echo "Compiling protocol package"
	vlog ${VLOG_ARGS} +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv  +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/ahb ${QUESTA_MVC_HOME}/questa_mvc_src/sv/ahb/mgc_ahb_v2_0_pkg.sv

comp_qvip_ahb_connectivity_modules:
	echo "Compiling protocol modules"
	vlog ${VLOG_ARGS} $(qvip_ahb_connectivity_modules)
	
build_mvc: comp_qvip_infrastructure comp_qvip_ahb_protocol comp_qvip_ahb_connectivity_modules
comp_vip_base_pkg: build_mvc

vel_build: vel_comp_uvm_pkg vel_comp_fli_pkg vel_comp_uvmf_base_pkg  vel_comp_qvip_ahb_example_env_pkg vel_comp_qvip_ahb_example_parameters_pkg comp_qvip_ahb_example_sequence_pkg comp_qvip_ahb_example_test_pkg vel_comp_qvip_ahb_example_dut vel_comp_test_bench

build: comp_fli_pkg comp_uvmf_base_pkg comp_vip_base_pkg comp_qvip_ahb_example_parameters_pkg comp_qvip_ahb_example_env_pkg comp_qvip_ahb_example_sequence_pkg comp_qvip_ahb_example_test_pkg comp_qvip_ahb_example_dut comp_test_bench


