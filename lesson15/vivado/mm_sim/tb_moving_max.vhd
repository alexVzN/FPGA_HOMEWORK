library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

-- Testbench for the HLS-generated moving_max IP (ap_ctrl_hs + two ap_memory ports).
-- The TB emulates the two BRAMs the IP expects: in_r (read, 1-clock latency) and out_r (write).
entity tb_moving_max is
end entity;

architecture sim of tb_moving_max is
  constant N          : natural := 64;
  constant W          : natural := 8;
  constant CLK_PERIOD : time    := 10 ns;

  type mem_t is array (0 to N-1) of integer;

  component moving_max_0 is
    port (
      ap_clk         : in  std_logic;
      ap_rst         : in  std_logic;
      ap_start       : in  std_logic;
      ap_done        : out std_logic;
      ap_idle        : out std_logic;
      ap_ready       : out std_logic;
      in_r_address0  : out std_logic_vector(5 downto 0);
      in_r_ce0       : out std_logic;
      in_r_q0        : in  std_logic_vector(31 downto 0);
      out_r_address0 : out std_logic_vector(5 downto 0);
      out_r_ce0      : out std_logic;
      out_r_we0      : out std_logic;
      out_r_d0       : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk      : std_logic := '0';
  signal rst      : std_logic := '1';
  signal ap_start : std_logic := '0';
  signal ap_done, ap_idle, ap_ready : std_logic;

  signal in_addr  : std_logic_vector(5 downto 0);
  signal in_ce    : std_logic;
  signal in_q     : std_logic_vector(31 downto 0) := (others => '0');
  signal out_addr : std_logic_vector(5 downto 0);
  signal out_ce, out_we : std_logic;
  signal out_d    : std_logic_vector(31 downto 0);

  signal in_mem  : mem_t := (others => 0);
  signal out_mem : mem_t := (others => 0);

  -- reference: out(n) = max(in(n-W+1 .. n)), clipped at 0
  function ref_moving_max(x : mem_t) return mem_t is
    variable y : mem_t;
    variable m : integer;
  begin
    for n in 0 to N-1 loop
      m := x(n);
      for k in 1 to W-1 loop
        if n-k >= 0 and x(n-k) > m then m := x(n-k); end if;
      end loop;
      y(n) := m;
    end loop;
    return y;
  end function;

begin
  dut : moving_max_0
    port map (
      ap_clk => clk, ap_rst => rst, ap_start => ap_start,
      ap_done => ap_done, ap_idle => ap_idle, ap_ready => ap_ready,
      in_r_address0 => in_addr, in_r_ce0 => in_ce, in_r_q0 => in_q,
      out_r_address0 => out_addr, out_r_ce0 => out_ce, out_r_we0 => out_we, out_r_d0 => out_d
    );

  clk <= not clk after CLK_PERIOD / 2;

  -- BRAM emulation
  mem_proc : process(clk)
  begin
    if rising_edge(clk) then
      if in_ce = '1' then
        in_q <= std_logic_vector(to_signed(in_mem(to_integer(unsigned(in_addr))), 32));
      end if;
      if out_ce = '1' and out_we = '1' then
        out_mem(to_integer(unsigned(out_addr))) <= to_integer(signed(out_d));
      end if;
    end if;
  end process;

  stim : process
    variable expected : mem_t;
    variable errors   : natural := 0;

    procedure run_vector(x : mem_t; name : string) is
    begin
      in_mem <= x;
      wait until rising_edge(clk);
      ap_start <= '1';
      wait until rising_edge(clk) and ap_done = '1' for 50 us;
      assert ap_done = '1' report name & ": timeout waiting for ap_done" severity failure;
      ap_start <= '0';
      wait until rising_edge(clk);
      expected := ref_moving_max(x);
      for n in 0 to N-1 loop
        if out_mem(n) /= expected(n) then
          errors := errors + 1;
          report name & ": out(" & integer'image(n) & ") = " & integer'image(out_mem(n)) &
                 ", expected " & integer'image(expected(n)) severity error;
        end if;
      end loop;
      report name & " done" severity note;
    end procedure;

    variable v : mem_t;
  begin
    rst <= '1';
    wait for 5 * CLK_PERIOD;
    rst <= '0';
    wait for 2 * CLK_PERIOD;

    for i in 0 to N-1 loop v(i) := i; end loop;
    run_vector(v, "ramp_up");

    for i in 0 to N-1 loop v(i) := N - i; end loop;
    run_vector(v, "ramp_down");

    for i in 0 to N-1 loop
      if i mod 2 = 1 then v(i) := -i; else v(i) := i; end if;
    end loop;
    run_vector(v, "alternating");

    for i in 0 to N-1 loop
      if i = 10 or i = 40 then v(i) := 1000; else v(i) := -1000 + i; end if;
    end loop;
    run_vector(v, "spikes");

    if errors = 0 then
      report "ALL PASS" severity note;
    else
      report integer'image(errors) & " mismatches" severity error;
    end if;
    stop;
  end process;

end architecture;
