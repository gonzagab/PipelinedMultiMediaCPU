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
            --Input--
        dataA       : in std_logic_vector(63 downto 0);
        dataB       : in std_logic_vector(63 downto 0);
        dataC       : in std_logic_vector(63 downto 0);
        aluOpp      : in std_logic_vector(2 downto 0);        --ALU Oppcode. Incicates function
        alu_opp_len : in std_logic_vector(1 downto 0);        --64/32/16
        msmux_sel   : in std_logic_vector(1 downto 0);        --mux to alu second param
        alumux_sel  : in std_logic_vector(2 downto 0);        --mux for stage 3 output
        
        clk         : in std_logic;     --system clock--
            --Output--
        result      : out std_logic_vector(63 downto 0)
    );
end stage_3;

architecture structural of stage_3 is
signal alu_param2 : std_logic_vector(63 downto 0);
--Results--
signal alu_result   : std_logic_vector(63 downto 0);
signal mpy_result   : std_logic_vector(63 downto 0);
signal shift_result : std_logic_vector(63 downto 0);
signal broad_result : std_logic_vector(63 downto 0);
signal ham_result   : std_logic_vector(63 downto 0);
signal zero_result  : std_logic_vector(63 downto 0);
begin
        --Choose ALU Param 2-- 
    msMux: process(dataB, dataC, msmux_sel)
    begin
        if (msmux_sel = "00") then
            alu_param2 <= std_logic_vector(to_unsigned(0, 64));
        elsif (msmux_sel = "01") then
            alu_param2 <= dataB;
        elsif (msmux_sel = "10") then
            alu_param2 <= dataC;
        else
            alu_param2 <= std_logic_vector(to_unsigned(0, 64));
        end if;
    end process;

        --64 Bit ALU--
    alu_64bit: entity xil_defaultlib.alu_64bit_with_cla
        port map(
            a       => dataA,
            b       => alu_param2,
            aluOpp  => aluOpp,
            opp_len => alu_opp_len,
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
    res_mux: process(alu_result, mpy_result, shift_result, broad_result, ham_result, zero_result)
    begin
        if (alumux_sel = "000") then
            result <= alu_result;
        elsif (alumux_sel = "001") then
            result <= mpy_result;
        elsif (alumux_sel = "010") then
            result <= shift_result;
        elsif (alumux_sel = "011") then
            result <= broad_result;
        elsif (alumux_sel = "100") then
            result <= ham_result;
        elsif (alumux_sel = "101") then
            result <= zero_result;
        else
            result <= std_logic_vector(to_unsigned(0, 64));
        end if;
    end process;  
end structural;
