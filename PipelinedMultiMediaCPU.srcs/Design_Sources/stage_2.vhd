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
            --Inputs from IF/ID Register--
        inst_type   : in std_logic_vector(1 downto 0);  --instruction type
        li_pos_i    : in std_logic_vector(1 downto 0);  --load immediate position
        immediate_i : in std_logic_vector(15 downto 0); --immediate to be loaded
        reg_d_i     : in std_logic_vector(4 downto 0);  --address for destination register
        mult_opp    : in std_logic_vector(1 downto 0);  --multiply opperation code
        reg_c       : in std_logic_vector(4 downto 0);  --address of rs3
        reg_b       : in std_logic_vector(4 downto 0);  --address of rs2
        reg_a       : in std_logic_vector(4 downto 0);  --address of rs1
            --Inputs from WB Register--
        data_wb     : in std_logic_vector(63 downto 0); --data to be saved to register file
        wrt_en_wb   : in std_logic;                     --write enable for register file
        reg_wrt_wb  : in std_logic_vector(4 downto 0);  --address for destination register
            --Outputs--
        data_a      : out std_logic_vector(63 downto 0);--
        data_b      : out std_logic_vector(63 downto 0);
        alu_opp     : out std_logic_vector(2 downto 0);--ALU Oppcode. Incicates function
        opp_len     : out std_logic_vector(1 downto 0);
        sgn_sat     : out std_logic;
        rslt_sel    : out std_logic_vector(2 downto 0);
        wrt_en      : out std_logic;
        
        immediate   : out std_logic_vector(15 downto 0);
        reg_d       : out std_logic_vector(4 downto 0);
        li_pos      : out std_logic_vector(1 downto 0)
    );
end stage_2;

architecture structural of stage_2 is
--into fowarding unit--
signal reg_a_data     : std_logic_vector(63 downto 0);
signal reg_b_data     : std_logic_vector(63 downto 0);
signal reg_c_data     : std_logic_vector(63 downto 0);
--out of fowarding unit--
signal data_b_fwrd    : std_logic_vector(63 downto 0);
signal data_c_fwrd    : std_logic_vector(63 downto 0);
--product of b and c--
signal product_bc     : std_logic_vector(63 downto 0);
begin
    --Register File--
	register_file: entity xil_defaultlib.register_file
        generic map(size => 5, width => 64)
        port map(
                --Input--
            reg_a    => reg_a,
            reg_b    => reg_b,
            reg_c    => reg_c,
            reg_wrt  => reg_wrt_wb,
            data_wrt => data_wb,
            wrt_en   => wrt_en_wb,
                --Output--
            data_a   => reg_a_data,
            data_b   => reg_b_data,
            data_c   => reg_c_data
        );
    
    --Fowarding Unit--
    fwrding_unit: process(reg_a, reg_b, reg_c, reg_wrt_wb, reg_a_data, reg_b_data, reg_c_data, data_wb)
    begin
        --data_a--
        if (reg_a = reg_wrt_wb) then
            data_a <= data_wb;
        else
            data_a <= reg_a_data;
        end if;
        --data_b--
        if (reg_b = reg_wrt_wb) then
            data_b_fwrd <= data_wb;
        else
            data_b_fwrd <= reg_b_data;
        end if;
        --data_c--
        if (reg_c = reg_wrt_wb) then
            data_c_fwrd <= data_wb;
        else
            data_c_fwrd <= reg_c_data;
        end if;
    end process;
    
    --ALU Opp Decoder--
    alu_opp_decode: process(inst_type, reg_c, mult_opp)
    begin
        --R3 Instruction Type--
        if (inst_type = "00") then
            if ( (reg_c(3 downto 0) = "1000") or (reg_c(3 downto 0) = "1010") or (reg_c(3 downto 0) = "1100") ) then
                alu_opp <= "001";   --SUM--
            elsif (reg_c(3 downto 0) = "0010") then
                alu_opp <= "010";   --AND--
            elsif (reg_c(3 downto 0) = "0011") then
                alu_opp <= "011";   --OR--
            elsif ( (reg_c(3 downto 0) = "1001") or (reg_c(3 downto 0) = "1011") or (reg_c(3 downto 0) = "1101") ) then
                alu_opp <= "101";   --SUB--
            else
                alu_opp <= "000";   --NOP--
            end if;
        --R4 Instruction Type--
        elsif (inst_type = "01") then
            if ( (mult_opp = "00") or (mult_opp = "01") ) then
                alu_opp <= "001";    --SUM--
            else
                alu_opp <= "101";    --SUB--
            end if;
        --R1 Instruction Type--
        else
            alu_opp <= "000";       --NOP--
        end if;
    end process;
    
    --Opp Length Decoder--
    opp_len_decode: process(inst_type, reg_c)
    begin
        --R3 Instruction Type--
        if (inst_type = "00") then
            if ( (reg_c(3 downto 0) = "0001") or (reg_c(3 downto 0) = "0101") or
                 (reg_c(3 downto 0) = "1000") or (reg_c(3 downto 0) = "1001") ) then
                opp_len <= "01";    --32 bit opperation
            elsif ( (reg_c(3 downto 0) = "0010") or (reg_c(3 downto 0) = "0110") or
                    (reg_c(3 downto 0) = "0011") or (reg_c(3 downto 0) = "0000") ) then
                opp_len <= "00";    --64 bit opperation
            elsif (reg_c(3 downto 0) = "1111") then
                opp_len <= "11";    --8 bit opperation
            else
                opp_len <= "10";    --16 bit opperation
            end if;
        --R4 Instruction Type--
        elsif (inst_type = "01") then
            opp_len <= "01";        --32 bit opperation
        --R1 Instruction Type--
        else
            opp_len <= "00";       --64 bit opperation
        end if;
    end process;
    
    --Write Enable Decoder--
    wrt_en_decode: process(inst_type, reg_c)
    begin
        --R3 Instruction Type--
        if (inst_type = "00") then
            if (reg_c = "00000") then
                wrt_en <= '0';    --only nop
            else
                wrt_en <= '1';
            end if;
        --R1 & R4 Instruction Type--
        else
            wrt_en <= '1';
        end if;
    end process;
    
    --Signed/Saturated Opperation Decoder--
    sgn_sat_decode: process(inst_type, reg_c)
    begin
        --R4 Instruction Type--
        if (inst_type = "01") then
            sgn_sat <= '1';
        --R3 Instruction Type--
        elsif (inst_type = "00") then
            if (reg_c(3 downto 0) = "1100") or (reg_c(3 downto 0) = "1101") then
                sgn_sat <= '1';
             else
                sgn_sat <= '0';
            end if;
        --R1 Instruction Type--
        else
            sgn_sat <= '0';
        end if;
    end process;
    
    --Result Select Decoder--
    rslt_sel_decode: process(inst_type, reg_c)
    begin
        --R4 Instruction Type--
        if (inst_type = "01") then
            rslt_sel <= "000";
        --R3 Instruction Type--
        elsif (inst_type = "00") then
            if ( (reg_c(3 downto 0) = "0110") or
                 (reg_c(3 downto 0) = "0111") then
                rslt_sel <= "010";  --shift or rotate
            elsif (reg_c(3 downto 0) = "1110") then
                rslt_sel <= "001";  --multiply
            elsif (reg_c(3 downto 0) = "0001") then
                rslt_sel <= "011";  --broadcast
            elsif (reg_c(3 downto 0) = "0100") then
                rslt_sel <= "100";  --hamming
            elsif (reg_c(3 downto 0) = "0101") then
                rslt_sel <= "101";  --leading zeroes
            else
                rslt_sel <= "000";  --alu
            end if;
        --R1 Instruction Type--
        else
            rslt_sel <= "110";
        end if;
    end process;
    --Data B * Data C--
    
    --Choose B*C or just B--
    b_output_calc: process(data_b_fwrd, product_bc)
    begin
        if (inst_type = "01") then
            data_b <= product_bc;
        else
            data_b <= data_b_fwrd;
        end if;
    end process;
end structural;
