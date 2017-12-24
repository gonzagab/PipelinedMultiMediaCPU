----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 05:37:22 AM
-- Design Name: 
-- Module Name: stage_1 - structural
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
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity stage_1 is
    generic(
        size  : integer := 5; --indicates the instr. buffer capacity(2^size)
        width : integer := 24 --buffer width. in bits
    );
    port(
            --Inputs--
        clk         : in std_logic;
        rst_bar     : in std_logic;
        write       : in std_logic;
        instruction : in std_logic_vector(width-1 downto 0);
            --Outputs--
        inst_type   : out std_logic_vector(1 downto 0);         --format of instruction
        li_pos      : out std_logic_vector(1 downto 0);         --position of 16 bit immediate
        immediate   : out std_logic_vector(15 downto 0);        --16-bit immediate for li
        reg_d       : out std_logic_vector(size - 1 downto 0);  --address for rd
        mult_opp    : out std_logic_vector(1 downto 0);         --mult. sub/add opp
        reg_c       : out std_logic_vector(size - 1 downto 0);  --address for rs3
        reg_b       : out std_logic_vector(size - 1 downto 0);  --address for rs2  
        reg_a       : out std_logic_vector(size - 1 downto 0)  --address for rs1
    );
end stage_1;

architecture structural of stage_1 is
signal addr : std_logic_vector(size - 1 downto 0);
signal inst : std_logic_vector(width - 1 downto 0);
begin
		--Program Counter--
	pc: entity xil_defaultlib.binary_counter
        generic map(n => size)
		port map(clk => clk, rst_bar => rst_bar, count => addr);
		--Instruction Fetch--
	ib: entity xil_defaultlib.instruction_buffer
		generic map(size => size, width => width)
		port map(addr => addr, d => instruction, write => write, clk => clk, q => inst);
		--Partition Instruction--
    partition: process (inst)
    begin
        inst_type <= inst(23 downto 22);
        li_pos    <= inst(22 downto 21);
        immediate <= inst(20 downto 5);
        reg_d     <= inst(4 downto 0);
        mult_opp  <= inst(21 downto 20);
        reg_c     <= inst(19 downto 15);
        reg_b     <= inst(14 downto 10);
        reg_a     <= inst(9 downto 5);
    end process;
end structural;
