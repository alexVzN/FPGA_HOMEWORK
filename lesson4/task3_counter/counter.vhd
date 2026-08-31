----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2026 06:47:10 PM
-- Design Name: 
-- Module Name: counter - rtl
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
use IEEE.MATH_REAL.ALL;   -- ceil, log2: only for compile-time calculation of count width
use IEEE.NUMERIC_STD.ALL;

entity counter is
    generic (
        MAX_NUMB : positive := 16
    );
    port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        en    : in  STD_LOGIC := '1';
        count : out STD_LOGIC_VECTOR(integer(ceil(log2(real(MAX_NUMB)))) - 1 downto 0)
    );
end counter;

architecture rtl of counter is
    signal r_counter : unsigned(count'range) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                r_counter <= (others => '0');
            elsif en = '1' then
                if r_counter = MAX_NUMB - 1 then
                    r_counter <= (others => '0');
                else
                    r_counter <= r_counter + 1;
                end if;
            end if;
        
        end if;
    end process;

    count <= std_logic_vector(r_counter);

end rtl;
