@set UVMF_HOME=%QUESTA_HOME%/examples/UVM_Framework/UVMF_2019.4

%UVMF_HOME%/scripts/yaml2uvmf.py alu_bench.yaml alu_environment.yaml alu_in_interface.yaml alu_out_interface.yaml alu_util_comp_alu_predictor.yaml
pause
