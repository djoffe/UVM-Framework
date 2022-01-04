# ahb interface packages source
ahb_PKG         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg/ahb_filelist_hvl.f 

ahb_PKG_HDL         = \
	+incdir+$(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg \
	-F $(UVMF_VIP_LIBRARY_HOME)/interface_packages/ahb_pkg/ahb_filelist_hdl.f 

COMP_ahb_PKG_TGT_0 = q_comp_ahb_pkg
COMP_ahb_PKG_TGT_1 = v_comp_ahb_pkg
COMP_ahb_PKG_TGT = $(COMP_ahb_PKG_TGT_$(USE_VELOCE))

comp_ahb_pkg: $(COMP_ahb_PKG_TGT)
	$(HDL_COMP_CMD) $(ahb_PKG_HDL)

q_comp_ahb_pkg:
	$(HVL_COMP_CMD)  $(ahb_PKG)

v_comp_ahb_pkg: q_comp_ahb_pkg
	$(VELANALYZE_HVL_CMD) $(ahb_PKG)
