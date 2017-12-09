-------------------------------------------------------------------------------
--
-- Title       : rotatorRight
-- Design      : lab001
-- Author      : VictorTellez
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\myProcessor\lab001\src\rotatorRight.vhd
-- Generated   : Wed Dec  6 09:56:23 2017
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
--{entity {rotatorRight} architecture {behavioral}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity rotatorRight is
	 port(
	 	rotateBy : in STD_LOGIC_VECTOR(5 downto 0); 
	 	input : in STD_LOGIC_VECTOR(63 downto 0);
		 output : out STD_LOGIC_VECTOR(63 downto 0)
	     );
end rotatorRight;

--}} End of automatically maintained section

architecture behavioral of rotatorRight is
SIGNAL qtmp : STD_LOGIC_VECTOR(63 DOWNTO 0); 
	BEGIN  
	rotate: process(rotateBy, input)  
	begin
	   qtmp <= input ;
	for i in 0 to to_integer(unsigned(rotateBy)) loop
		qtmp <=qtmp( 62 DOWNTO 0) & qtmp(63);
	
	end loop;
   
	
 	END PROCESS;  
 output <= qtmp;
 END behavioral;
