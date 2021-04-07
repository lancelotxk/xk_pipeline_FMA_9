source ../config/synopsys.csh

ln -s ../gatesim/output/fpfma.vcd .
vcd2saif -i fpfma.vcd -o ./output/fpfma.saif
dc_shell-t -f dc.tcl | tee -i dc.log
