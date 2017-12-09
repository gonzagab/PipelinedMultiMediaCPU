-------------------------------------------------------------------------------
--
-- Title       : hamming
-- Design      : lab001
-- Author      : VictorTellez
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\myProcessor\lab001\src\hamming.vhd
-- Generated   : Wed Dec  6 03:17:40 2017
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
--{entity {hamming} architecture {behavioral}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.ALL;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity hamming is
	 port(
		 input : in STD_LOGIC_VECTOR(15 downto 0);
		 output : out STD_LOGIC_VECTOR(15 downto 0)
		 
	     );
end hamming;

--}} End of automatically maintained section

architecture behavioral of hamming is
begin

    calc_proc: process (input)
    variable count : unsigned (15 downto 0);
    begin
        count := to_unsigned(0, 16);
        for i in 15 downto 0 loop
            if (input(i) = '1')	  then
            	count := count + 1;
			end if;
        end loop;

        output <= std_logic_vector(count);

    end process;

end behavioral;