----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 03:16:30 AM
-- Design Name: 
-- Module Name: if_id_reg - behavioral
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
use IEEE.STD_LOGIC_1164.all;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity if_id_reg is
	port(
            --Input--
        clk         : in std_logic;	                    --system clock
        inst_type_i : in std_logic_vector(1 downto 0);  --format of instruction
        li_pos_i    : in std_logic_vector(1 downto 0);  --position of 16 bit immediate
        immediate_i : in std_logic_vector(15 downto 0); --16-bit immediate for li
        reg_d_i     : in std_logic_vector(4 downto 0);  --address for rd
        mult_opp_i  : in std_logic_vector(1 downto 0);  --mult. sub/add opp
        reg_c_i     : in std_logic_vector(4 downto 0);  --address for rs3
        reg_b_i     : in std_logic_vector(4 downto 0);  --address for rs2  
        reg_a_i     : in std_logic_vector(4 downto 0);  --address for rs1
            --Output--
        inst_type   : out std_logic_vector(1 downto 0);  --address for rs1
        li_pos      : out std_logic_vector(1 downto 0);  --address for rs2
        immediate   : out std_logic_vector(15 downto 0); --address for rs3
        reg_d       : out std_logic_vector(4 downto 0);  --address for destination register
        mult_opp    : out std_logic_vector(1 downto 0);  --ALU Oppcode. Incicates function	 
        reg_c       : out std_logic_vector(4 downto 0);  --16-bit immediate for li
        reg_b       : out std_logic_vector(4 downto 0);  --write enable control signal
        reg_a       : out std_logic_vector(4 downto 0)   --mux to alu second param
	);						 						
end if_id_reg;

architecture behavioral of if_id_reg is
begin
    reg_proc: process (clk)
    begin
        if (rising_edge(clk)) then
            inst_type <= inst_type_i;
            li_pos    <= li_pos_i;
            immediate <= immediate_i;
            reg_d     <= reg_d_i;
            mult_opp  <= mult_opp_i;
            reg_c     <= reg_c_i;
            reg_b     <= reg_b_i;
            reg_a     <= reg_a_i;
        end if;
    end process;

	aluOppCalc: process(clk)
	begin      --decode alu opp--
        if (rising_edge(clk)) then
            if (instruction(23) = '1') then
                aluOpp <= "001";    --SUM--
                alu_opp_len <= "00";
            elsif (instruction(22) = '1') then
                alu_opp_len <= "01";
                if (instruction(21) = '0') then
                    aluOpp <= "001";    --SUM--
                else
                    aluOpp <= "101";    --SUB--
                end if;
            else
                if (instruction(18 downto 15) = "0000") then
                    aluOpp <= "000";    --NOP--
                    alu_opp_len <= "00";
                elsif (instruction(18 downto 15) = "1000") then  --packed 32 unsigned
                    aluOpp <= "001";    --SUM--
                    alu_opp_len <= "01";
                elsif (instruction(18 downto 15) = "1010") then  --packed 16 unsigned
                    aluOpp <= "001";    --SUM--
                    alu_opp_len <= "10";
                elsif (instruction(18 downto 15) = "1100") then   --packed 16 signed sat
                    aluOpp <= "001";    --SUM--
                    alu_opp_len <= "10";
                elsif (instruction(18 downto 15) = "0010") then
                    aluOpp <= "010";    --AND--
                    alu_opp_len <= "00";
                elsif (instruction(18 downto 15) = "0011") then
                    aluOpp <= "011";    --OR--
                    alu_opp_len <= "00";
                elsif (instruction(18 downto 15) = "1001") then  --packed 32 unsigned
                    aluOpp <= "101";    --SUB--
                    alu_opp_len <= "01";
                elsif (instruction(18 downto 15) = "1011") then  --pakced 16 unsigned
                    aluOpp <= "101";    --SUB--
                    alu_opp_len <= "10";  
                elsif (instruction(18 downto 15) = "1101") then   --packed 16 signed sat
                    aluOpp <= "101";    --SUB--
                    alu_opp_len <= "10";
                else
                    aluOpp <= "000";
                    alu_opp_len <= "00";
                end if;
            end if;
        end if;
	end process;
    
    writeEnCalc: process(clk)
    begin
        if (rising_edge(clk)) then
            if (instruction(23 downto 22) = "00") then
                if (instruction(18 downto 15) = "0000") then
                    write_en <= '0';        --only nop--
                else
                    write_en <= '1';
                end if;
            else
                write_en <= '1';
            end if;
        end if;
    end process;

    msmuxSelCalc: process(clk)
    begin
        if (rising_edge(clk)) then
            if (instruction(23) = '1') then
                msmux_sel <= "00";
            elsif (instruction(23 downto 22) = "01") then
                msmux_sel <= "10";
            else
                msmux_sel <= "01";
             end if;
        end if;
    end process;
    
    aluMuxSelCalc: process(clk)
    begin
        if (rising_edge(clk)) then
            if (instruction(23 downto 22) = "00") then
                if (instruction(18 downto 15) = "1110") then
                    alumux_sel <= "001";    --mpy--
                elsif (
                        (instruction(18 downto 15) = "0110") or
                        (instruction(18 downto 15) = "0111")
                      ) then
                    alumux_sel <= "010";    --shift and rotate--
                elsif (instruction(18 downto 15) = "0001") then
                    alumux_sel <= "011";     --broadcast--
                elsif (instruction(18 downto 15) = "0100") then
                    alumux_sel <= "100";   --hamming weight--
                elsif (instruction(18 downto 15) = "0101") then
                    alumux_sel <= "101";    --leading zeros--
                else
                    alumux_sel <= "000";
                end if;
            else
                alumux_sel <= "000";
             end if;
        end if;
    end process;
end behavioral;
