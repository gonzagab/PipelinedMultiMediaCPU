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
    generic(
        instr_size  : integer := 24;
        addr_length : integer := 5
    );
	port(
            --Input--
        instruction : in std_logic_vector(instr_size - 1 downto 0);
        clk         : in std_logic;	--system clock
            --Output--
        regA        : out std_logic_vector(addr_length - 1 downto 0); --address for rs1; regA
        regB        : out std_logic_vector(addr_length - 1 downto 0); --address for rs2; regB
        regC        : out std_logic_vector(addr_length - 1 downto 0); --address for rs3; regC
        regD        : out std_logic_vector(addr_length - 1 downto 0); --address for destination register
        aluOpp      : out std_logic_vector(2 downto 0);               --ALU Oppcode. Incicates function	 
        immediate   : out std_logic_vector(15 downto 0);              --16-bit immediate for li
        write_en    : out std_logic;                                  --write enable control signal
        msmux_sel   : out std_logic_vector(1 downto 0);               --mux to alu second param
        alumux_sel  : out std_logic_vector(2 downto 0);               --mux for stage 3 output
        ma_ms_sel   : out std_logic;                                  --multiple add/sub high or low.
        alu_opp_len : out std_logic_vector(1 downto 0) 
	);						 						
end if_id_reg;

architecture behavioral of if_id_reg is
begin
    regAddrCalc: process(clk)
    begin
        if(rising_edge(clk))then
                --output all known data--
            regD 	  <= instruction(4 downto 0);
			regA      <= instruction(9 downto 5);
			regB      <= instruction(14 downto 10);
            regC 	  <= instruction(19 downto 15);
			immediate <= instruction(20 downto 5);
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
