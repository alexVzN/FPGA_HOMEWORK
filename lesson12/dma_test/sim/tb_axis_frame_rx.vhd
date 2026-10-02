library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb_axis_frame_rx is
end entity tb_axis_frame_rx;

architecture sim of tb_axis_frame_rx is
  constant CLK_PERIOD : time    := 10 ns;
  constant N_BYTES    : natural := 16;   -- 4 words

  signal clk      : std_logic := '0';
  signal resetn   : std_logic := '0';
  signal rx_data  : std_logic_vector(7 downto 0) := (others => '0');
  signal rx_valid : std_logic := '0';

  signal m_tdata  : std_logic_vector(31 downto 0);
  signal m_tkeep  : std_logic_vector(3 downto 0);
  signal m_tvalid : std_logic;
  signal m_tready : std_logic := '0';
  signal m_tlast  : std_logic;

  signal captured : natural := 0;
begin

  dut : entity work.axis_frame_rx
    generic map ( FIFO_DEPTH => 32 )
    port map (
      clk => clk, resetn => resetn,
      rx_data => rx_data, rx_valid => rx_valid,
      m_axis_tdata => m_tdata, m_axis_tkeep => m_tkeep,
      m_axis_tvalid => m_tvalid, m_axis_tready => m_tready, m_axis_tlast => m_tlast
    );

  clk <= not clk after CLK_PERIOD / 2;

  -- consumer: accept words and check packing (first byte -> LSB)
  consume : process(clk)
    variable expected : std_logic_vector(31 downto 0);
  begin
    if rising_edge(clk) then
      if m_tvalid = '1' and m_tready = '1' then
        expected := std_logic_vector(to_unsigned(captured*4 + 3, 8)) &
                    std_logic_vector(to_unsigned(captured*4 + 2, 8)) &
                    std_logic_vector(to_unsigned(captured*4 + 1, 8)) &
                    std_logic_vector(to_unsigned(captured*4 + 0, 8));
        assert m_tdata = expected
          report "word " & integer'image(captured) & " mismatch: got " &
                 to_hstring(m_tdata) & " exp " & to_hstring(expected)
          severity error;
        captured <= captured + 1;
      end if;
    end if;
  end process;

  stim : process
    procedure send_byte(b : in natural) is
    begin
      rx_data  <= std_logic_vector(to_unsigned(b, 8));
      rx_valid <= '1';
      wait until rising_edge(clk);
      rx_valid <= '0';
      rx_data  <= (others => '0');
    end procedure;
  begin
    resetn <= '0'; m_tready <= '1';
    wait for 4 * CLK_PERIOD;
    resetn <= '1';
    wait until rising_edge(clk);

    for i in 0 to N_BYTES - 1 loop
      send_byte(i);
    end loop;

    wait for 20 * CLK_PERIOD;
    assert captured = N_BYTES / 4
      report "expected " & integer'image(N_BYTES/4) & " words, got " &
             integer'image(captured)
      severity error;

    report "TB done: words captured = " & integer'image(captured) severity note;
    stop;
  end process;

end architecture sim;
