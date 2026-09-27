--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2026.1 (lin64) Build 6511674 Tue Jun 16 11:01:26 MDT 2026
--Date        : Mon Sep 28 01:31:44 2026
--Host        : fedora running 64-bit unknown
--Command     : generate_target mb_running_light_wrapper.bd
--Design      : mb_running_light_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mb_running_light_wrapper is
  port (
    LEDs_tri_o : out STD_LOGIC_VECTOR ( 5 downto 0 );
    SWs_tri_i : in STD_LOGIC_VECTOR ( 1 downto 0 );
    clk : in STD_LOGIC
  );
end mb_running_light_wrapper;

architecture STRUCTURE of mb_running_light_wrapper is
  component mb_running_light is
  port (
    LEDs_tri_o : out STD_LOGIC_VECTOR ( 5 downto 0 );
    SWs_tri_i : in STD_LOGIC_VECTOR ( 1 downto 0 );
    clk : in STD_LOGIC
  );
  end component mb_running_light;
begin
mb_running_light_i: component mb_running_light
     port map (
      LEDs_tri_o(5 downto 0) => LEDs_tri_o(5 downto 0),
      SWs_tri_i(1 downto 0) => SWs_tri_i(1 downto 0),
      clk => clk
    );
end STRUCTURE;
