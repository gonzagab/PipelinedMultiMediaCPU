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

entity id_ex_reg is
	port(
		--Inputs--
	dataAi:		in std_logic_vector(63 downto 0);	--data from register A; rs1
	dataBi:		in std_logic_vector(63 downto 0);	--data from register B; rs2
	dataCi:		in std_logic_vector(63 downto 0);	--data from register C; rs3
	aluOppi: 	in std_logic_vector(2 downto 0);	--ALU Opp
	
	mpyOppi:	in std_logic;
	shftOppi:	in std_logic;
	
	regDi      : in std_logic_vector(4 downto 0);	--register address to be written; rd
	immediate  : in std_logic_vector(15 downto 0);	--data to be write for lv
	clk        : in std_logic;						--System clock
		--Outputs--
	dataAo     : out std_logic_vector(63 downto 0);	--data from register A; rs1
	dataBo     : out std_logic_vector(63 downto 0);	--data from register B; rs2
	dataCo     : out std_logic_vector(63 downto 0);	--data from register C; rs3
	aluOppo    : out std_logic_vector(2 downto 0);	--ALU opp
	writeo     : out std_logic;						--Write signal
	regDo      : out std_logic_vector(3 downto 0);	--Register address
	dataW      : out std_logic_vector(63 downto 0);	--data to be written
	
	mpyOppo:	out std_logic;
	shftOppo:	out std_logic
	);
end id_ex_reg;

architecture behavioral of id_ex_reg is
begin
	p1: process(clk)
	begin
		if (rising_edge(clk)) then
			dataAo 	<= dataAi;
			dataBo 	<= dataBi;
			dataCo 	<= dataCi;
			aluOppo <= aluOppi;
			regDo 	<= regDi;
			
			mpyOppo <= mpyOppi;
			shftOppo <= shftOppi;
		end if;
	end process;
end behavioral;
