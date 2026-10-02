library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use std.env.all;

entity tb_frame_grabber is
end entity tb_frame_grabber;

architecture sim of tb_frame_grabber is

  component dma_test_design_wrapper is
    port (
      SWs_tri_i  : in  std_logic_vector(0 downto 0);
      clk        : in  std_logic;
      rx_data_0  : in  std_logic_vector(7 downto 0);
      rx_valid_0 : in  std_logic
    );
  end component;

  constant CLK_PERIOD : time    := 20 ns;    -- 50 MHz board clock (M19)
  constant T_SETTLE   : time    := 40 us;    -- after press: MicroBlaze arms S2MM
  constant N_BYTES    : natural := 64000;    -- full 320x200 frame
  constant SYS_PERIOD : time    := 10 ns;    -- 100 MHz system clock period (source domain)
  constant FRAME_FILE : string  := "../../../../sim/frame.hex";  -- relative to behav/xsim

  signal clk   : std_logic := '0';
  signal btns  : std_logic_vector(0 downto 0) := "1";   -- active-low KEY1: 1=released, 0=pressed
  signal data  : std_logic_vector(7 downto 0) := (others => '0');
  signal valid : std_logic := '0';

begin

  dut : dma_test_design_wrapper
    port map (
      SWs_tri_i  => btns,
      clk        => clk,
      rx_data_0  => data,
      rx_valid_0 => valid
    );

  clk <= not clk after CLK_PERIOD / 2;

  stim : process
    file     fh     : text;
    variable ln     : line;
    variable byte_v : std_logic_vector(7 downto 0);
    variable st     : file_open_status;
  begin
    btns <= "1";
    wait for 130 us;      -- MMCM lock + MicroBlaze boot
    btns <= "0";          -- press and hold

    wait for T_SETTLE;    -- MicroBlaze arms S2MM

    file_open(st, fh, FRAME_FILE, read_mode);
    assert st = open_ok report "cannot open " & FRAME_FILE severity failure;

    -- source in the 100 MHz domain: one byte per 10 ns, valid held high (+5 ns for setup)
    wait for SYS_PERIOD / 2;
    valid <= '1';
    for i in 0 to N_BYTES - 1 loop
      exit when endfile(fh);
      readline(fh, ln);
      hread(ln, byte_v);
      data <= byte_v;
      wait for SYS_PERIOD;
    end loop;
    valid <= '0';
    file_close(fh);

    wait for 100 us;
    btns <= "1";          -- release
    wait for 50 us;
    stop;
  end process stim;

end architecture sim;
