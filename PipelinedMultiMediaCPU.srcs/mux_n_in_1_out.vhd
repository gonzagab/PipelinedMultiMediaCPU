----------------------------------------------------------------------------------
-- Engineer:        Bryant Gonzaga
-- Create Date:     07/18/2017 05:50:33 PM
-- Module Name:     mux_n_in_1_out - behavioral
-- Project Name:    pipelined_multimedia_cell_lite_unit
-- Target Devices:  Spartan 7 - xc7s50csga324-1
--
-- Description:
--  A multiplexer with 2^n 1-bit inputs and a 1-bit outpus.
--
-- Generics:
--  n - Length of select.
--
-- Inputs:
--  input - 2^n 1-bit inputs.
--  slct  - n bit number denoting which input to select to output.
-- Outputs:
--  output - One-bit output.
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity mux_n_in_1_out is
    generic(n : integer := 2);
    port(
            --Inputs--
        input  : in std_logic_vector(2**n - 1 downto 0);
        slct   : in std_logic_vector(n - 1 downto 0);
            --Outputs--
        output : out std_logic
    );
end mux_n_in_1_out;

architecture behavioral of mux_n_in_1_out is
begin
    output <= input(to_integer(unsigned(slct)));
end behavioral;
