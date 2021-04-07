# csh configuration for synopsys

# the synopsys home dir
setenv SYNOPSYS_HOME /mnt/SSD0-v0/eda/synopsys

# synopsys license
# setenv SNPSLMD_LICENSE_FILE ${SYNOPSYS_HOME}/license/synopsys.dat
setenv SNPSLMD_LICENSE_FILE 27000@duli-server
setenv LM_LICENSE_FILE ${SYNOPSYS_HOME}/license/synopsys.dat

# dc
setenv PATH ${PATH}:${SYNOPSYS_HOME}/dc201903_SP5/syn/P-2019.03-SP5-4/bin

# vcs
setenv PATH ${PATH}:${SYNOPSYS_HOME}/vcs/bin

# spyglass
setenv PATH ${PATH}:${SYNOPSYS_HOME}/spyglass/P-2019.06-SP1-1/SPYGLASS_HOME/bin

setenv CDS_LOAD_ENV CSF
