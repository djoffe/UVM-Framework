# alu_in interface packages source
alu_in_PKG         = \
	$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg/alu_in_filelist_hvl.f 

alu_in_PKG_HDL         = \
	$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg/alu_in_filelist_hdl.f 

COMP_alu_in_PKG_TGT_0 = q_comp_alu_in_pkg
COMP_alu_in_PKG_TGT_1 = v_comp_alu_in_pkg
COMP_alu_in_PKG_TGT = $(COMP_alu_in_PKG_TGT_$(USE_VELOCE))

comp_alu_in_pkg: $(COMP_alu_in_PKG_TGT)
	$(HDL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg $(alu_in_PKG_HDL)

q_comp_alu_in_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg $(alu_in_PKG) 
v_comp_alu_in_pkg: q_comp_alu_in_pkg
	$(VELANALYZE_HVL_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_in_pkg $(alu_in_PKG) 
