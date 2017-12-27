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
--STAGE 1 --> IF/ID Register--
signal inst_type_if   : std_logic_vector(1 downto 0);  --format of instruction
signal li_pos_if      : std_logic_vector(1 downto 0);  --position of 16 bit immediate 
signal immediate_if   : std_logic_vector(15 downto 0); --16-bit immediate for li      
signal reg_d_if       : std_logic_vector(4 downto 0);  --address for rd               
signal mult_opp_if    : std_logic_vector(1 downto 0);  --mult. sub/add opp               
signal reg_c_if       : std_logic_vector(4 downto 0);  --address for rs3              
signal reg_b_if       : std_logic_vector(4 downto 0);  --address for rs2              
signal reg_a_if       : std_logic_vector(4 downto 0);   --address for rs1              
-- IF/ID Register --> STAGE 2 --
signal inst_type_id   : std_logic_vector(1 downto 0);  --format of instruction
signal li_pos_id      : std_logic_vector(1 downto 0);  --position of 16 bit immediate 
signal immediate_id_i : std_logic_vector(15 downto 0); --16-bit immediate for li      
signal reg_d_id_i     : std_logic_vector(4 downto 0);  --address for rd               
signal mult_opp_id    : std_logic_vector(1 downto 0);  --mult. sub/add opp               
signal reg_c_id       : std_logic_vector(4 downto 0);  --address for rs3              
signal reg_b_id       : std_logic_vector(4 downto 0);  --address for rs2              
signal reg_a_id       : std_logic_vector(4 downto 0);   --address for rs1
--STAGE 2 --> ID/EX Register--
signal data_a_id      : std_logic_vector(63 downto 0); --Data A
signal data_b_id      : std_logic_vector(63 downto 0); --Data B
signal alu_opp_id     : std_logic_vector(2 downto 0);  --ALU Oppcode
signal opp_len_id     : std_logic_vector(1 downto 0);
signal sgn_sat_id     : std_logic;
signal wrt_en_id      : std_logic;
signal reg_d_id_o     : std_logic_vector(4 downto 0);
signal immediate_id_o : std_logic_vector(15 downto 0);
signal li_pos_id_o    :  std_logic_vector(1 downto 0);  --load immediate position
signal rslt_sel_id    : std_logic_vector(2 downto 0);
--ID/EX Register --> STAGE 3--
signal data_a_ex      : std_logic_vector(63 downto 0); --Data A
signal data_b_ex      : std_logic_vector(63 downto 0); --Data B
signal alu_opp_ex     : std_logic_vector(2 downto 0);  --ALU Oppcode
signal opp_len_ex     : std_logic_vector(1 downto 0);
signal sgn_sat_ex     : std_logic;
signal wrt_en_ex      : std_logic;
signal reg_d_ex       : std_logic_vector(4 downto 0);
signal immediate_ex   : std_logic_vector(15 downto 0);
signal li_pos_ex      :  std_logic_vector(1 downto 0);  --load immediate position
signal rslt_sel_ex    : std_logic_vector(2 downto 0);
--STAGE 3 --> WB Register--
signal data_wb     : std_logic_vector(63 downto 0);
signal wrt_en_wb   : std_logic;
signal reg_wrt_wb  : std_logic_vector(4 downto 0);
begin
    --STAGE 1: Instruction Fetch and Partition--
    stage_1: entity xil_defaultlib.stage_1
        port map(
                --Inputs--
            clk         => clk,
            rst_bar     => rst_bar,
            write       => write,
            instruction => instruction,
                --Outputs--
            inst_type => inst_type_if,
            li_pos    => li_pos_if,
            immediate => immediate_if,
            reg_d     => reg_d_if,
            mult_opp  => mult_opp_if,
            reg_c     => reg_c_if,
            reg_b     => reg_b_if,
            reg_a     => reg_a_if
        );
              
    --IF/ID Register--
    id: entity xil_defaultlib.if_id_reg
        port map(
            clk         => clk,
            inst_type_i => inst_type_if,
            li_pos_i    => li_pos_if,
            immediate_i => immediate_if,
            reg_d_i     => reg_d_if,
            mult_opp_i  => mult_opp_if,
            reg_c_i     => reg_c_if,
            reg_b_i     => reg_b_if,
            reg_a_i     => reg_a_if,
                --Outputs--
            inst_type => inst_type_id  , 
            li_pos    => li_pos_id     , 
            immediate => immediate_id_i, 
            reg_d     => reg_d_id_i    , 
            mult_opp  => mult_opp_id   , 
            reg_c     => reg_c_id      , 
            reg_b     => reg_b_id      , 
            reg_a     => reg_a_id   
        );
        
    --STAGE 2: Instruction Decode and Register File-- 
    stage_2: entity xil_defaultlib.stage_2
        port map(
            inst_type   => inst_type_id,
            li_pos_i    => li_pos_id,
            immediate_i => immediate_id_i,
            reg_d_i     => reg_d_id_i,
            mult_opp    => mult_opp_id,
            reg_c       => reg_c_id,
            reg_b       => reg_b_id,
            reg_a       => reg_a_id,
                --Inputs
            data_wb     
            wrt_en_wb   
            reg_wrt_wb  
                --Output
            data_a      => data_a_id,
            data_b      => data_b_id,
            alu_opp     => alu_opp_id,
            opp_len     => opp_len_id,
            sgn_sat     => sgn_sat_id,
            rslt_sel    => rslt_sel_id,
            wrt_en      => wrt_en_id,
            immediate   => immediate_id_o,
            reg_d       => reg_d_id_o,
            li_pos      => li_pos_id_o
        );
    --ID/EX Register--
    rd_ex_reg: entity xil_defaultlib.id_ex_reg
        port map(
                --Inputs
            data_a_i      => data_a_id,     
            data_b_i      => data_b_id,     
            alu_opp_i     => alu_opp_id,    
            opp_len_i     => opp_len_id,    
            sgn_sat_i     => sgn_sat_id,    
            wrt_en_i      => wrt_en_id,
            reg_d_i       => reg_d_id_o,
            immediate_i   => immediate_id_o,
            li_pos_i      => li_pos_id_o,
            rslt_sel_i    => rslt_sel_id,
            clk           => clk,    
                --Output
            data_a      => data_a_ex,
            data_b      => data_b_ex,
            alu_opp     => alu_opp_ex,
            opp_len     => opp_len_ex,
            sgn_sat     => sgn_sat_ex,
            wrt_en      => wrt_en_ex,
            reg_d       => reg_d_ex,
            immediate   => immediate_ex,
            li_pos      => li_pos_ex,
            rslt_sel    => rslt_sel_ex
        );    
        
    --STAGE 3: Execution and Write Back--
    stage_3: entity xil_defaultlib.stage_3
        port map(
            --Inputs--
            data_a     => data_a_ex,
            data_b     => data_b_ex,
            alu_opp    => alu_opp_ex,
            opp_len    => opp_len_ex,
            sgn_sat    => sgn_sat_ex,
            wrt_en     => wrt_en_ex,
            reg_d      => reg_d_ex,
            immediate  => immediate_ex,
            li_pos_i   => li_pos_ex,
            rslt_sel   => rslt_sel_ex,
            --Output-- 
            result     => data_wb,
            wrt_en_wb  => wrt_en_wb,
            reg_wrt_wb => reg_wrt_wb
        );
end structural;
