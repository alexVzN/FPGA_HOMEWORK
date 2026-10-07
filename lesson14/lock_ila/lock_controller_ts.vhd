----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2026 08:18:38 PM
-- Design Name: 
-- Module Name: lock_controller_ts - test
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

use std.env.finish;

entity lock_controller_ts is
end lock_controller_ts;

architecture test of lock_controller_ts is

    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '0';
    signal digit_in : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal unlocked_led : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin

    dut : entity work.lock_controller
        port map (
            clk          => clk,
            rst          => rst,
            digit_in     => digit_in,
            state_dbg    => open,
            unlocked_led => unlocked_led
        );

    clk <= not clk after CLK_PERIOD / 2;

    stim : process

        procedure wait_cycles(n : in positive) is
        begin
            for i in 1 to n loop
                wait until rising_edge(clk);
            end loop;
            wait for 1 ns;
        end procedure;

        procedure press(d : in natural) is
        begin
            digit_in <= std_logic_vector(to_unsigned(d, 4));
            wait_cycles(1);
            digit_in <= (others => '0');
            wait_cycles(1);
        end procedure;

        procedure do_reset is
        begin
            rst <= '1';
            wait for CLK_PERIOD;
            rst <= '0';
            wait for 1 ns;
        end procedure;

        procedure check_led(expected : in STD_LOGIC; name : in string) is
        begin
            if unlocked_led = expected then
                report "PASS: " & name;
            else
                report "FAIL: " & name & " -> expected " &
                       STD_LOGIC'image(expected) & ", got " &
                       STD_LOGIC'image(unlocked_led)
                       severity error;
            end if;
        end procedure;

    begin
        do_reset;
        check_led('0', "T1: locked after reset");

        press(7);
        check_led('0', "T2a: still locked after 1st digit");
        press(2);
        check_led('0', "T2b: still locked after 2nd digit");
        press(4);
        check_led('1', "T2c: unlocked after full code 7-2-4");

        wait_cycles(3);
        check_led('1', "T3a: stays unlocked over time");
        press(9);
        check_led('1', "T3b: stays unlocked after extra digit");

        do_reset;
        check_led('0', "T4: locked again after reset");

        press(7);
        press(9);
        press(2);
        press(4);
        check_led('0', "T5: wrong 2nd digit resets to LOCKED");

        press(7);
        press(2);
        press(4);
        check_led('1', "T6: full code works after failed attempt");

        report "SIMULATION DONE";
        finish;
    end process;

end test;
