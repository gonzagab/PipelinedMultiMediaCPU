-------------------------------------------------------------------------------
--
-- Title       : leadingZero
-- Design      : lab001
-- Author      : VictorTellez
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\myProcessor\lab001\src\leadingZero.vhd
-- Generated   : Wed Dec  6 08:53:20 2017
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
--{entity {leadingZero} architecture {behavioral}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use IEEE.NUMERIC_STD.ALL;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity leadingZero is
	 port(
		 input : in STD_LOGIC_VECTOR(0 to 15);
		 output : out STD_LOGIC_VECTOR(0 to 15)
	     );
end leadingZero;

--}} End of automatically maintained section

architecture behavioral of leadingZero is	
begin
  calc_proc: process (input)
    variable count : unsigned (15 downto 0);
    begin
        count := to_unsigned(0, 16);
        for i in 15 downto 0 loop
            exit when input(i) = '1';
            count := count + 1;
        end loop;
        output <= std_logic_vector(count);
    end process;

end behavioral;

