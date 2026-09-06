----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/06/2026 07:15:53 PM
-- Design Name: 
-- Module Name: counter_tb - rtl
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

entity counter_tb is
end counter_tb;

architecture bench of counter_tb is

    signal clk     : STD_LOGIC := '0';
    signal rst     : STD_LOGIC := '0';
    signal load    : STD_LOGIC := '0';
    signal data_in : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal en      : STD_LOGIC := '0';
    signal up_down : STD_LOGIC := '0';

    signal count : STD_LOGIC_VECTOR(3 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    dut : entity work.counter
        port map (
            clk     => clk,
            rst     => rst,
            load    => load,
            data_in => data_in,
            en      => en,
            up_down => up_down,
            count   => count
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

        procedure check_count(expected : in integer; name : in string) is
        begin
            if unsigned(count) = to_unsigned(expected, 4) then
                report "PASS: " & name;
            else
                report "FAIL: " & name & " -> expected " &
                       integer'image(expected) & ", got " &
                       integer'image(to_integer(unsigned(count)))
                       severity error;
            end if;
        end procedure;

        variable held : STD_LOGIC_VECTOR(3 downto 0);

    begin
        wait_cycles(5);
    
        rst <= '1';
        wait_cycles(1);
        rst <= '0';
        
        -- .3
        load    <= '1';
        data_in <= std_logic_vector(to_unsigned(10, 4));   -- 4'd10 = "1010"
        wait_cycles(1);

        load <= '0';

        check_count(10, "load 10");
        
        -- .4
        en <= '1';
        up_down <= '1';
        wait_cycles(3);
        check_count(13, "count up 10 -> 13");
        
        wait_cycles(3);
        
        check_count(0, "count up wrap 15 -> 0");
        
        -- .5
        held := count;
        en   <= '0';
        wait_cycles(2);

        check_count(to_integer(unsigned(held)), "hold with en=0");
               
        -- .6
        en <= '1';
        up_down <= '0';
        wait_cycles(1);
        
        check_count(15, "count down wrap 0 -> 15");
               
        -- .7
        
        load <= '1';
        data_in <= std_logic_vector(to_unsigned(5, 4));
        en <= '1';
        up_down <= '1';
        
        wait_cycles(1);

        check_count(5, "load priority over en");

        up_down <= '0';
        load <= '0';

        wait_cycles(2);

        check_count(3, "bonus: count down 5 -> 3, no wrap");

        report "SIMULATION DONE";
        finish;
    end process;

end bench;
