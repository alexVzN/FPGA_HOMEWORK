----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/06/2026 06:42:05 PM
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
use IEEE.NUMERIC_STD.ALL;

entity counter is
    port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;                      
        load    : in  STD_LOGIC;                      
        data_in : in  STD_LOGIC_VECTOR(3 downto 0);
        en      : in  STD_LOGIC;                      
        up_down : in  STD_LOGIC;                      
        count   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end counter;

architecture rtl of counter is
    signal cnt : unsigned(3 downto 0);

begin

    process (clk, rst)
    begin
        if rst = '1' then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                cnt <= unsigned(data_in);
            elsif en = '1' then
                if up_down = '1' then
                    cnt <= cnt + 1;
                else
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;

    count <= std_logic_vector(cnt);

end rtl;
