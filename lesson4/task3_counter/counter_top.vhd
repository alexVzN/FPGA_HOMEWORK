library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_top is
    port (
        clk  : in  STD_LOGIC;
        key1 : in  STD_LOGIC;
        key2 : in  STD_LOGIC;
        led  : out STD_LOGIC_VECTOR(1 downto 0)     -- P20, P21
    );
end counter_top;

architecture rtl of counter_top is

    signal press : STD_LOGIC;

    signal key2_s1, key2_s2 : STD_LOGIC := '1';
    signal rst : STD_LOGIC;

begin

    u_debounce : entity work.debounce
        generic map ( STABLE_TICKS => 500_000 )
        port map (
            clk   => clk,
            btn   => key1,
            press => press
        );

    sync_key2 : process (clk)
    begin
        if rising_edge(clk) then
            key2_s1 <= key2;
            key2_s2 <= key2_s1;
        end if;
    end process;

    rst <= not key2_s2;

    u_counter : entity work.counter
        generic map ( MAX_NUMB => 4 )
        port map (
            clk   => clk,
            reset => rst,
            en    => press,
            count => led
        );

end rtl;
