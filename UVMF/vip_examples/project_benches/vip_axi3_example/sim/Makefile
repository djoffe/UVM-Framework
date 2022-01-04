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
export UVMF_PROJECT_DIR ?= ../../../project_benches/vip_axi3_example

#
# *********************************************************************************************
# Set test case specific Variables
TEST_NAME            = test_top
TEST_SEED            = random
TEST_VERBOSITY       = UVM_HIGH
UVM_CLI_ARGS         = 

# Usage of Veloce, VTL etc. to be input by the user (subject to defaults)
USE_VELOCE          ?= 0
USE_VTL             ?= $(USE_VELOCE)
USE_LEGACY_TBX_FLOW ?= 0
USE_64BIT_PLATFORM  ?= 1

PROTOCOL = axi

.PHONY: all clean 

# Include Makefile that includes targets for UVM Framework packages
include $(UVMF_HOME)/scripts/Makefile

include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/vip_axi3_example_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS            += 
VLOG_ARGS_1          += +define+QVIP_PRE_10_4_BACKWARD_COMPATIBLE
VLOG_ARGS            += #-tbxhvllint
VELANALYZE_ARGS      +=
VELANALYZE_HVL_ARGS  +=

BATCH_VOPT_ARGS      +=
DEBUG_VOPT_ARGS      +=
COMMON_VSIM_ARGS     += -mvchome $(VIP_HOME) -permit_unmatched_virtual_intf -tbxhvllint
BATCH_VSIM_ARGS      +=
DEBUG_VSIM_ARGS      +=
LINK_ARGS            +=

VELOCE_XACTOR_LIBS = $(VELOCE_XACTOR_HOME)/$(PROTOCOL)/lib/$(LIB_PLATFORM)/lib$(PROTOCOL)_IN_XRTL_MTI_full.so #lib$(PROTOCOL)_IN_SystemVerilog_MTI_full.so

# Do commands
DEBUG_DO_COMMANDS = -do "run 0; do wave.do; radix hex showbase; run -all"

# Project bench package source
VIP_AXI3_PARAMETERS_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/parameters \
$(UVMF_PROJECT_DIR)/tb/parameters/vip_axi3_example_parameters_pkg.sv

VIP_AXI3_SEQUENCES_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/sequences \
$(UVMF_PROJECT_DIR)/tb/sequences/vip_axi3_example_sequences_pkg.sv

VIP_AXI3_TEST_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/tests \
$(UVMF_PROJECT_DIR)/tb/tests/vip_axi3_example_test_pkg.sv

VIP_AXI3_DUT =\
$(UVMF_HOME)/common/modules/AXI_slave_v.v

VIP_AXI3_TB =\
$(UVMF_PROJECT_DIR)/tb/testbench/clk_reset.sv  

# VIP source
VIP_AXI3_QVIP =\
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL) \
+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/mgc_$(PROTOCOL)_v1_0_pkg.sv \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_master.sv \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_slave.sv \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_monitor.sv

VIP_AXI3_VVIP_HVL =\
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL) \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/mgc_$(PROTOCOL)_v1_0_pkg.sv

VIP_AXI3_VVIP_HDL =\
+incdir+$(VELOCE_XACTOR_HOME)/$(PROTOCOL) \
+incdir+$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)_IN_XRTL.sv \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)_master_XRTL_module.sv \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)_slave_XRTL_module.sv \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)__monitor_XRTL_module.sv
#Hans: below files are idential copies - which is the recommended location?
#+incdir+$(VIP_HOME)/questa_mvc_src/sv \
#+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL) \
#+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules \
#$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_master_XRTL_module.sv \
#$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)_slave_XRTL_module.sv \
#$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/modules/$(PROTOCOL)__monitor_XRTL_module.sv

VIP_AXI3_HVL =\
+incdir+$(UVMF_HOME)/common/mgc_vip \
+incdir+$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL) \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_master_hvl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_slave_hvl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_monitor_hvl.sv

VIP_AXI3_HDL =\
+incdir+$(UVMF_HOME)/mgc_vip \
+incdir+$(UVMF_HOME)/mgc_vip/$(PROTOCOL) \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_signal_if.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_master_hdl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_slave_hdl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_monitor_hdl.sv

# Project bench package targets
COMP_VIP_AXI3_PARAMETERS_PKG_TGT_0 = q_comp_vip_axi3_parameters_pkg
COMP_VIP_AXI3_PARAMETERS_PKG_TGT_1 = v_comp_vip_axi3_parameters_pkg
COMP_VIP_AXI3_PARAMETERS_PKG_TGT   = $(COMP_VIP_AXI3_PARAMETERS_PKG_TGT_$(USE_VELOCE))

comp_vip_axi3_parameters_pkg: $(COMP_VIP_AXI3_PARAMETERS_PKG_TGT)

q_comp_vip_axi3_parameters_pkg:
	$(HVL_COMP_CMD) $(VIP_AXI3_PARAMETERS_PKG)

v_comp_vip_axi3_parameters_pkg: q_comp_vip_axi3_parameters_pkg
	$(HDL_COMP_CMD) $(VIP_AXI3_PARAMETERS_PKG)

comp_vip_axi3_sequence_pkg:
	$(HVL_COMP_CMD) $(VIP_AXI3_SEQUENCES_PKG)

comp_vip_axi3_test_pkg:
	$(HVL_COMP_CMD) $(VIP_AXI3_TEST_PKG)

comp_vip_axi3_dut:
	$(HDL_COMP_CMD) $(VIP_AXI3_DUT)

comp_vip_axi3_bench:
	$(HDL_COMP_CMD) $(VIP_AXI3_TB)

# VIP targets
COMP_VIP_AXI3_TGT_0 = comp_vip_axi3_qvip
COMP_VIP_AXI3_TGT_1 = comp_vip_axi3_vvip
COMP_VIP_AXI3_TGT   = $(COMP_VIP_AXI3_TGT_$(USE_VTL))

comp_vip_axi3: $(COMP_VIP_AXI3_TGT)
	$(HVL_COMP_CMD) $(VIP_AXI3_HVL)
	$(HDL_COMP_CMD) $(VIP_AXI3_HDL)

comp_vip_axi3_qvip: comp_vip_base_pkg
	$(HVL_COMP_CMD) $(VIP_AXI3_QVIP)

comp_vip_axi3_vvip: comp_vip_base_pkg comp_vtl_base_pkg
	$(HVL_COMP_CMD) $(VIP_AXI3_VVIP_HVL)
	$(HDL_COMP_CMD) $(VIP_AXI3_VVIP_HDL)

build: comp_vip_axi3 comp_uvm_pkg comp_fli_pkg comp_uvmf_base_pkg comp_qvip_utils_pkg comp_vip_axi3_env_pkg comp_vip_axi3_parameters_pkg comp_vip_axi3_sequence_pkg comp_vip_axi3_test_pkg comp_vip_axi3_dut comp_vip_axi3_bench comp_test_bench


