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
export UVMF_PROJECT_DIR ?= ../../../project_benches/qvip_ethernet_serial

#
# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

# Usage of Veloce, etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0
USE_LEGACY_TBX_FLOW ?= 0

# Set project Variables
TEST_PLAN_NAME       = qvip_ethernet_serial_TestPlan
REPORTING_DO_FILE    = qvip_ethernet_serial_reports_script

# Include makefile that includes targets for UVM_VIP_Library packages
include $(UVMF_HOME)/scripts/Makefile

# Include all requisite interface package targets for this bench

# Include all requisite environment package targets for this bench
include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/qvip_ethernet_serial_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS             += 
VLOG_ARGS             +=
VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=

BATCH_VOPT_ARGS       +=
DEBUG_VOPT_ARGS       +=

COMMON_VSIM_ARGS      += -mvchome ${QUESTA_MVC_HOME} -t ps
BATCH_VSIM_ARGS       +=
DEBUG_VSIM_ARGS       +=

# Do commands
                      DEBUG_DO_COMMANDS =     -do " \
                      set NoQuitOnFinish 1; \
                      onbreak {resume}; \
                      run 0; \
                      do wave.do; \
                      radix hex showbase;  \
                      "
                      # run -all; \

# Project bench package source
qvip_ethernet_serial_PARAMETERS_PKG =\
$(UVMF_PROJECT_DIR)/tb/parameters/qvip_ethernet_serial_parameters_pkg.sv

qvip_ethernet_serial_SEQUENCES_PKG =\
$(UVMF_PROJECT_DIR)/tb/sequences/qvip_ethernet_serial_sequences_pkg.sv

qvip_ethernet_serial_TEST_PKG =\
$(UVMF_PROJECT_DIR)/tb/tests/qvip_ethernet_serial_test_pkg.sv

qvip_ethernet_serial_DUT =\
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/xge_mac.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/rx_enqueue.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/rx_dequeue.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/rx_data_fifo.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/rx_hold_fifo.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/tx_enqueue.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/tx_dequeue.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/tx_data_fifo.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/tx_hold_fifo.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/fault_sm.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/sync_clk_wb.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/sync_clk_xgmii_tx.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/stats.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/wishbone_if.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/generic_fifo.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/generic_fifo_ctrl.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/generic_mem_medium.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/generic_mem_small.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/meta_sync.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/meta_sync_single.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/tx_stats_fifo.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/rx_stats_fifo.v \
$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/verilog/stats_sm.v \

.PHONY: all build common wrappers test run clean 


# Project bench package targets
COMP_qvip_ethernet_serial_PARAMETERS_PKG_TGT_0 = q_comp_qvip_ethernet_serial_parameters_pkg
COMP_qvip_ethernet_serial_PARAMETERS_PKG_TGT_1 = v_comp_qvip_ethernet_serial_parameters_pkg
COMP_qvip_ethernet_serial_PARAMETERS_PKG_TGT = $(COMP_qvip_ethernet_serial_PARAMETERS_PKG_TGT_$(USE_VELOCE))

comp_qvip_ethernet_serial_parameters_pkg: $(COMP_qvip_ethernet_serial_PARAMETERS_PKG_TGT)

q_comp_qvip_ethernet_serial_parameters_pkg:
	        $(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/parameters $(qvip_ethernet_serial_PARAMETERS_PKG)

v_comp_qvip_ethernet_serial_parameters_pkg: q_comp_qvip_ethernet_serial_parameters_pkg
	$(HDL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/parameters $(qvip_ethernet_serial_PARAMETERS_PKG)

comp_qvip_ethernet_serial_sequence_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/sequences $(qvip_ethernet_serial_SEQUENCES_PKG)

comp_qvip_ethernet_serial_test_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/tb/tests $(qvip_ethernet_serial_TEST_PKG)

comp_qvip_ethernet_serial_dut:
	echo "Compile your DUT here"
	$(HDL_COMP_CMD) +incdir+$(UVMF_PROJECT_DIR)/rtl/verilog/xge_mac/trunk/rtl/include $(qvip_ethernet_serial_DUT)

build_qvip:
	vlog  -sv ${QUESTA_MVC_HOME}/include/questa_mvc_svapi.svh
	vlog   +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv  ${QUESTA_MVC_HOME}/questa_mvc_src/sv/mvc_pkg.sv
	vlog   +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv +incdir+${QUESTA_MVC_HOME}/questa_mvc_src/sv/ethernet ${QUESTA_MVC_HOME}/questa_mvc_src/sv/ethernet/mgc_ethernet_v1_0_pkg.sv

build: comp_uvm_pkg build_qvip comp_fli_pkg comp_uvmf_base_pkg  comp_qvip_ethernet_serial_env_pkg comp_qvip_ethernet_serial_parameters_pkg comp_qvip_ethernet_serial_sequence_pkg comp_qvip_ethernet_serial_test_pkg comp_qvip_ethernet_serial_dut comp_test_bench


