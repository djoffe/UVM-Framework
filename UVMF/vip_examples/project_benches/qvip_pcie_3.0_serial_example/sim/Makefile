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
export UVMF_PROJECT_DIR ?= ../../../project_benches/qvip_pcie_3.0_serial_example


# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

.PHONY: all clean 

# Include Makefile that includes targets for UVM Framework packages
include $(UVMF_HOME)/scripts/Makefile

include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/qvip_pcie_3_0_serial_example_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS            += 
VLOG_ARGS            +=
BATCH_VOPT_ARGS      +=
DEBUG_VOPT_ARGS      +=
BATCH_VSIM_ARGS      += -mvchome $(QUESTA_MVC_HOME)  -t 1fs
DEBUG_VSIM_ARGS      += -mvchome $(QUESTA_MVC_HOME)  -t 1fs

# Do commands
DEBUG_DO_COMMANDS = -do "set IterationLimit 140000; run 0; do wave.do; radix hex showbase; run -all"

REGRESSION_DO_COMMANDS     = -do " set IterationLimit 140000; set NoQuitOnFinish 1; onbreak {resume}; run -all; quit -f; "


# Project bench package source
QVIP_PCIE_SERIAL_PARAMETERS_PKG =\
+incdir+$(QUESTA_MVC_HOME)/examples/pcie/common \
+incdir+$(UVMF_PROJECT_DIR)/tb/parameters \
$(UVMF_PROJECT_DIR)/tb/parameters/qvip_pcie_3_0_serial_example_parameters_pkg.sv

QVIP_PCIE_SERIAL_SEQUENCES_PKG =\
+incdir+$(QUESTA_MVC_HOME)/examples/pcie/common \
+incdir+$(UVMF_PROJECT_DIR)/tb/sequences \
$(UVMF_PROJECT_DIR)/tb/sequences/qvip_pcie_3_0_serial_example_sequences_pkg.sv

QVIP_PCIE_SERIAL_TEST_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/tests \
$(UVMF_PROJECT_DIR)/tb/tests/qvip_pcie_3_0_serial_example_test_pkg.sv

QVIP_PCIE_SERIAL_DUT =\
+incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv \
$(QUESTA_MVC_HOME)/examples/pcie/common/pcie_ep_serial_dummy_dut.sv \

QVIP_PCIE_SERIAL_TB =\
+incdir+$(QUESTA_MVC_HOME)/examples/pcie/common \
+incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv \
$(QUESTA_MVC_HOME)/questa_mvc_src/sv/pcie/modules/pcie_rc_serial.sv \
$(QUESTA_MVC_HOME)/questa_mvc_src/sv/pcie/modules/ref_clk_generator.sv 

comp_qvip_pcie_serial_example_parameters_pkg:
	vlog $(VLOG_ARGS) $(QVIP_PCIE_SERIAL_PARAMETERS_PKG)

comp_qvip_pcie_serial_sequence_pkg:
	vlog $(VLOG_ARGS) $(QVIP_PCIE_SERIAL_SEQUENCES_PKG)

comp_qvip_pcie_serial_test_pkg:
	vlog $(VLOG_ARGS) $(QVIP_PCIE_SERIAL_TEST_PKG)

comp_qvip_pcie_serial_dut:
	vlog $(VLOG_ARGS) $(QVIP_PCIE_SERIAL_DUT)

comp_qvip_pcie_serial_bench:
	vlog $(VLOG_ARGS) $(QVIP_PCIE_SERIAL_TB)

build_mvc:
	echo "Compiling infrastructure files"
	vlog -sv $(QUESTA_MVC_HOME)/include/questa_mvc_svapi.svh
	vlog  +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv $(QUESTA_MVC_HOME)/questa_mvc_src/sv/mvc_pkg.sv
	echo "Compiling protocol package"
	vlog  +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv +incdir+$(QUESTA_MVC_HOME)/questa_mvc_src/sv/pcie $(QUESTA_MVC_HOME)/questa_mvc_src/sv/pcie/mgc_pcie_v2_0_pkg.sv

build: comp_uvm_pkg build_mvc comp_fli_pkg comp_uvmf_base_pkg comp_qvip_utils_pkg comp_vip_pcie_3_0_serial_env_pkg comp_qvip_pcie_serial_example_parameters_pkg comp_qvip_pcie_serial_sequence_pkg comp_qvip_pcie_serial_test_pkg comp_qvip_pcie_serial_bench comp_qvip_pcie_serial_dut comp_test_bench


