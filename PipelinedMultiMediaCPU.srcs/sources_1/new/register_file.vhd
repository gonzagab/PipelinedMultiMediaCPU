----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 03:16:30 AM
-- Design Name: 
-- Module Name: register_file - behavioral
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
use IEEE.NUMERIC_STD.all;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity register_file is
    generic(
		size : integer := 5; 	--size of register file (2^size)
		width: integer := 64	--width of register file
	);
	port(
            --Inputs--
        regA	: in std_logic_vector(size-1 downto 0);	--address to register 1
        regB	: in std_logic_vector(size-1 downto 0);	--address to register 2
        regC	: in std_logic_vector(size-1 downto 0);	--address to register 3
        regWrt  : in std_logic_vector(size-1 downto 0);	--address to register to be written
        dataWrt	: in std_logic_vector(width-1 downto 0);--data to be written
        write	: in std_logic;
            --Outputs--
        dataA	: out std_logic_vector(width-1 downto 0);
        dataB	: out std_logic_vector(width-1 downto 0);
        dataC	: out std_logic_vector(width-1 downto 0)
	);
end register_file;

architecture behavioral of register_file is
type MEM is array(0 to (2**size) - 1) of std_logic_vector(width-1 downto 0);
signal registers: MEM;
begin
	rd_wrt: process(regA, regB, regC, regWrt, dataWrt, write)
	begin
		if (write = '1') then
			registers(to_integer(unsigned(regWrt))) <= dataWrt;
		end if;
		dataA <= registers(to_integer(unsigned(regA)));
		dataB <= registers(to_integer(unsigned(regB)));
        dataC <= registers(to_integer(unsigned(regC)));
	end process;
end behavioral;
