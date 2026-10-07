library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lock_top is
    port (
        clk          : in  STD_LOGIC;
        digit_keys_n : in  STD_LOGIC_VECTOR(9 downto 1);
        rst_btn_n    : in  STD_LOGIC;
        press_led    : out STD_LOGIC;
        unlocked_led : out STD_LOGIC
    );
end lock_top;

architecture rtl of lock_top is

    signal press : STD_LOGIC_VECTOR(9 downto 1);
    signal digit : STD_LOGIC_VECTOR(3 downto 0);

    signal rst_s1, rst_s2 : STD_LOGIC := '1';
    signal rst : STD_LOGIC;

    signal state_dbg  : STD_LOGIC_VECTOR(1 downto 0);
    signal unlocked_i : STD_LOGIC;

    -- ILA core (IP Catalog -> Debug -> ILA): 5 probes, widths must match Customize IP
    component ila_0
        port (
            clk    : in STD_LOGIC;
            probe0 : in STD_LOGIC_VECTOR(1 downto 0);
            probe1 : in STD_LOGIC_VECTOR(3 downto 0);
            probe2 : in STD_LOGIC_VECTOR(0 downto 0);
            probe3 : in STD_LOGIC_VECTOR(0 downto 0);
            probe4 : in STD_LOGIC_VECTOR(8 downto 0)
        );
    end component;

begin

    gen_debounce : for k in 1 to 9 generate
        deb_k : entity work.debounce
            generic map ( STABLE_TICKS => 500_000 )
            port map (
                clk   => clk,
                btn   => digit_keys_n(k),
                press => press(k)
            );
    end generate;

    u_coder : entity work.coder
        port map (
            keys  => press,
            digit => digit
        );

    sync_key1 : process (clk)
    begin
        if rising_edge(clk) then
            rst_s1 <= rst_btn_n;
            rst_s2 <= rst_s1;
        end if;
    end process;

    rst <= not rst_s2;

    u_lock : entity work.lock_controller
        port map (
            clk          => clk,
            rst          => rst,
            digit_in     => digit,
            state_dbg    => state_dbg,
            unlocked_led => unlocked_i
        );

    unlocked_led <= unlocked_i;
    press_led    <= '0' when digit_keys_n = "111111111" else '1';

    -- probes: FSM state, decoded digit, unlock flag, reset, debounced keys
    u_ila : ila_0
        port map (
            clk       => clk,
            probe0    => state_dbg,
            probe1    => digit,
            probe2(0) => unlocked_i,
            probe3(0) => rst,
            probe4    => press
        );

end rtl;
