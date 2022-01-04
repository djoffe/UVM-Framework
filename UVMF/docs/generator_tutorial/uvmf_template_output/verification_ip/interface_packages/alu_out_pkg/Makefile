# alu_out interface packages source
alu_out_PKG         = \
	$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_out_pkg/alu_out_filelist_hvl.f 

alu_out_PKG_HDL         = \
	$(DASH_F_OPTION) $(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_out_pkg/alu_out_filelist_hdl.f 

COMP_alu_out_PKG_TGT_0 = q_comp_alu_out_pkg
COMP_alu_out_PKG_TGT_1 = v_comp_alu_out_pkg
COMP_alu_out_PKG_TGT = $(COMP_alu_out_PKG_TGT_$(USE_VELOCE))

comp_alu_out_pkg: $(COMP_alu_out_PKG_TGT)
	$(HDL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_out_pkg $(alu_out_PKG_HDL)

q_comp_alu_out_pkg:
	$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_out_pkg $(alu_out_PKG) 
v_comp_alu_out_pkg: q_comp_alu_out_pkg
	$(VELANALYZE_HVL_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/alu_out_pkg $(alu_out_PKG) 
