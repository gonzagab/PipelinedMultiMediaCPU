-------------------------------------------------------------------------------
--
-- Title       : broadcast
-- Design      : lab001
-- Author      : VictorTellez
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\myProcessor\lab001\src\broadcast.vhd
-- Generated   : Wed Dec  6 09:43:25 2017
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
--{entity {broadcast} architecture {behavioral}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity broadcast is
	 port(
		 input : in STD_LOGIC_VECTOR(0 to 31);
		 output : out STD_LOGIC_VECTOR(0 to 63)
	     );
end broadcast;

--}} End of automatically maintained section

architecture behavioral of broadcast is
begin

	 output<=  input & input;

end behavioral;
