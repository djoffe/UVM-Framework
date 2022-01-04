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
export UVMF_PROJECT_DIR ?= ../../../project_benches/qvip_axi3_example

#
# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

.PHONY: all clean 

# Include Makefile that includes targets for UVM Framework packages
include $(UVMF_HOME)/scripts/Makefile

include $(UVMF_HOME)/base_examples/verification_ip/interface_packages/wb_pkg/Makefile
include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/vip_axi3_example_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS            += 
VLOG_ARGS            +=
BATCH_VOPT_ARGS      +=
DEBUG_VOPT_ARGS      +=
COMMON_VSIM_ARGS     += -mvchome $(QUESTA_MVC_HOME) -permit_unmatched_virtual_intf
BATCH_VSIM_ARGS      +=
DEBUG_VSIM_ARGS      +=

# Do commands
DEBUG_DO_COMMANDS = -do "run 0; do wave.do; radix hex showbase; run -all"

# Project bench package source
QVIP_AXI3_PARAMETERS_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/parameters \
$(UVMF_PROJECT_DIR)/tb/parameters/qvip_axi3_example_parameters_pkg.sv

QVIP_AXI3_SEQUENCES_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/sequences \
$(UVMF_PROJECT_DIR)/tb/sequences/qvip_axi3_example_sequences_pkg.sv

QVIP_AXI3_TEST_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/tests \
$(UVMF_PROJECT_DIR)/tb/tests/qvip_axi3_example_test_pkg.sv

QVIP_AXI3_DUT =\
+incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv \
$(UVMF_HOME)/common/modules/AXI_slave_v.v

QVIP_AXI3_TB =\
+incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv \
$(UVMF_PROJECT_DIR)/tb/testbench/clk_reset.sv  

# Project bench package targets
comp_qvip_axi3_parameters_pkg:
	vlog $(VLOG_ARGS) $(QVIP_AXI3_PARAMETERS_PKG)

comp_qvip_axi3_sequence_pkg:
	vlog $(VLOG_ARGS) $(QVIP_AXI3_SEQUENCES_PKG)

comp_qvip_axi3_test_pkg:
	vlog $(VLOG_ARGS) $(QVIP_AXI3_TEST_PKG)

comp_qvip_axi3_dut:
	vlog $(VLOG_ARGS) $(QVIP_AXI3_DUT)

comp_qvip_axi3_bench:
	vlog $(VLOG_ARGS) $(QVIP_AXI3_TB)

comp_qvip_infrastructure:
	echo "Compiling infrastructure files"
	vlog -sv $(QUESTA_MVC_HOME)/include/questa_mvc_svapi.svh
	vlog  +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv $(QUESTA_MVC_HOME)/questa_mvc_src/sv/mvc_pkg.sv

comp_qvip_axi3_protocol:
	echo "Compiling protocol package"
	vlog +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi $(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi/mgc_axi_v1_0_pkg.sv

comp_axi3_modules:
	echo "Compiling testbench"
	vlog +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv  $(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi/modules/axi_master.sv
	vlog +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv  $(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi/modules/axi_slave.sv
	vlog +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv  $(QUESTA_MVC_HOME)/questa_mvc_src/sv/axi/modules/axi_monitor.sv

build_mvc: comp_qvip_infrastructure comp_qvip_axi3_protocol comp_axi3_modules

build: comp_uvm_pkg build_mvc comp_fli_pkg comp_uvmf_base_pkg comp_qvip_utils_pkg comp_wb_pkg comp_vip_axi3_env_pkg comp_qvip_axi3_parameters_pkg comp_qvip_axi3_sequence_pkg comp_qvip_axi3_test_pkg comp_qvip_axi3_dut comp_qvip_axi3_bench comp_test_bench


