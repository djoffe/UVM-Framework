# Machine Architecture - based on presence of Questa standard env var MTI_VCO_MODE unless
# manually set by user.
ifeq ($(MTI_VCO_MODE),64)
  MACHINE_ARCH ?= -64
else
  MACHINE_ARCH ?= -32
endif

UVMC_VER           ?= 2.3.1
UVM_VER            ?= 1.1d
COMMON_VSIM_ARGS   += -t ns

XINCDIRS  = +incdir+$(QUESTA_HOME)/verilog_src/uvm-$(UVM_VER)/src
XINCDIRS += +incdir+$(QUESTA_HOME)/verilog_src/uvmc-$(UVMC_VER)/src/connect/sv
UVMCONNECT_VLOG = $(QUESTA_HOME)/verilog_src/uvmc-$(UVMC_VER)/src/connect/sv/uvmc_pkg.sv

DINCDIRS  = -I$(QUESTA_HOME)/verilog_src/uvmc-$(UVMC_VER)/src/connect/sc
UVMCONNECT_CPP = $(QUESTA_HOME)/verilog_src/uvmc-$(UVMC_VER)/src/connect/sc/uvmc.cpp

compile_uvmc:
	-@echo "Compiling UVMConnect library for platform $(MACHINE_ARCH)"
	vlib work
	vlog   -incr $(XINCDIRS) $(UVMCONNECT_VLOG)
	sccom $(MACHINE_ARCH) -work work -Wall -g $(DINCDIRS) $(UVMCONNECT_CPP)
	sccom $(MACHINE_ARCH) -g -O0 $(DINCDIRS) -lib work -DSC_INCLUDE_DYNAMIC_PROCESSES -linkshared

