----------------------------------------------------------------------------------
-- Engineer:        Bryant Gonzaga
-- Create Date:     07/18/2017 06:59:09 PM
-- Module Name:     carry_lookahead_4bit - datatflow
-- Project Name:    pipelined_multimedia_cell_lite_unit
-- Target Devices:  Spartan 7 - xc7s50csga324-1
--
-- Description:
--  Four-bit Carry Look-Ahead Unit. Takes a four-bit propogate vector and a
-- four-bit generate vector. Along with a carry-in bit to produce the next
-- four carry-outs, a super propagate and a super generate.
--
-- Inputs:
--  p    - Four-bit vector for the carry propagate.
--  g    - Four-bit vector for the carry generate.
--  c_in - Carry-in bit.
--
-- Outputs:
--  c_out - Four-bit vector for the next four carry-out bits. e.g.: c(0) to c(3)
--  pg    - Group Propagate bit.
--  gg    - Group Generate bit.
--
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity carry_lookahead_4bit is
    port(
            --Inputs--
        p:    in std_logic_vector(3 downto 0);
        g:    in std_logic_vector(3 downto 0);
        c_in: in std_logic;
            --Outputs--
        c_out: out std_logic_vector(3 downto 0);
        pg:	   out std_logic;
        gg:    out std_logic
    );
end carry_lookahead_4bit;

architecture dataflow of carry_lookahead_4bit is
begin
	--C0--
	c_out(0) <= g(0) or (p(0) and c_in);
	--C1--
	c_out(1) <= g(1) or (g(0) and p(1)) or (p(0) and p(1) and c_in);
	--C2--
	c_out(2) <= g(2) or (g(1) and p(2)) or (g(0) and p(1) and p(2)) or (p(0)
	               and p(1) and p(2) and c_in);
	--C3--
	c_out(3) <= g(3) or (g(2) and p(3)) or (g(1) and p(2) and p(3)) or
                (g(0) and p(1) and p(2) and p(3)) or 
                (p(0) and p(1) and p(2) and p(3) and c_in);
	--Super Propagate--
	pg <= p(3) and p(2) and p(1) and p(0);
	--Super Generate--
	gg <= g(3) or (p(3) and g(2)) or (p(3) and p(2) and g(1)) or (p(3) and
	        p(2) and p(1) and g(0));
end dataflow;
