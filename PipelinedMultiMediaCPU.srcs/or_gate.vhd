----------------------------------------------------------------------------------
-- Engineer:        Bryant Gonzaga
-- Create Date:     07/18/2017 05:20:07 PM
-- Module Name:     or_gate - dataflow
-- Project Name:    pipelined_multimedia_cell_lite_unit
-- Target Devices:  Spartan 7 - xc7s50csga324-1
--
-- Description:
--  An OR gate
--
-- Inputs:
--  a - One-bit number
--  b - One-bit number
--
-- Outputs:
--  q - One-bit result of 'a' OR 'b'
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity or_gate is
    port (
	       --Inputs--
        a: in std_logic;
        b: in std_logic;
            --Outputs--
        q: out std_logic
    );
end or_gate;

architecture dataflow of or_gate is
begin
    q <= a or b;
end dataflow;