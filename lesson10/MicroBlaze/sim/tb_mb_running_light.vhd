library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity tb_mb_running_light is
end entity tb_mb_running_light;

architecture sim of tb_mb_running_light is

  component mb_running_light_wrapper is
    port (
      LEDs_tri_o : out std_logic_vector(5 downto 0);
      SWs_tri_i  : in  std_logic_vector(1 downto 0);
      clk        : in  std_logic
    );
  end component;

  constant CLK_PERIOD : time := 20 ns;
  constant T_SETTLE   : time := 400 us;
  constant T_HOLD     : time := 20 us;
  constant T_GAP      : time := 60 us;

  signal clk  : std_logic := '0';
  signal segs : std_logic_vector(5 downto 0);
  signal btns : std_logic_vector(1 downto 0) := "11";

begin

  dut : mb_running_light_wrapper
    port map (
      LEDs_tri_o => segs,
      SWs_tri_i  => btns,
      clk        => clk
    );

  clk <= not clk after CLK_PERIOD / 2;

  stimulus : process
  begin
    btns <= "11";
    wait for T_SETTLE;

    btns(1) <= '0';
    wait for T_HOLD;
    btns(1) <= '1';
    wait for T_GAP;

    btns(0) <= '0';
    wait for T_HOLD;
    btns(0) <= '1';
    wait for T_GAP;

    btns(0) <= '0';
    wait for T_HOLD;
    btns(0) <= '1';
    wait for T_GAP;

    btns <= "00";
    wait for T_HOLD;
    btns <= "11";
    wait for 2 * T_GAP;

    stop;
  end process stimulus;

end architecture sim;
