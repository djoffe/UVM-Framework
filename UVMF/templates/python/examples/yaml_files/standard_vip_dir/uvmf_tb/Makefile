####################
# Common Setup.

INCDIRS = 

HVL_SV_SOURCE = ../uvmf/hvl_standard_vip.sv
HDL_SV_SOURCE = ../uvmf/hdl_standard_vip.sv

UVM_OPTIONS = +UVM_TESTNAME=standard_vip_test_base +SEQ=standard_vip_vseq_base

export STANDARD_VIP_DIR_NAME ?= $(shell pwd)/../uvmf

####################
# Questa support.

all: work sv opt sim

sv: hvl_sv hdl_sv

work:
	vlib work

hvl_sv:
	vlog -f standard_vip_test_filelist.f $(INCDIRS) $(HVL_SV_SOURCE)

hdl_sv:
	vlog -f standard_vip_test_filelist.f $(INCDIRS) $(HDL_SV_SOURCE)

opt:
	vopt hdl_standard_vip hvl_standard_vip -o top_opt

vis_opt:
	vopt hdl_standard_vip hvl_standard_vip -o top_opt -debug -designfile design.bin

sim:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1ns -c -do "run -all; quit"

vis_sim:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1ns -c -do "run -all; quit" -qwavedb=+signal+transaction+class+uvm_schematic
	visualizer -designfile design.bin -wavefile qwave.db

vis_int: work sv vis_opt
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1ns -visualizer=design.bin -qwavedb=+signal+transaction+class+uvm_schematic

gui:
	vsim -mvchome ${QUESTA_MVC_HOME} top_opt $(UVM_OPTIONS) +nowarnTSCALE -t 1ns

####################
# Cleanup.

clean:
	rm -rf work transcript vsim.wlf

.PHONY: all sv hvl_sv hdl_sv opt sim gui
.PHONY: vis vis_opt vis_sim vis_int
