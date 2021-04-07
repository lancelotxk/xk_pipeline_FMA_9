#################################################
# 	Used for power analysis
#################################################
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


set DESIGN_NAME fpfma_pipeline 


# 2021/01/22
read_verilog ../synthesis/output/$DESIGN_NAME.v
current_design $DESIGN_NAME  


link
# the following command should be eliminated because the design would be renamed
# elaborate $DESIGN_NAME
set_operating_conditions -max ssg0p9v0c

# 2021/01/23
reset_switching_activity -all


# 2020/11/20
read_saif -input ./output/$DESIGN_NAME.saif -instance_name t_fpfma/UUT -verbose

#uniquify
#2021/01/23
#invoke power compiler
#report_power
compile_ultra
# compile –map_effort high

#report_timing -path full -delay min -max_paths 10 -significant_digits 9 -nworst 10 > ./REPORT/Design.holdtiming_min
#report_timing -path full -delay max -max_paths 10 -significant_digits 9 -nworst 10 > ./REPORT/Design.setuptiming_max
##report_timing -path full -delay min -max_paths 10 -nworst 10 > ./REPORT/Design.setuptiming_min
# 2021/01/22
report_saif -hierarchy > ./REPORT//Design.saif
report_area -hierarchy > ./REPORT//Design.area
#report_power -hierarchy > ./REPORT//Design.power
report_power -hier -analysis_effort medium -net -cell -sort_mode name > ./REPORT//Design.power
# report_power -hier -verbose -analysis_effort medium > ./REPORT//Design.power
# report_resources > ./REPORT//Design.resources
# report_constraint -verbose > ./REPORT/Design.constraint
# report_port > ./REPORT//Design.port

#check_design > ./REPORT/Design.check_design
#check_design > ./REPORT/Design.check_timing

set end_time [clock seconds]; echo [clock format ${end_time} -gmt false]

#Total script wall clock run time
echo "Time elapsed: [format %02d [expr ( $end_time - $start_time ) / 86400 ]]d\
[clock format [expr ( $end_time - $start_time ) ] -format %Hh%Mm%Ss -gmt true]"

exit
