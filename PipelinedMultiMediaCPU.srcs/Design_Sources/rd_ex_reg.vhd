----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2017 03:16:30 AM
-- Design Name: 
-- Module Name: rd_ex_reg - behavioral
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

entity id_ex_reg is
	port(
            --Inputs--
        data_a_i    : in std_logic_vector(63 downto 0); --Data A
        data_b_i    : in std_logic_vector(63 downto 0); --Data B
        alu_opp_i   : in std_logic_vector(2 downto 0);  --ALU Oppcode
        opp_len_i   : in std_logic_vector(1 downto 0);
        sgn_sat_i   : in std_logic;
        wrt_en_i    : in std_logic;
        reg_d_i     : in std_logic_vector(4 downto 0);
        immediate_i : in std_logic_vector(15 downto 0);
        li_pos_i    : in std_logic_vector(1 downto 0);  --load immediate position
        rslt_sel_i  : in std_logic_vector(2 downto 0);
        clk         : in std_logic;					 --System clock
            --Outputs--
        data_a      : out std_logic_vector(63 downto 0); --Data A
        data_b      : out std_logic_vector(63 downto 0); --Data B
        alu_opp     : out std_logic_vector(2 downto 0);  --ALU Oppcode
        opp_len     : out std_logic_vector(1 downto 0);
        sgn_sat     : out std_logic;
        wrt_en      : out std_logic;
        reg_d       : out std_logic_vector(4 downto 0);
        immediate   : out std_logic_vector(15 downto 0);
        li_pos      : out std_logic_vector(1 downto 0);  --load immediate position
        rslt_sel    : out std_logic_vector(2 downto 0)
    );
end id_ex_reg;

architecture behavioral of id_ex_reg is
begin
	reg_proc: process(clk)
	begin
		if (rising_edge(clk)) then
			data_a    <= data_a_i;
			data_b    <= data_b_i;
			alu_opp   <= alu_opp_i;
			opp_len   <= opp_len_i;
			sgn_sat   <= sgn_sat_i;
			wrt_en    <= wrt_en_i;
			reg_d     <= reg_d_i;
			immediate <= immediate_i;
			rslt_sel  <= rslt_sel_i;
		end if;
	end process;
end behavioral;
