
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity expr_plain is
    port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        a      : in  STD_LOGIC_VECTOR(7 downto 0);
        b      : in  STD_LOGIC_VECTOR(7 downto 0);
        c      : in  STD_LOGIC_VECTOR(7 downto 0);
        d      : in  STD_LOGIC_VECTOR(7 downto 0);
        result : out STD_LOGIC_VECTOR(16 downto 0)
    );
end expr_plain;

architecture rtl of expr_plain is

    signal a_reg, b_reg, c_reg, d_reg : unsigned(7 downto 0);

    signal result_reg : unsigned(16 downto 0);

begin

    input_regs : process (clk, rst)
    begin
        if rst = '1' then
            a_reg <= (others => '0');
            b_reg <= (others => '0');
            c_reg <= (others => '0');
            d_reg <= (others => '0');
        elsif rising_edge(clk) then
            a_reg <= unsigned(a);
            b_reg <= unsigned(b);
            c_reg <= unsigned(c);
            d_reg <= unsigned(d);
        end if;
    end process;

    expr_stage : process (clk, rst)
    begin
        if rst = '1' then
            result_reg <= (others => '0');
        elsif rising_edge(clk) then
            result_reg <= resize(a_reg * b_reg, 17) + resize(c_reg * d_reg, 17);
        end if;
    end process;

    result <= std_logic_vector(result_reg);

end rtl;
