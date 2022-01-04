#mvchome

MSEED ?= random
COLLAPSE ?= 0

run: clean
	vrun -GCOLLAPSE=$(COLLAPSE) -j 2 -nolocalrerun $(EXTRA_RUN_ARGS) -clean -mseed $(MSEED)

clean:
	rm -rf vrmhtmlreport transcript VRMDATA *.log
