----------------------------------------------------------------------------------
-- Create Date:     07/20/2017 12:08:40 PM
-- Module Name:     alu_16bit_with_cla - structural
-- Project Name:    pipelined_multimedia_cell_lite_unit
-- Target Devices:  Spartan 7 - xc7s50csga324-1
--
-- Description:
--  Sixteen bit ALU with a Carry Look-Ahead Unit, to speed up addition. Three-bit
-- ALU Opp that can take the following values:
--  - 000: 0
--  - 001: sum
--  - 010: and
--  - 011: or
--  - 101: subtract
--
-- Inputs:
--  a      - Sixteen-bit number
--  b      - Sixteen-bit number
--  c_in   - Carry in or Borrow
--  aluOpp - Opperation to be performed on 'a' and 'b'
--  is_top - is Top Level Module. Used to decide to invert c_in.
--
-- Outputs:
--  results - Sixteen-bit result of the operation performed on 'a' and 'b'
--  c_out   - Carry out
--  pg      - Group Propagate
--  gg      - Group Generate
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity alu_16bit_with_cla is
    port(
            --Inputs--
        a      : in std_logic_vector(15 downto 0);
        b      : in std_logic_vector(15 downto 0);
        aluOpp : in std_logic_vector(2 downto 0);
        c_in   : in std_logic;
        is_top : in std_logic;
            --Outputs--
        result : out std_logic_vector(15 downto 0);
        c_out  : out std_logic;
        pg     : out std_logic;
        gg     : out std_logic
    );
end alu_16bit_with_cla;

architecture structural of alu_16bit_with_cla is
--Carry Propagate Signals--
signal p : std_logic_vector(3 downto 0);
--Carry Generate Signals--
signal g : std_logic_vector(3 downto 0);
--Carry Ins/Outs--
signal c : std_logic_vector(3 downto 0);
signal c_xor: std_logic;

begin
    --CARRY LOOK-AHEAD UNIT--
    c_xor <= c_in xor (aluOpp(2) and is_top);
    cla: entity xil_defaultlib.carry_lookahead_4bit
    port map (
            --Inputs--
        p    => p, 
        g    => g,
        c_in => c_xor,
            --Outputs--
        pg    => pg,
        gg    => gg,
        c_out => c
    );
    --ALU GENERATOR--
    bit_alu_0: entity xil_defaultlib.alu_4bit_with_cla
        port map (
                --Inputs--
            a      => a(3 downto 0),
            b      => b(3 downto 0),
            aluOpp => aluOpp,
            c_in   => c_xor,
            is_top => '0',
                --Outputs--
            result => result(3 downto 0),
            pg     => p(0),
            gg     => g(0) 
        );
    gen_alu: for i in 1 to 3 generate
        bit_alu_i: entity xil_defaultlib.alu_4bit_with_cla
            port map (
                    --Inputs--
                a      => a(3+(i*4) downto 0+(i*4)),
                b      => b(3+(i*4) downto 0+(i*4)),
                aluOpp => aluOpp,
                c_in   => c(i - 1),
                is_top => '0',
                    --Outputs--
                result => result(3+(i*4) downto 0+(i*4)),
                pg     => p(i),
                gg     => g(i) 
                );
    end generate;
    c_out <= c(3) xor aluOpp(2);
end structural;
