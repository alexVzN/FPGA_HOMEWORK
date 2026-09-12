----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/12/2026 02:49:44 PM
-- Design Name: 
-- Module Name: coder - rtl
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
use IEEE.NUMERIC_STD.ALL;

entity coder is
    port (
        keys  : in  STD_LOGIC_VECTOR(9 downto 1);
        digit : out STD_LOGIC_VECTOR(3 downto 0)
    );
end coder;

architecture rtl of coder is

begin

    encode : process (all)
        variable ones : natural range 0 to 9;
        variable idx  : natural range 0 to 9;
    begin
        ones := 0;
        idx  := 0;

        for k in keys'range loop
            if keys(k) = '1' then
                ones := ones + 1;
                idx  := k;
            end if;
        end loop;

        if ones = 1 then
            digit <= std_logic_vector(to_unsigned(idx, digit'length));
        else
            digit <= (others => '0');
        end if;
    end process;

end rtl;
