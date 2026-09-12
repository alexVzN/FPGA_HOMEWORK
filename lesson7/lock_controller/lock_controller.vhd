----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2026 07:17:30 PM
-- Design Name: 
-- Module Name: lock_controller - rtl
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity lock_controller is
    port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        digit_in     : in  STD_LOGIC_VECTOR(3 downto 0);
        unlocked_led : out STD_LOGIC
    );
end lock_controller;

architecture rtl of lock_controller is

    type state_t is (LOCKED, WAIT_D2, WAIT_D3, UNLOCKED);
    signal state, next_state : state_t;

    constant D1 : natural := 7;
    constant D2 : natural := 2;
    constant D3 : natural := 4;

    constant NO_DIGIT : natural := 0;

begin

    state_reg : process (clk, rst)
    begin
        if rst = '1' then
            state <= LOCKED;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    next_state_logic : process (all)
    begin
        next_state <= state;

        case state is
            when LOCKED =>
                if unsigned(digit_in) = D1 then
                    next_state <= WAIT_D2;
                end if;

            when WAIT_D2 =>
                if unsigned(digit_in) = D2 then
                    next_state <= WAIT_D3;
                elsif unsigned(digit_in) /= NO_DIGIT then
                    next_state <= LOCKED;
                end if;

            when WAIT_D3 =>
                if unsigned(digit_in) = D3 then
                    next_state <= UNLOCKED;
                elsif unsigned(digit_in) /= NO_DIGIT then
                    next_state <= LOCKED;
                end if;

            when UNLOCKED =>
                next_state <= UNLOCKED;
        end case;
    end process;

    output_logic : process (all)
    begin
        unlocked_led <= '1' when state = UNLOCKED else '0';
    end process;

end rtl;
