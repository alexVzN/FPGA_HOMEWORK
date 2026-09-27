set BASE  /home/olllexander/Documents/personal/zynq-linux/homework/lesson10/PS-part
set BIT   $BASE/running_light.runs/impl_1/running_light_wrapper.bit
set PSINIT $BASE/vitis/app_component/_ide/psinit/ps7_init.tcl
set ELF   $BASE/vitis/app_component/build/app_component.elf

connect

targets -set -nocase -filter {name =~ "*Cortex-A9*#0"}
rst -processor

fpga -file $BIT

source $PSINIT
ps7_init
ps7_post_config

dow $ELF
con
