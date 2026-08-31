----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2026 05:54:48 PM
-- Design Name: 
-- Module Name: decoder_sim_top - rtl
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
entity decoder_sim_top is
    port (
        code4 : in  STD_LOGIC_VECTOR(1 downto 0);
        code8 : in  STD_LOGIC_VECTOR(2 downto 0);
        y4    : out STD_LOGIC_VECTOR(3 downto 0);
        y8    : out STD_LOGIC_VECTOR(7 downto 0)
    );
end decoder_sim_top;

architecture rtl of decoder_sim_top is

begin

    dec4 : entity work.decoder
        generic map (WIDTH => 4)
        port map (
            code => code4,
            y    => y4
        );

    dec8 : entity work.decoder
        generic map (WIDTH => 8)
        port map (
            code => code8,
            y    => y8
        );

end rtl;
