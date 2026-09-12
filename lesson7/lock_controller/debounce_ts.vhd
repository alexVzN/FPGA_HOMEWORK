----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/12/2026 02:25:03 PM
-- Design Name: 
-- Module Name: debounce_ts - test
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

use std.env.finish;

entity debounce_ts is
end debounce_ts;

architecture test of debounce_ts is

    signal clk   : STD_LOGIC := '0';
    signal btn   : STD_LOGIC := '1';
    signal press : STD_LOGIC;

    signal press_count : natural := 0;

    constant CLK_PERIOD : time := 10 ns;
    constant TICKS      : positive := 5;

begin

    dut : entity work.debounce
        generic map ( STABLE_TICKS => TICKS )
        port map (
            clk   => clk,
            btn   => btn,
            press => press
        );

    clk <= not clk after CLK_PERIOD / 2;

    monitor : process (clk)
    begin
        if rising_edge(clk) then
            if press = '1' then
                press_count <= press_count + 1;
            end if;
        end if;
    end process;

    stim : process

        procedure wait_cycles(n : in positive) is
        begin
            for i in 1 to n loop
                wait until rising_edge(clk);
            end loop;
            wait for 1 ns;
        end procedure;

        procedure bounce_then(final : in STD_LOGIC) is
        begin
            for i in 1 to 3 loop
                btn <= not final;
                wait_cycles(1);
                btn <= final;
                wait_cycles(2);
                btn <= not final;
                wait_cycles(1);
            end loop;
            btn <= final;
        end procedure;

        procedure check_presses(expected : in natural; name : in string) is
        begin
            if press_count = expected then
                report "PASS: " & name;
            else
                report "FAIL: " & name & " -> expected " &
                       integer'image(expected) & " press(es), got " &
                       integer'image(press_count)
                       severity error;
            end if;
        end procedure;

        constant SETTLE : positive := TICKS + 6;

    begin
        wait_cycles(SETTLE);
        btn <= '0';
        wait_cycles(SETTLE);
        check_presses(1, "T1: clean press -> one pulse");

        wait_cycles(3 * TICKS);
        check_presses(1, "T2: holding adds no pulses");

        btn <= '1';
        wait_cycles(SETTLE);
        check_presses(1, "T3: release adds no pulses");

        bounce_then('0');
        wait_cycles(SETTLE);
        check_presses(2, "T4: bouncy press -> exactly one pulse");

        bounce_then('1');
        wait_cycles(SETTLE);
        check_presses(2, "T5: bouncy release adds no pulses");

        btn <= '0';
        wait_cycles(2);
        btn <= '1';
        wait_cycles(SETTLE);
        check_presses(2, "T6: short glitch rejected");

        btn <= '0';
        wait_cycles(SETTLE);
        check_presses(3, "T7: next real press counted");

        report "SIMULATION DONE";
        finish;
    end process;

end test;
