----------------------------------------------------------------------------------
-- Engineer:        Bryant Gonzaga
-- Create Date:     09/17/2017 10:06:53 PM
-- Module Name:     alu_16bit_with_cla_tb - testbench
-- Project Name:    pipelined_multimedia_cell_lite_unit
-- Target Devices:  Spartan 7 - xc7s50csga324-1
--
-- Description:
--  This is an exhaustive self checking testbench for a 16 bit ALU with a Carry
-- Look-Ahead Unit. Three-bit ALU Opp that can take the following values:
--  - 000: 0
--  - 001: sum
--  - 010: and
--  - 011: or
--  - 101: subtract
--
-- Inputs:
--  a      - 16-bit number
--  b      - 16-bit number
--  c_in   - Carry in
--  aluOpp - Opperation to be performed on 'a' and 'b'
--
-- Outputs:
--  results - 16-bit result of the operation performed on 'a' and 'b'
--  c_out   - Carry out
--  pg      - Super Generate
--  gg      - Super Propagate
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity alu_16bit_with_cla_tb is
end alu_16bit_with_cla_tb;

architecture testbench of alu_16bit_with_cla_tb is
--Input Signals--
signal a      : std_logic_vector(15 downto 0);
signal b      : std_logic_vector(15 downto 0);
signal aluOpp : std_logic_vector(2 downto 0);
signal c_in   : std_logic;
signal is_top : std_logic;
--Output Signals--
signal result : std_logic_vector(15 downto 0);
signal c_out  : std_logic;
signal pg     : std_logic;
signal gg     : std_logic;
--Sim End Signal--
Signal sim_end : boolean := false;
--Some wait delay time--
signal delay   : time := 20 ns;

begin
    --Unit Under Testing--
    uut: entity xil_defaultlib.alu_16bit_with_cla
        port map (
                --Inputs--
            a      => a,
            b      => b,
            aluOpp => aluOpp,
            c_in   => c_in,
            is_top => is_top,
                --Outputs--
            result => result,
            c_out   => c_out,
            pg      => pg,
            gg      => gg
        );
    --Stimulus Process--
    stim_proc: process
    begin
            --Initialize all Signals--
        a       <= (others => '0');
        b       <= (others => '0');
        aluOpp  <= (others => '0');
        c_in    <= '0';
        is_top  <= '1';
        sim_end <= false;
    --  assert (result = "0000") 
    --            report 
    --              "a: " & to_string(a(3)) & to_string(a(2)) & to_string(a(1)) & to_string(a(0))
    --            & "b: " & to_string(b(3)) & to_string(b(2)) & to_string(b(1)) & to_string(b(0))
    --            & "result: " & to_string(result(3)) & to_string(result(2)) 
    --                         & to_string(result(1)) & to_string(result(0))
    --                severity error;
        wait for delay;
        --SUM--
        aluOpp  <= "001";
        for i in 0 to 65535 loop
            a <= std_logic_vector(to_unsigned(i, 16));
            for j in 0 to 65535 loop
                b <= std_logic_vector(to_unsigned(j, 16));
    --                assert (result = std_logic_vector(to_unsigned(i + j, 4)))
    --                    report "a: " & to_string(a) & "b: " & to_string(b) & 
    --                    "result: " & to_string(result)
    --                        severity error;
                wait for delay;
            end loop;
        end loop;
        --AND--
        aluOpp  <= "010";
        for i in 0 to 65535 loop
            a <= std_logic_vector(to_unsigned(i, 16));
            for j in 0 to 65535 loop
                b <= std_logic_vector(to_unsigned(j, 16));
    --                assert (result = (std_logic_vector(to_unsigned(i, 4)) and 
    --                    std_logic_vector(to_unsigned(j, 4))))
    --                        report "a: " & to_string(a) & "b: " & to_string(b) & 
    --                        "result: " & to_string(result)
    --                            severity error;
                wait for delay;
            end loop;
        end loop;
        --OR--
        aluOpp  <= "011";
        for i in 0 to 65535 loop
            a <= std_logic_vector(to_unsigned(i, 16));
            for j in 0 to 65535 loop
                b <= std_logic_vector(to_unsigned(j, 16));
    --                assert (result = (std_logic_vector(to_unsigned(i, 4)) or 
    --                    std_logic_vector(to_unsigned(j, 4))))
    --                        report "a: " & to_string(a) & "b: " & to_string(b) & 
    --                        "result: " & to_string(result)
    --                            severity error;
                wait for delay;
            end loop;
        end loop;
        --SUBTRACTION--
        aluOpp  <= "101";
        for i in 0 to 65535 loop
            a <= std_logic_vector(to_unsigned(i, 16));
            for j in 0 to 65535 loop
                b <= std_logic_vector(to_unsigned(j, 16));
    --                assert (result = std_logic_vector(to_unsigned(i - j, 4)))
    --                    report "a: " & to_string(a) & "b: " & to_string(b) & 
    --                    "result: " & to_string(result)
    --                        severity error;
                wait for delay;
            end loop;
        end loop;
        --Simulation End--
        sim_end <= true;
        wait;
    end process;
end testbench;
