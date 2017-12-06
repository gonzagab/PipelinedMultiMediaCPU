----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 03:16:30 AM
-- Design Name: 
-- Module Name: rd_ex_reg - behavioral
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

entity rd_ex_reg is
	port(
            --Inputs--
        dataAi      : in std_logic_vector(63 downto 0);	--data from register A; rs1
        dataBi      : in std_logic_vector(63 downto 0);	--data from register B; rs2
        dataCi      : in std_logic_vector(63 downto 0);	--data from register C; rs3
        aluOppi     : in std_logic_vector(2 downto 0);	--ALU Opp
        msmux_seli  : in std_logic_vector(1 downto 0);    --select for alu param input
        alumux_seli : in std_logic_vector(2 downto 0);
        
        clk        : in std_logic;						--System clock
            --Outputs--
        dataAo      : out std_logic_vector(63 downto 0);	--data from register A; rs1
        dataBo      : out std_logic_vector(63 downto 0);	--data from register B; rs2
        dataCo      : out std_logic_vector(63 downto 0);	--data from register C; rs3
        aluOppo     : out std_logic_vector(2 downto 0);	    --ALU opp
        msmux_selo  : out std_logic_vector(1 downto 0);    --select for alu param input
        alumux_selo : out std_logic_vector(2 downto 0)
	);
end rd_ex_reg;

architecture behavioral of rd_ex_reg is
begin
	p1: process(clk)
	begin
		if (rising_edge(clk)) then
			dataAo 	    <= dataAi;
			dataBo 	    <= dataBi;
			dataCo 	    <= dataCi;
			aluOppo     <= aluOppi;
			msmux_selo  <= msmux_seli;
            alumux_selo <= alumux_seli;
		end if;
	end process;
end behavioral;
