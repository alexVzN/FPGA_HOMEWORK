
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lock_top is
    port (
        clk    : in  STD_LOGIC;
        digit_keys_n : in  STD_LOGIC_VECTOR(9 downto 1);
        rst_btn_n : in  STD_LOGIC;
        press_led   : out STD_LOGIC;
        unlocked_led   : out STD_LOGIC
    );
end lock_top;

architecture rtl of lock_top is

    signal press : STD_LOGIC_VECTOR(9 downto 1);
    signal digit : STD_LOGIC_VECTOR(3 downto 0);

    signal rst_s1, rst_s2 : STD_LOGIC := '1';
    signal rst : STD_LOGIC;

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
            unlocked_led => unlocked_led
        );

    press_led <= '0' when digit_keys_n = "111111111" else '1';

end rtl;
