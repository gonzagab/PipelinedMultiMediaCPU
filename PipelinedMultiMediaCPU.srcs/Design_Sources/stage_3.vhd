----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 05:37:22 AM
-- Design Name: 
-- Module Name: stage_3 - structural
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
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity stage_3 is
    port(
            --Inputs--
        data_a     : in std_logic_vector(63 downto 0); --Data A
        data_b     : in std_logic_vector(63 downto 0); --Data B
        alu_opp    : in std_logic_vector(2 downto 0);  --ALU Oppcode
        opp_len    : in std_logic_vector(1 downto 0);
        sgn_sat    : in std_logic;
        wrt_en     : in std_logic;
        reg_d      : in std_logic_vector(4 downto 0);
        immediate  : in std_logic_vector(15 downto 0);
        li_pos_i   : in std_logic_vector(1 downto 0);  --load immediate position
        rslt_sel   : in std_logic_vector(2 downto 0);
            --Outputs--
        result      : out std_logic_vector(63 downto 0);
        wrt_en_wb   : out std_logic;
        reg_wrt_wb  : out std_logic_vector(4 downto 0)
    );
end stage_3;

architecture structural of stage_3 is
--Results--
signal alu_result   : std_logic_vector(63 downto 0);
signal mpy_result   : std_logic_vector(63 downto 0);
signal shift_result : std_logic_vector(63 downto 0);
signal broad_result : std_logic_vector(63 downto 0);
signal ham_result   : std_logic_vector(63 downto 0);
signal zero_result  : std_logic_vector(63 downto 0);
begin
    --64 Bit ALU--
    alu_64bit: entity xil_defaultlib.alu_64bit_with_cla
        port map(
            a       => data_a,
            b       => data_b,
            aluOpp  => alu_opp,
            opp_len => opp_len,
            c_in    => '0',
            is_top  => '1',
                --Output--
            result  => alu_result
        );
        
    --Multiply Unit--    
    --Shift Unit--
    --Broadcast Unit-- 
    --Hamming Weight Unit--    
    --Leading Zero Unit--
    
    --Result MUX--
    res_mux: process(alu_result, mpy_result, shift_result, broad_result, ham_result, zero_result, rslt_sel)
    begin
        if (rslt_sel = "000") then
            result <= alu_result;
        elsif (rslt_sel = "001") then
            result <= mpy_result;
        elsif (rslt_sel = "010") then
            result <= shift_result;
        elsif (rslt_sel = "011") then
            result <= broad_result;
        elsif (rslt_sel = "100") then
            result <= ham_result;
        elsif (rslt_sel = "101") then
            result <= zero_result;
        elsif (rslt_sel = "110") then
            result <= std_logic_vector(to_unsigned(0, 64));
        else
            result <= std_logic_vector(to_unsigned(0, 64));
        end if;
    end process; 
    
    --Write Back Signals--
    wrt_en_wb <= wrt_en;
    reg_wrt_wb <= reg_d; 
end structural;
