source ../config/ENV_SETUP

rm -rf ./output/fpfma_pipeline.vcd
rm -rf fpfma_pipeline.sdf.X
rm -rf INCA_libs

irun -f gatesim.f -define GATESIM +access+wrc -disable_sem2009 -top t_fpfma_pipeline -input irun.tcl -timescale 1ns/1ps
