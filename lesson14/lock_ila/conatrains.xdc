
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 20.000 -name sys_clk [get_ports clk]

set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[1]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[2]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[3]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[4]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[5]}]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[6]}]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[7]}]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[8]}]
set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {digit_keys_n[9]}]

set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports rst_btn_n]

set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports press_led]
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports unlocked_led]
