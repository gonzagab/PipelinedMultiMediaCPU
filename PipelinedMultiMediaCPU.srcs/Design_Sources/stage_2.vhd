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
            --Inputs from Stage 1--
        inst_type   : in std_logic_vector(1 downto 0);  --address for rs1
        li_pos      : in std_logic_vector(1 downto 0);  --address for rs2
        immediate   : in std_logic_vector(15 downto 0); --address for rs3
        reg_d       : in std_logic_vector(4 downto 0);  --address for destination register
        mult_opp    : in std_logic_vector(1 downto 0);  --ALU Oppcode. Incicates function     
        reg_c       : in std_logic_vector(4 downto 0);  --16-bit immediate for li
        reg_b       : in std_logic_vector(4 downto 0);  --write enable control signal
        reg_a       : in std_logic_vector(4 downto 0)   --mux to alu second param
            --Inputs from Stage 3--
        data_wb     : in std_logic_vector(63 downto 0); --data to be saved to register file
        wrt_en      : in std_logic;                     --write enable for register file
        reg_wrt     : in std_logic_vector(4 downto 0);  --address for destination register
            --Outputs--
        dataA       : out std_logic_vector(63 downto 0);
        dataB       : out std_logic_vector(63 downto 0);
        dataC       : out std_logic_vector(63 downto 0);
        aluOppo     : out std_logic_vector(2 downto 0);        --ALU Oppcode. Incicates function
        alu_opp_leno : out std_logic_vector(1 downto 0);
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
signal reg_a_data     : std_logic_vector(63 downto 0);
signal reg_b_data     : std_logic_vector(63 downto 0);
signal reg_c_data     : std_logic_vector(63 downto 0);
--out of fowarding unit--
signal data_a_out     : std_logic_vector(63 downto 0);
signal data_b_out     : std_logic_vector(63 downto 0);
signal data_c_out       : std_logic_vector(63 downto 0);
--final dataC signal after multiplying--
signal dataCOut     : std_logic_vector(63 downto 0);
begin
	register_file: entity xil_defaultlib.register_file
        generic map(size => 5, width => 64)
        port map(
                --Input--
            reg_a    => reg_a,
            reg_b    => reg_b,
            reg_c    => reg_c,
            reg_wrt  => reg_wrt,
            data_wrt => data_wb,
            wrt_en   => wrt_en, --allow for writing--
                --Output--
            data_a   => reg_a_data,
            data_b   => reg_b_data,
            data_c   => reg_c_data
        );

    fwrdingUnit: process(reg_a, reg_b, reg_c, reg_d, reg_a_data, reg_b_data, reg_c_data, data_wb)
    begin
        if (reg_a = reg_d) then
            data_a_out <= data_wb;
        else
            data_a_out <= reg_a_data;
        end if;
        if (reg_b = reg_d) then
            data_b_out <= data_wb;
        else
            data_b_out <= reg_b_data;
        end if;
        if (reg_c = reg_d) then
            dataCO <= data_wb;
        else
            dataCO <= reg_c_data;
        end if;
    end process;
    
    mpyBC: process(data_b_out, data_c_out, internMaMs_sel)
    begin
    end process;

    rd_ex_reg: entity xil_defaultlib.rd_ex_reg
    port map(
        dataAi      => data_a_out,
        dataBi      => data_b_out,
        dataCi      => dataCOut,
        aluOppi     => aluOppi,
        alu_opp_leni => alu_opp_leni,
        msmux_seli  => msmux_seli,
        alumux_seli => alumux_seli,
        clk         => clk,
            --Output--
        dataAo      => dataA,
        dataBo      => dataB,
        data_c_out      => dataC,
        aluOppo     => aluOppo,
        alu_opp_leno => alu_opp_leno,
        msmux_selo  => msmux_selo,
        alumux_selo => alumux_selo
    );
    
    intern_reg: process(clk)
    begin
        if (rising_edge(clk)) then
            internRegD     <= reg_d;
            internWrite_en <= write_en;
            internMaMs_sel <= ma_ms_sel;
        end if;
    end process;
end structural;
