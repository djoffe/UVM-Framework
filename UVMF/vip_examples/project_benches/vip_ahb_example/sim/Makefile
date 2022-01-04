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
export UVMF_PROJECT_DIR ?= ../../../project_benches/vip_ahb_example

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

PROTOCOL = ahb

# Include Makefile that includes targets for UVM Framework packages
include $(UVMF_HOME)/scripts/Makefile

include $(UVMF_HOME)/base_examples/verification_ip/interface_packages/wb_pkg/Makefile
include $(UVMF_VIP_LIBRARY_HOME)/environment_packages/vip_ahb_example_env_pkg/Makefile

# Add to default compile/load/run arguments
VCOM_ARGS             += 
VLOG_ARGS             +=
VELANALYZE_ARGS       +=
VELANALYZE_HVL_ARGS   +=

BATCH_VOPT_ARGS      +=
DEBUG_VOPT_ARGS      +=
COMMON_VSIM_ARGS     += -mvchome $(VIP_HOME) -permit_unmatched_virtual_intf
BATCH_VSIM_ARGS      +=
DEBUG_VSIM_ARGS      +=
LINK_ARGS            +=

VELOCE_XACTOR_LIBS_0 = $(VELOCE_XACTOR_HOME)/common/lib/$(LIB_PLATFORM)/libcommontbx.a \
                       $(VELOCE_XACTOR_HOME)/$(PROTOCOL)/lib/$(LIB_PLATFORM)/lib$(PROTOCOL)tbx.a
VELOCE_XACTOR_LIBS_1 = $(VELOCE_XACTOR_LIBS_0) \
                       $(VELOCE_XACTOR_HOME)/common/lib/$(LIB_PLATFORM)/libexportdefstbx.a
VELOCE_XACTOR_LIBS   = $(VELOCE_XACTOR_LIBS_$(USE_VELOCE))

# Do commands
DEBUG_DO_COMMANDS = -do "run 0; do wave.do; radix hex showbase; run -all"

# Project bench package source
VIP_AHB_PARAMETERS_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/parameters \
$(UVMF_PROJECT_DIR)/tb/parameters/vip_ahb_example_parameters_pkg.sv

VIP_AHB_SEQUENCES_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/sequences \
$(UVMF_PROJECT_DIR)/tb/sequences/vip_ahb_example_sequences_pkg.sv

VIP_AHB_TEST_PKG =\
+incdir+$(UVMF_PROJECT_DIR)/tb/tests \
$(UVMF_PROJECT_DIR)/tb/tests/vip_ahb_example_test_pkg.sv

VIP_AHB_DUT =\
+incdir+$(UVMF_HOME)/common/modules \
$(UVMF_HOME)/common/modules/ahb_memory_slave_module_hdl.sv

VIP_AHB_DUT_HVL =\
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(UVMF_HOME)/common/modules \
$(UVMF_HOME)/common/modules/ahb_memory_slave_module_hvl.sv

VIP_AHB_QVIP =\
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL) \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/mgc_$(PROTOCOL)_v2_0_pkg.sv

VIP_AHB_VVIP_HVL =\
+incdir+$(VELOCE_XACTOR_HOME)/common/sysvlog \
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL) \
$(VIP_HOME)/questa_mvc_src/sv/$(PROTOCOL)/mgc_$(PROTOCOL)_v2_0_pkg.sv \
+incdir+$(VELOCE_XACTOR_HOME)/$(PROTOCOL) \
+incdir+$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/sysvlog \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/sysvlog/xmvc_$(PROTOCOL)_pkg.sv \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/sysvlog/AHBTBX_interface.sv

VIP_AHB_VVIP_HDL =\
+incdir+$(VELOCE_XACTOR_HOME)/$(PROTOCOL) \
+incdir+$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl \
-f $(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/xrtl$(PROTOCOL)if.f \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)_master_module.sv \
$(VELOCE_XACTOR_HOME)/$(PROTOCOL)/hdl/$(PROTOCOL)_slave_module.sv

VIP_AHB_TB_HVL =\
+incdir+$(UVMF_HOME)/common/mgc_vip \
+incdir+$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL) \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_master_hvl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_slave_hvl.sv

VIP_AHB_TB_HDL =\
+incdir+$(UVMF_HOME)/common/mgc_vip \
+incdir+$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL) \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_signal_if.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_master_hdl.sv \
$(UVMF_HOME)/common/mgc_vip/$(PROTOCOL)/mgc_$(PROTOCOL)_slave_hdl.sv

VIP_AHB_TB_HDL +=\
+incdir+$(UVMF_PROJECT_DIR)/tb/testbench \
$(UVMF_PROJECT_DIR)/tb/testbench/clk_reset.sv  \
$(UVMF_PROJECT_DIR)/tb/testbench/ahb_arbiter.sv

.PHONY: all build common wrappers test run clean 

# Project bench package targets
COMP_VIP_AHB_PARAMETERS_PKG_TGT_0 = q_comp_vip_ahb_parameters_pkg
COMP_VIP_AHB_PARAMETERS_PKG_TGT_1 = v_comp_vip_ahb_parameters_pkg
COMP_VIP_AHB_PARAMETERS_PKG_TGT   = $(COMP_VIP_AHB_PARAMETERS_PKG_TGT_$(USE_VELOCE))

comp_vip_ahb_parameters_pkg: $(COMP_VIP_AHB_PARAMETERS_PKG_TGT)

q_comp_vip_ahb_parameters_pkg:
	$(HVL_COMP_CMD) $(VIP_AHB_PARAMETERS_PKG)

v_comp_vip_ahb_parameters_pkg: q_comp_vip_ahb_parameters_pkg
	$(HDL_COMP_CMD) $(VIP_AHB_PARAMETERS_PKG)

comp_vip_ahb_sequence_pkg:
	$(HVL_COMP_CMD) $(VIP_AHB_SEQUENCES_PKG)

comp_vip_ahb_test_pkg:
	$(HVL_COMP_CMD) $(VIP_AHB_TEST_PKG)

comp_vip_ahb_dut:
	$(HVL_COMP_CMD) $(VIP_AHB_DUT_HVL)
	$(HDL_COMP_CMD) $(VIP_AHB_DUT)

COMP_VIP_AHB_TGT_0 = comp_vip_ahb_qvip
COMP_VIP_AHB_TGT_1 = comp_vip_ahb_vvip
COMP_VIP_AHB_TGT   = $(COMP_VIP_AHB_TGT_$(USE_VTL))

comp_vip_ahb: $(COMP_VIP_AHB_TGT)
	$(HVL_COMP_CMD) $(VIP_AHB_TB_HVL)
	$(HDL_COMP_CMD) $(VIP_AHB_TB_HDL)

comp_vip_ahb_qvip: comp_vip_base_pkg
	$(HVL_COMP_CMD) $(VIP_AHB_QVIP)

comp_vip_ahb_vvip: comp_vip_base_pkg comp_vtl_base_pkg
	$(HVL_COMP_CMD) $(VIP_AHB_VVIP_HVL)
	$(HDL_COMP_CMD) $(VIP_AHB_VVIP_HDL)

build: comp_vip_ahb comp_uvm_pkg comp_fli_pkg comp_uvmf_base_pkg comp_qvip_utils_pkg comp_wb_pkg comp_vip_ahb_env_pkg comp_vip_ahb_parameters_pkg comp_vip_ahb_sequence_pkg comp_vip_ahb_test_pkg comp_vip_ahb_dut comp_test_bench

