# alu environment packages source and make target

# Include all requisite sub-environment package targets for this bench

alu_ENV_PKG =\
		 $(UVMF_VIP_LIBRARY_HOME)/environment_packages/alu_env_pkg/alu_env_pkg.sv

comp_alu_env_pkg:  
		$(HVL_COMP_CMD) +incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/alu_env_pkg $(alu_ENV_PKG)

