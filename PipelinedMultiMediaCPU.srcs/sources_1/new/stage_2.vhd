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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
        --for rd/ex reg
        regD        : in std_logic_vector(size - 1 downto 0); --address for destination register
        aluOppi     : in std_logic_vector(2 downto 0);        --ALU Oppcode. Incicates function     
        immediate   : in std_logic_vector(15 downto 0);       --16-bit immediate for li
        write_en    : in std_logic;                           --write enable control signal
        msmux_sel   : in std_logic_vector(1 downto 0);        --mux to alu second param
        alumux_seli : in std_logic_vector(2 downto 0);        --mux for stage 3 output
        ma_ms_sel   : in std_logic;                           --multiple add/sub high or low.
        data_wb     : in std_logic_vector(63 downto 0);
            --Outputs--
        dataA       : out std_logic_vector(63 downto 0);
        dataB       : out std_logic_vector(63 downto 0);
        aluOppo     : out std_logic_vector(2 downto 0);        --ALU Oppcode. Incicates function
        alumux_selo : in std_logic_vector(2 downto 0)          --mux for stage 3 output
);
end stage_2;

architecture structural of stage_2 is

begin


end structural;
