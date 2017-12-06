----------------------------------------------------------------------------------
-- Engineer:        Bryant Gonzaga
-- Create Date:     07/14/2017 10:49:37 PM
-- Module Name:     full_adder - datatflow
-- Project Name:    pipelined_multimedia_cell_lite_unit
-- Target Devices:  Spartan 7 - xc7s50csga324-1
--
-- Description:
--  Full Adder that takes two one-bit numbers, and a carry-in. Produces the sum
-- and carry-out bits.
--
-- Inputs:
--  a    - One-bit number to be added.
--  b    - One-bit number to be added.
--  c_in - Carry in or Borrow bit.
--
-- Outputs:
--  sum   - One-bit sum of 'a' and 'b'.
--  c_out - Carry out.
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    port(
            --Inputs--
        a       : in std_logic;
        b       : in std_logic;
        c_in    : in std_logic;
            --Outputs--
        sum     : out std_logic;
        c_out   : out std_logic
	);
end full_adder;

architecture dataflow of full_adder is
begin
    sum   <= (a xor b) xor c_in;
    c_out <= (a and b) or ((a xor b) and c_in);
end dataflow;
