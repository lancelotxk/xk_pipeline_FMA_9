rm -rf INCA_libs

source ../config/ENV_SETUP

irun -f rtlsim.f +access+wrc -timescale 1ns/1ps +incdir+../src/verilog -top t_fpfma_pipeline# +gui & 
