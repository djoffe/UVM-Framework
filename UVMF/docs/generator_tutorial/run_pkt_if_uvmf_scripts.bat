@set UVMF_HOME=C:/MentorTools/questasim_10.6b/examples/UVM_Framework/UVMF_3.6f
@set PYTHONPATH=%UVMF_HOME%/templates/python

python alu_in_if_config.py
python alu_out_if_config.py
python alu_env_config.py
python alu_bench_config.py
pause