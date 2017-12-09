-------------------------------------------------------------------------------
--
-- Title       : boothMul
-- Design      : lab001
-- Author      : VictorTellez
-- Company     : StonyBrook
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\myProcessor\lab001\src\boothMul.vhd
-- Generated   : Wed Dec  6 09:19:40 2017
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
--{entity {boothMul} architecture {boothMul}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
entity boothMulSigned is port(
    a   : in  std_logic_vector(15 downto 0);
    b   : in  std_logic_vector(15 downto 0);
    m   : out std_logic_vector(31 downto 0));
end boothMulSigned;
 
architecture arch of boothMulSigned is
begin
	m <= std_logic_vector(signed(a)*signed(b));
end arch;