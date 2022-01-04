# Package make targets
VIP_PCIE_30_SERIAL_EXAMPLE_ENV_PKG =\
+incdir+$(VIP_HOME)/questa_mvc_src/sv \
+incdir+$(VIP_HOME)/examples/pcie/common \
+incdir+$(UVMF_VIP_LIBRARY_HOME)/environment_packages/qvip_pcie_3_0_serial_example_env_pkg \
$(UVMF_VIP_LIBRARY_HOME)/environment_packages/qvip_pcie_3_0_serial_example_env_pkg/qvip_pcie_3_0_serial_example_env_pkg.sv

comp_vip_pcie_3_0_serial_env_pkg:
	$(HVL_COMP_CMD) $(VIP_PCIE_30_SERIAL_EXAMPLE_ENV_PKG)

