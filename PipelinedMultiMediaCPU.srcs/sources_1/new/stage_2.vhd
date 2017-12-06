----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 05:37:22 AM
-- Design Name: 
-- Module Name: stage_2 - structural
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

entity stage_2 is
    generic(
        size  : integer := 5; --indicates the instr. buffer capacity(2^size)
        width : integer := 24 --buffer width. in bits
    );
    port(
            --Inputs--
        regA        : in std_logic_vector(size - 1 downto 0); --address for rs1; regA
        regB        : in std_logic_vector(size - 1 downto 0); --address for rs2; regB
        regC        : in std_logic_vector(size - 1 downto 0); --address for rs3; regC
        regD        : in std_logic_vector(size - 1 downto 0); --address for destination register
        write_en    : in std_logic;                           --write enable control signal
        data_wb     : in std_logic_vector(63 downto 0);       --data to be saved to register file
  
        ma_ms_sel   : in std_logic;                           --multiple add/sub high or low.
        
        immediate   : in std_logic_vector(15 downto 0);       --16-bit immediate for li      
        aluOppi     : in std_logic_vector(2 downto 0);        --ALU Oppcode. Incicates function
        msmux_seli  : in std_logic_vector(1 downto 0);        --mux to alu second param
        alumux_seli : in std_logic_vector(2 downto 0);        --mux for stage 3 output
        
        clk         : in std_logic;                           --system clock
            --Outputs--
        dataA       : out std_logic_vector(63 downto 0);
        dataB       : out std_logic_vector(63 downto 0);
        dataC       : out std_logic_vector(63 downto 0);
        aluOppo     : out std_logic_vector(2 downto 0);        --ALU Oppcode. Incicates function
        msmux_selo  : out std_logic_vector(1 downto 0);        --mux to alu second param
        alumux_selo : out std_logic_vector(2 downto 0)        --mux for stage 3 output
    );
end stage_2;

architecture structural of stage_2 is
--Internal FFs for Signals--
signal internRegD      : std_logic_vector(4 downto 0);
signal internWrite_en  : std_logic;
signal internMaMs_sel  : std_logic;
--into fowarding unit--
signal regAData     : std_logic_vector(63 downto 0);
signal regBData     : std_logic_vector(63 downto 0);
signal regCData     : std_logic_vector(63 downto 0);
--out of fowarding unit--
signal dataAOut     : std_logic_vector(63 downto 0);
signal dataBOut     : std_logic_vector(63 downto 0);
signal dataCO       : std_logic_vector(63 downto 0);
--final dataC signal after multiplying--
signal dataCOut     : std_logic_vector(63 downto 0);
begin
	register_file: entity xil_defaultlib.register_file
        generic map(size => 5, width => 64)
        port map(
                --Input--
            regA	 => regA,
            regB     => regB,
            regC     => regC,
            regWrt   => internRegD,     --address to write to--
            dataWrt  => data_wb,        --64 bit data to be written--
            write    => internWrite_en, --allow for writing--
                --Output--
            dataA    => regAData,
            dataB    => regBData,
            dataC    => regCData
        );

    fwrdingUnit: process(regA, regB, regC, regD, regAData, regBData, regCData, data_wb)
    begin
        if (regA = regD) then
            dataAOut <= data_wb;
        else
            dataAOut <= regAData;
        end if;
        if (regB = regD) then
            dataBOut <= data_wb;
        else
            dataBOut <= regBData;
        end if;
        if (regC = regD) then
            dataCO <= data_wb;
        else
            dataCO <= regCData;
        end if;
    end process;
    
    mpyBC: process(dataBOut, dataCO, internMaMs_sel)
    begin
    end process;

    rd_ex_reg: entity xil_defaultlib.rd_ex_reg
    port map(
        dataAi      => dataAOut,
        dataBi      => dataBOut,
        dataCi      => dataCOut,
        aluOppi     => aluOppi,
        msmux_seli  => msmux_seli,
        alumux_seli => alumux_seli,
        clk         => clk,
            --Output--
        dataAo      => dataA,
        dataBo      => dataB,
        dataCo      => dataC,
        aluOppo     => aluOppo,
        msmux_selo  => msmux_selo,
        alumux_selo => alumux_selo
    );
    
    intern_reg: process(clk)
    begin
        if (rising_edge(clk)) then
            internRegD     <= regD;
            internWrite_en <= write_en;
            internMaMs_sel <= ma_ms_sel;
        end if;
    end process;
end structural;
