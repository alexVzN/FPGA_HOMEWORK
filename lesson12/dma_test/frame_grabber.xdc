# Smart ZYNQ SL (XC7Z020) - lesson12 frame grabber
# top ports: clk, SWs_tri_i[1:0], rx_data_0[7:0], rx_valid_0

# PL clock 50 MHz (M19)
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 20.000 -name clk [get_ports clk]

# button KEY1 (active-low). The board has an external pull-up on this key,
# so no internal PULLUP is set here.
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports {SWs_tri_i[0]}]

# rx_data[7:0] - external byte source (sim-only; J5 bank35 pins, arbitrary-but-valid)
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {rx_data_0[0]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {rx_data_0[1]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports {rx_data_0[2]}]
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {rx_data_0[3]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {rx_data_0[4]}]
set_property -dict {PACKAGE_PIN E20 IOSTANDARD LVCMOS33} [get_ports {rx_data_0[5]}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {rx_data_0[6]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {rx_data_0[7]}]

# rx_valid - byte strobe (sim-only)
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports rx_valid_0]
