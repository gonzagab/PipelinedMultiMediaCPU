----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 03:02:15 AM
-- Design Name: 
-- Module Name: instruction_buffer - behavioral
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

entity instruction_buffer is
    generic(
		size  : integer := 5;	--Buffer Capacity(2^size)
		width : integer := 24 	--Buffer width
    );		
	port(
	   --Inputs--
	addr  : in std_logic_vector(size - 1 downto 0);	 --Connected to program counter
	d     : in std_logic_vector(width - 1 downto 0); --input form testbench
	write : in std_logic;                            --usually 0 unless testbench is writing to it
    clk   : in std_logic;                            --System clk
	   --Outputs--
	q     : out std_logic_vector(width-1 downto 0)
	);
end instruction_buffer;

architecture behavioral of instruction_buffer is
type MEM is array(0 to (2**size)-1) of std_logic_vector(width-1 downto 0);
signal memory : MEM;
begin
	fetch: process(addr)
	begin
		q <= memory(to_integer(unsigned(addr)));
	end process;
	wrt: process(clk)
	begin
		if (write = '1' and rising_edge(clk)) then
			memory(to_integer(unsigned(addr))) <= d;
		end if;
	end process;
end behavioral;
