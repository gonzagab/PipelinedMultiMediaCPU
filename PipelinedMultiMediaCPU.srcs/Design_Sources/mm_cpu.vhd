----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 11:16:29 AM
-- Design Name: 
-- Module Name: mm_cpu - structural
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

entity mm_cpu is
    port(
            --Inputs--
        clk         : in std_logic;
        rst_bar     : in std_logic;
        write       : in std_logic;
        instruction : in std_logic_vector(23 downto 0);
            --Output--
        result      : out std_logic_vector(63 downto 0)
    );
end mm_cpu;

architecture structural of mm_cpu is
--STAGE 1 --> STAGE 2--
signal regA        : std_logic_vector(4 downto 0); --address for rs1; regA
signal regB        : std_logic_vector(4 downto 0); --address for rs2; regB
signal regC        : std_logic_vector(4 downto 0); --address for rs3; regC

signal regD        : std_logic_vector(4 downto 0); --address for destination register
signal write_en    : std_logic;                    --write enable control signal
signal ma_ms_sel   : std_logic;                    --multiple add/sub high or low.

signal aluOpp      : std_logic_vector(2 downto 0); --ALU Oppcode. Incicates function
signal alu_opp_len : std_logic_vector(1 downto 0);     
signal immediate   : std_logic_vector(15 downto 0);--16-bit immediate for li
signal msmux_sel   : std_logic_vector(1 downto 0); --mux to alu second param
signal alumux_sel  : std_logic_vector(2 downto 0); --mux for stage 3 output

--STAGE 2 --> STAGE 3--
signal dataA       : std_logic_vector(63 downto 0);
signal dataB       : std_logic_vector(63 downto 0);
signal dataC       : std_logic_vector(63 downto 0);
signal aluOppo     : std_logic_vector(2 downto 0);        --ALU Oppcode. Incicates function
signal alu_opp_leno : std_logic_vector(1 downto 0);
signal msmux_selo  : std_logic_vector(1 downto 0);        --mux to alu second param
signal alumux_selo : std_logic_vector(2 downto 0);       --mux for stage 3 output

--STAGE 3 --> STAGE 2--
signal data_wb : std_logic_vector(63 downto 0);       --data to be saved to register file
begin
        --STAGE 1: Instruction fetch and decode--
    stage_1: entity xil_defaultlib.stage_1
        port map(
                --Input--
            clk         => clk,
            rst_bar     => rst_bar,
            write       => write,
            instruction => instruction,
                --Output--
            regA        => regA       ,
            regB        => regB       ,
            regC        => regC       ,

            regD        => regD       ,
            write_en    => write_en   ,
            ma_ms_sel   => ma_ms_sel  ,

            aluOpp      => aluOpp     ,
            alu_opp_len => alu_opp_len,
            immediate   => immediate  ,
            msmux_sel   => msmux_sel  ,
            alumux_sel  => alumux_sel 
        );
        
        
                --Instruction Decoder--
    id: entity xil_defaultlib.if_id_reg
        generic map(instr_size => width, addr_length => size)
        port map(clk => clk, instruction => instr,
        regA      =>    regA        ,
        regB      =>    regB        ,
        regC      =>    regC        ,
        regD      =>    regD        ,
        aluOpp    =>    aluOpp      ,
        alu_opp_len => alu_opp_len,
        immediate =>    immediate   ,
        write_en  =>    write_en    ,
        msmux_sel =>    msmux_sel   ,
        alumux_sel=>    alumux_sel  ,
        ma_ms_sel =>    ma_ms_sel
        );

        
        
        
        --STAGE 2: Register file and execution register-- 
    stage_2: entity xil_defaultlib.stage_2
        port map(
                --Input--
            regA       => regA       ,
            regB       => regB       ,
            regC       => regC       ,
                                      
            regD       => regD       ,
            write_en   => write_en   ,
            ma_ms_sel  => ma_ms_sel  ,
                                      
            aluOppi    => aluOpp     ,
            alu_opp_leni => alu_opp_len,
            immediate  => immediate  ,
            msmux_seli => msmux_sel  ,
            alumux_seli=> alumux_sel ,

            data_wb    =>  data_wb,

            clk        => clk  ,
                --Output--
            dataA       => dataA      ,
            dataB       => dataB      ,
            dataC       => dataC      ,
            aluOppo     => aluOppo    ,
            alu_opp_leno => alu_opp_leno,
            msmux_selo  => msmux_selo ,
            alumux_selo => alumux_selo
        );
        
        --STAGE 3: Execution and write back--
    stage_3: entity xil_defaultlib.stage_3
        port map(
                 --Input--
            dataA       => dataA      ,
            dataB       => dataB      ,
            dataC       => dataC      ,
            aluOpp      => aluOppo    ,
            alu_opp_len => alu_opp_leno,
            msmux_sel   => msmux_selo ,
            alumux_sel  => alumux_selo, 
                        
            clk         => clk,
                --Output--
            result => data_wb
        );
end structural;
