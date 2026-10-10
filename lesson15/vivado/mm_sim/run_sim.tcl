# Headless check: vivado -mode batch -source run_sim.tcl
set here [file dirname [file normalize [info script]]]
open_project $here/mm_sim/mm_sim.xpr
set_property -name {xsim.simulate.runtime} -value {0} -objects [get_filesets sim_1]
launch_simulation
run all
close_sim
close_project
