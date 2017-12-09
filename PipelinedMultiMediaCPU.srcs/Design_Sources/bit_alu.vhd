----------------------------------------------------------------------------------
-- Create Date:     07/18/2017 05:07:27 PM
-- Module Name:     bit_alu - structural
-- Project Name:    pipelined_multimedia_cell_lite_unit
-- Target Devices:  Spartan 7 - xc7s50csga324-1
--
-- Description:
--  Smallest ALU component. Contains a multiplexer that chooses betweeen
-- OR, AND, and Full Adder opperations. ALU Operations:
--  - 000: 0
--  - 001: sum
--  - 010: and
--  - 011: or
--  - 101: subtract
--
-- Inputs:
--  a      - One-bit number.
--  b      - One-bit number.
--  c_in   - Carry in bit or Borrow bit.
--  aluOpp - Operation to be performed on 'a' and 'b'.
--
-- Outputs:
--  result - One-bit result of the operation performed on 'a' and 'b'.
--  c_out  - Carry out.
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity bit_alu is
    port(
            --Inputs--
        a      : in std_logic;
        b      : in std_logic;
        c_in   : in std_logic;
        aluOpp : in std_logic_vector(2 downto 0); --3 bit aluOpp
            --Outputs--
        result : out std_logic;
        c_out  : out std_logic
	);
end bit_alu;

architecture structural of bit_alu is
--Subtraction Conversion--
signal b_xor    : std_logic;
--Signals to the Multiplexer--
signal mux_in : std_logic_vector(3 downto 0);
begin
    --FULL ADDER/Full Subtractor--
    b_xor <= b xor aluOpp(2);
    full_adder_full_sub: entity xil_defaultlib.full_adder
    port map (
            --Inputs--
        a     => a,
        b     => b_xor,
        c_in  => c_in,
            --Outputs--
        sum   => mux_in(1),
        c_out => c_out
    );
    --AND GATE--
    and_gate: entity xil_defaultlib.and_gate
	   port map (
	       a => a,
	       b => b,
	       q => mux_in(2)
       );
    --OR GATE--
	or_gate: entity xil_defaultlib.or_gate
	   port map (
	       a => a,
	       b => b,
	       q => mux_in(3)
       );
    --MULTIPLEXER--
    mux_in(0) <= '0';
    mux: entity xil_defaultlib.mux_n_in_1_out 
        generic map(n => 2)
        port map (
                --Inputs--
            slct     => aluOpp(1 downto 0),
            input(0) => mux_in(0),
            input(1) => mux_in(1),
            input(2) => mux_in(2),
            input(3) => mux_in(3),
                --Output--
            output => result
        );
end structural;