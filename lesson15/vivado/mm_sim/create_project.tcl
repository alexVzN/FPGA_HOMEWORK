# Creates the simulation-only Vivado project around the packaged HLS IP.
# Usage (from this directory): vivado -mode batch -source create_project.tcl
set here [file dirname [file normalize [info script]]]
create_project mm_sim $here/mm_sim -part xc7z020clg484-1 -force
set_property target_language VHDL [current_project]
set_property ip_repo_paths $here/ip_repo [current_project]
update_ip_catalog
create_ip -name moving_max -vendor xilinx.com -library hls -version 1.0 -module_name moving_max_0
add_files -fileset sim_1 $here/tb_moving_max.vhd
set_property file_type {VHDL 2008} [get_files tb_moving_max.vhd]
set_property top tb_moving_max [get_filesets sim_1]
generate_target simulation [get_ips moving_max_0]
close_project
