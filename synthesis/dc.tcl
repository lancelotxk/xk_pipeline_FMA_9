#################################################
##       For synthesis
##################################################

remove_design -all

#################################################
#	Search paths for technology libs
#################################################

set start_time [clock seconds] ; echo [clock format ${start_time} -gmt false]

echo [pwd]

set search_path "/pdk/mooreelite/TSMC28HPC+/TSMC_iPDK_20170531/STD_CELL/tcbn28hpcplusbwp12t30p140_190a/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp12t30p140_180a ./ ./src" 
set target_library "tcbn28hpcplusbwp12t30p140ssg0p9v0c.db"
set link_library "* dw_foundation.sldb tcbn28hpcplusbwp12t30p140ssg0p9v0c.db"
set synthetic_library "dw_foundation.sldb"

set alib_library_analysis_path "./alib-52_test/"

# 2021/3/24
#synlib_disable_limited_licenses = false

analyze -format verilog -vcs "-f synthesis.f"

set DESIGN_NAME fpfma_pipeline

elaborate $DESIGN_NAME

link
set_operating_conditions -max ssg0p9v0c

#set Tclk 0.45
set Tclk 0.9
# set TCU  0.05

create_clock -name clk_DQS -period $Tclk [get_ports "clk"]

set_propagated_clock [all_clocks]

# set_driving_cell -lib_cell INVD0BWP12T30P140 [all_inputs]
# set_driving_cell -lib_cell INVD4BWP12T30P140 [get_ports clk]
# set_driving_cell -lib_cell INVD4BWP12T30P140 [get_ports rst_n]

set_fix_multiple_port_nets -feedthroughs -outputs -constants

set_load 0.005 [all_outputs] 

set_max_transition 0.1 [current_design]

uniquify

# 2020/11/20
# read_saif -input backward_rtl.saif -instance_name test/BF1 

# 2021/02/09
# set_max_leakage 0
compile -map_effort medium -incremental_mapping -gate_clock


# compile -map_effort high
# compile -only_design_rule -incremental_mapping

report_timing -path full -delay min -max_paths 10 -significant_digits 9 -nworst 10 > ./REPORT/Design.holdtiming_min
report_timing -path full -delay max -max_paths 10 -significant_digits 9 -nworst 10 > ./REPORT/Design.setuptiming_max
##report_timing -path full -delay min -max_paths 10 -nworst 10 > ./REPORT/Design.setuptiming_min
report_area -designware -hierarchy > ./REPORT//Design.area
report_power -hierarchy > ./REPORT//Design.power
report_resources > ./REPORT//Design.resources
report_constraint -verbose > ./REPORT/Design.constraint
report_port > ./REPORT//Design.port

check_design > ./REPORT/Design.check_design
check_design > ./REPORT/Design.check_timing


# 2020/12/06
write -hierarchy -format verilog -output ./output/$DESIGN_NAME.v
#write_sdf -version 1.0 -context verilog ./$DESIGN_NAME.sdf
write_sdf -context verilog ./output/$DESIGN_NAME.sdf

set end_time [clock seconds]; echo [clock format ${end_time} -gmt false]

#Total script wall clock run time
echo "Time elapsed: [format %02d [expr ( $end_time - $start_time ) / 86400 ]]d\
[clock format [expr ( $end_time - $start_time ) ] -format %Hh%Mm%Ss -gmt true]"

exit
