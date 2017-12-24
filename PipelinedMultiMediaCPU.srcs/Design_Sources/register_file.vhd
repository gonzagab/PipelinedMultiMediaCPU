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
        reg_a    : in std_logic_vector(size-1 downto 0);  --address to register 1
        reg_b    : in std_logic_vector(size-1 downto 0);  --address to register 2
        reg_c    : in std_logic_vector(size-1 downto 0);  --address to register 3
        reg_wrt  : in std_logic_vector(size-1 downto 0);  --address to register to be written
        data_wrt : in std_logic_vector(width-1 downto 0); --data to be written
        wrt_en : in std_logic;
            --Outputs--
        data_a  : out std_logic_vector(width-1 downto 0);
        data_b  : out std_logic_vector(width-1 downto 0);
        data_c  : out std_logic_vector(width-1 downto 0)
	);
end register_file;

architecture behavioral of register_file is
type MEM is array(0 to (2**size) - 1) of std_logic_vector(width-1 downto 0);
signal registers: MEM;
begin
	rd_wrt: process(reg_a, reg_b, reg_c, reg_wrt, data_wrt, wrt_en)
	begin
		if (wrt_en = '1') then
			registers(to_integer(unsigned(reg_wrt))) <= data_wrt;
		end if;
		data_a <= registers(to_integer(unsigned(reg_a)));
		data_b <= registers(to_integer(unsigned(reg_b)));
        data_c <= registers(to_integer(unsigned(reg_c)));
	end process;
end behavioral;
