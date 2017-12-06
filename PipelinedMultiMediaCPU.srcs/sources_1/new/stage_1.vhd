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
        regA        : out std_logic_vector(size - 1 downto 0); --address for rs1; regA
        regB        : out std_logic_vector(size - 1 downto 0); --address for rs2; regB
        regC        : out std_logic_vector(size - 1 downto 0); --address for rs3; regC
        regD        : out std_logic_vector(size - 1 downto 0); --address for destination register
        aluOpp      : out std_logic_vector(2 downto 0);        --ALU Oppcode. Incicates function     
        immediate   : out std_logic_vector(15 downto 0);       --16-bit immediate for li
        write_en    : out std_logic;                                  --write enable control signal
        msmux_sel   : out std_logic_vector(1 downto 0);               --mux to alu second param
        alumux_sel  : out std_logic_vector(2 downto 0);               --mux for stage 3 output
        ma_ms_sel   : out std_logic                                   --multiple add/sub high or low. 
    );
end stage_1;

architecture structural of stage_1 is
signal addr  : std_logic_vector(size - 1 downto 0);
signal instr : std_logic_vector(width - 1 downto 0);
begin
		--Program Counter--
	pc: entity xil_defaultlib.binary_counter
        generic map(n => size)
		port map(clk => clk, rst_bar => rst_bar, count => addr);
		--Instruction Fetch--
	ib: entity xil_defaultlib.instruction_buffer
		generic map(size => size, width => width)
		port map(addr => addr, d => instruction, write => write, clk => clk, q => instr);
        --Instruction Decoder--
    id: entity xil_defaultlib.if_id_reg
        generic map(instr_size => width, addr_length => size)
        port map(clk => clk, instruction => instr,
        regA      =>    regA        ,
        regB      =>    regB        ,
        regC      =>    regC        ,
        regD      =>    regD        ,
        aluOpp    =>    aluOpp      ,
        immediate =>    immediate   ,
        write_en  =>    write_en    ,
        msmux_sel =>    msmux_sel   ,
        alumux_sel=>    alumux_sel  ,
        ma_ms_sel =>    ma_ms_sel
        );
end structural;
