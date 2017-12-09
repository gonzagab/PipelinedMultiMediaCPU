-------------------------------------------------------------------------------
--
-- Title       : shiftLeftHalfImm
-- Design      : lab001
-- Author      : VictorTellez
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\myProcessor\lab001\src\shiftLeftHalfImm.vhd
-- Generated   : Wed Dec  6 11:51:34 2017
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {shiftLeftHalfImm} architecture {shiftLeftHalfImm}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all; 
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity shiftLeftHalfImm is	  
	port(
	rs1 : in STD_LOGIC_VECTOR(63 downto 0); 
	rs2 : in STD_LOGIC_VECTOR(4 downto 0);
	output : out STD_LOGIC_VECTOR(63 downto 0));
end shiftLeftHalfImm;

--}} End of automatically maintained section

architecture behavior of shiftLeftHalfImm is
	SIGNAL rs1a : STD_LOGIC_VECTOR(15 DOWNTO 0); 
	SIGNAL rs1b : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL rs1c : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL rs1d : STD_LOGIC_VECTOR(15 DOWNTO 0);
	Signal shift: Std_logic_vector(3 downto 0);
	begin  
	shft: process(rs1, rs2)  
	begin
	   rs1a <= rs1(15 downto 0) ;	
	   rs1b <= rs1(31 downto 16) ;
	   rs1c <= rs1(47 downto 32) ;
	   rs1d <= rs1(63 downto 48) ;
	   shift <= rs2 (3 downto 0) ;
	-- to_integer(unsigned(rotateBy)) 
		--qtmp <=qtmp( 62 DOWNTO 0) & qtmp(63);
		output(15 downto 0) <= std_logic_vector(unsigned(rs1a) sll to_integer(unsigned(shift))); 
		output(31 downto 16) <= std_logic_vector(unsigned(rs1b) sll to_integer(unsigned(shift)));
		output(47 downto 32) <= std_logic_vector(unsigned(rs1c) sll to_integer(unsigned(shift)));
		output(63 downto 48) <= std_logic_vector(unsigned(rs1d) sll to_integer(unsigned(shift)));
		
	
 	END PROCESS;  
 	
	 
end behavior;
