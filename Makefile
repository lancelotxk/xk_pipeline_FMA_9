SHELL:=/bin/csh

DESIGN = fpfma_pipeline

object = ./rtlsim/INCA_libs ./rtlsim/waves.shm ./rtlsim/irun.history ./rtlsim/irun.log \
./synthesis/alib-52_test ./synthesis/*.pvl ./synthesis/*.syn ./synthesis/*.svf ./synthesis/*.mr ./synthesis/*.log ./synthesis/output/* ./synthesis/REPORT/* \
./gatesim/.simvision ./gatesim/INCA_libs ./gatesim/waves.shm ./gatesim/irun.history ./gatesim/irun.log ./gatesim/${DESIGN}.sdf.X ./gatesim/output/* \
./power/alib-52_test ./power/*.svf ./power/*.log ./power/${DESIGN}.vcd ./power/output/*

# object = ./src/${DESIGN}.v ./src/${DESIGN}.sdf ./rtlsim/INCA_libs ./rtlsim/irun.log ./rtlsim/waves.shm ./irun.history ./synthesis/alib-52_test ./synthesis/dc.log ./synthesis/command.log ./synthesis/default.svf ./synthesis/*.pvl ./synthesis/*.mr ./synthesis/*.syn ./synthesis/*.sdf ./synthesis/${DESIGN}.v ./gatesim/INCA_libs ./gatesim/irun.log ./gatesim/waves.shm ./gatesim/irun.history ./gatesim/*.vcd ./gatesim/*.sdf.X ./power/alib-52_test ./power/*.log ./power/*.vcd ./power/*.saif ./power/*.svf ./power/*.dsn

all:
	source run.csh;

rsim:
	cd ./rtlsim;	source ./run.csh;

syn:
	cd ./synthesis;	source ./run.csh;

gsim:
	cd ./gatesim;	source ./run.csh;

pow:
	cd ./power;	source ./run.csh;


.PHONY: clean
clean:
	rm -rf $(object)
