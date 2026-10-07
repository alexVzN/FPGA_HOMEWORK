
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    generic (
        STABLE_TICKS : positive := 500_000
    );
    port (
        clk   : in  STD_LOGIC;
        btn   : in  STD_LOGIC;
        press : out STD_LOGIC
    );
end debounce;

architecture rtl of debounce is

    signal sync1, sync2 : STD_LOGIC := '1';

    signal stable_cnt : unsigned(integer(ceil(log2(real(STABLE_TICKS)))) - 1 downto 0)
                        := (others => '0');
    signal btn_clean  : STD_LOGIC := '1';

    signal btn_prev : STD_LOGIC := '1';

begin

    sync_ff : process (clk)
    begin
        if rising_edge(clk) then
            sync1 <= btn;
            sync2 <= sync1;
        end if;
    end process;

    stability : process (clk)
    begin
        if rising_edge(clk) then
            if sync2 = btn_clean then
                stable_cnt <= (others => '0');
            elsif stable_cnt = STABLE_TICKS - 1 then
                btn_clean  <= sync2;
                stable_cnt <= (others => '0');
            else
                stable_cnt <= stable_cnt + 1;
            end if;
        end if;
    end process;

    edge_det : process (clk)
    begin
        if rising_edge(clk) then
            btn_prev <= btn_clean;
            if btn_prev = '1' and btn_clean = '0' then
                press <= '1';
            else
                press <= '0';
            end if;
        end if;
    end process;

end rtl;
