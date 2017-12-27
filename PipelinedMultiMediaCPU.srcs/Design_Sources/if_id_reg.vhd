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
        inst_type   : out std_logic_vector(1 downto 0);  --format of instruction        
        li_pos      : out std_logic_vector(1 downto 0);  --position of 16 bit immediate 
        immediate   : out std_logic_vector(15 downto 0); --16-bit immediate for li      
        reg_d       : out std_logic_vector(4 downto 0);  --address for rd               
        mult_opp    : out std_logic_vector(1 downto 0);  --mult. sub/add opp             
        reg_c       : out std_logic_vector(4 downto 0);  --address for rs3              
        reg_b       : out std_logic_vector(4 downto 0);  --address for rs2              
        reg_a       : out std_logic_vector(4 downto 0)   --address for rs1              
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
end behavioral;
