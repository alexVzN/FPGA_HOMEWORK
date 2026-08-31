----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2026 06:15:49 PM
-- Design Name: 
-- Module Name: mux - rtl
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity mux is
    port (
        sel : in  STD_LOGIC;
        a   : in  STD_LOGIC;
        b   : in  STD_LOGIC;
        y   : out STD_LOGIC
    );
end mux;

architecture rtl of mux is

begin

    process (sel, a, b)
    begin
        case sel is
            when '0'    => y <= a;
            when others => y <= b;
        end case;
    end process;

end rtl;
