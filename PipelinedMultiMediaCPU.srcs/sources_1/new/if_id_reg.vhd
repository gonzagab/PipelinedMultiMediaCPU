----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 03:16:30 AM
-- Design Name: 
-- Module Name: if_id_reg - behavioral
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
use IEEE.STD_LOGIC_1164.all;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity if_id_reg is
    generic(
        instr_size  : integer := 24;
        addr_length : integer := 5
    );
	port(
            --Input--
        instruction : in std_logic_vector(instr_size - 1 downto 0);
        clk         : in std_logic;	--system clock
            --Output--
        regA        : out std_logic_vector(addr_length - 1 downto 0); --address for rs1; regA
        regB        : out std_logic_vector(addr_length - 1 downto 0); --address for rs2; regB
        regC        : out std_logic_vector(addr_length - 1 downto 0); --address for rs3; regC
        regD        : out std_logic_vector(addr_length - 1 downto 0); --address for destination register
        aluOpp      : out std_logic_vector(2 downto 0);               --ALU Oppcode. Incicates function	 
        immediate   : out std_logic_vector(15 downto 0);              --16-bit immediate for li
        ms4b        : out std_logic_vector(3 downto 0);               --4 ms bits of instruction
        mpyOpp      : out std_logic;
        shftOpp     : out std_logic
	);						 						
end if_id_reg;

architecture behavioral of if_id_reg is
begin
    p1: process(clk)
    begin
        if(rising_edge(clk))then
                --output all known data--
            regD 	  <= instruction(4 downto 0);
			regA      <= instruction(9 downto 5);
			regB      <= instruction(14 downto 10);
            regC 	  <= instruction(19 downto 15);
			immediate <= instruction(20 downto 5);
			ms4b      <= instruction(23 downto 20);
                --decode alu opp--
			if (instruction(18 downto 15) = "0010") then
				aluOpp <= "010";    --AND--
			elsif (instruction(18 downto 15) = "0011") then
				aluOpp <= "011";    --OR--
			elsif (instruction(18 downto 15) = "0000") then
				aluOpp <= "000";    --NOP--
			elsif (instruction(18 downto 15) = "1000") then
				aluOpp <= "001";    --SUM--
            elsif (instruction(18 downto 15) = "1001") then
                aluOpp <= "101";    --SUB--
			else
				aluOpp <= "000";
			end if;
			--GOING TO NEED SOME TYPE OF SHIFT UNIT--
			if(instruction(15 downto 12) = "0111")then
				shftOpp <= '1';
			else
				shftOpp <= '0';
			end if;
			--AND MULTYPLYING UNIT--
			if(instruction(15 downto 12) = "1111")then
				mpyOpp <= '1';
			else
				mpyOpp <= '0';
			end if;
		end if;
	end process;	
end behavioral;
