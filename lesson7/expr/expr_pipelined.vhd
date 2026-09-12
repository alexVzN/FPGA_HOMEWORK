
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity expr_pipelined is
    port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        a      : in  STD_LOGIC_VECTOR(7 downto 0);
        b      : in  STD_LOGIC_VECTOR(7 downto 0);
        c      : in  STD_LOGIC_VECTOR(7 downto 0);
        d      : in  STD_LOGIC_VECTOR(7 downto 0);
        result : out STD_LOGIC_VECTOR(16 downto 0)
    );
end expr_pipelined;

architecture rtl of expr_pipelined is

    signal a_reg, b_reg, c_reg, d_reg : unsigned(7 downto 0);

    signal p_ab, p_cd : unsigned(15 downto 0);

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

    mult_stage : process (clk, rst)
    begin
        if rst = '1' then
            p_ab <= (others => '0');
            p_cd <= (others => '0');
        elsif rising_edge(clk) then
            p_ab <= a_reg * b_reg;
            p_cd <= c_reg * d_reg;
        end if;
    end process;

    add_stage : process (clk, rst)
    begin
        if rst = '1' then
            result_reg <= (others => '0');
        elsif rising_edge(clk) then
            result_reg <= resize(p_ab, 17) + resize(p_cd, 17);
        end if;
    end process;

    result <= std_logic_vector(result_reg);

end rtl;
