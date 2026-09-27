set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 20.000 -name clk [get_ports clk]

set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {LEDs_tri_o[0]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {LEDs_tri_o[1]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports {LEDs_tri_o[2]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {LEDs_tri_o[3]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {LEDs_tri_o[4]}]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS33} [get_ports {LEDs_tri_o[5]}]

set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {SWs_tri_i[0]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {SWs_tri_i[1]}]
