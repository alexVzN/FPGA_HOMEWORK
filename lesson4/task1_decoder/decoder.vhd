----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 08/31/2026 04:39:29 PM
-- Design Name:
-- Module Name: decoder - rtl
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;   -- ceil, log2: only for compile-time calculation of code witdh 
use IEEE.NUMERIC_STD.ALL;

entity decoder is
    generic (
        WIDTH : positive := 4
    );
    port (
        code : in  STD_LOGIC_VECTOR(integer(ceil(log2(real(WIDTH)))) - 1 downto 0);
        y    : out STD_LOGIC_VECTOR(WIDTH - 1 downto 0)
    );
end decoder;

architecture rtl of decoder is

begin
    process(code)
        variable idx : natural;
    begin
        y <= (others => '0');

        idx := TO_INTEGER(unsigned(code));
        
        if idx < WIDTH then
            y(idx) <= '1';
        end if;

    end process;

end rtl;
