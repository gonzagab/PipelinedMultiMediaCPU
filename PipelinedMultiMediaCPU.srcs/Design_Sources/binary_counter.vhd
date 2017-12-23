----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 03:16:30 AM
-- Design Name: 
-- Module Name: binary_counter - behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity binary_counter is
    generic(n : integer := 4);	--number of bits for count
    port(
            --Inputs-- 
        rst_bar : in std_logic;    --Synchronous Reset (active low)
        clk     : in std_logic;
            --Outputs--
        count : out std_logic_vector(n-1 downto 0)
);
end binary_counter;

architecture behavioral of binary_counter is
begin
    cnt_up: process(clk)
    variable cnt : unsigned(n-1 downto 0);
	begin
        if (rising_edge(clk)) then
			if (rst_bar = '1') then
				cnt := cnt + 1;
			else
				cnt := to_unsigned(0, n);
			end if;
		end if;
		count <= std_logic_vector(cnt);
	end process;
end behavioral;
