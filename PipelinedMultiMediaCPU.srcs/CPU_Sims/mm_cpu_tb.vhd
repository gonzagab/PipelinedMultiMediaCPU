library IEEE;
use IEEE.STD_LOGIC_1164.all;
--Xilinx Default Library--
library XIL_DEFAULTLIB;

entity mm_cpu_tb is
end mm_cpu_tb;

architecture testbench of mm_cpu_tb is
--Input Signals--
signal clk: 		std_logic;
signal rst_bar: 	std_logic;
signal write_inst: 	std_logic;
signal instruction: std_logic_vector(23 downto 0);
--Output Signals--
--Instruction Memory--
type MEM is array(0 to 15) of std_logic_vector(23 downto 0);
signal instruction_buffer : MEM :=(

"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"000000111000100001000011",
"000000111000100001000011",
"000000111000100001000011",
"000000111000100001000011"
);
signal program_buffer: MEM :=(
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"111000000000000000100010",
"000000111000100001000011",
"000000111000100001000011",
"000000111000100001000011",
"000000111000100001000011",
"000000111000100001000011"


);
--Clock Period--
constant clk_period : time := 1 us;
--End Simulation signal--
signal END_SIM : boolean := false;
begin
	--Unit Under Testing set up--
	uut: entity xil_defaultlib.mm_cpu
		port map(
		  clk => clk,
		  rst_bar => rst_bar,
		  write => write_inst,
		  instruction => instruction
      );
	--System Clock--
	clock: process
	begin
		clk <= '1';
		wait for clk_period/2;
		loop
			clk <= not clk;
			wait for clk_period/2;
			exit when END_SIM = true;
		end loop;
		wait;
	end process;
	--Reset Signal--
	rst_bar <= '0', '1' after 1.5*clk_period;
	--Stimulus Process; Drives the whole TB--
	tb: process
	begin
		--Load instructions into memory--
		write_inst <= '0'; 		--clear write signal
		wait for 1.5*clk_period;--wait for rst_bar
		write_inst <= '1';		--set to write
		--Output instructions form preloaded instruction buffer
		for i in 0 to 15 loop
			instruction <= instruction_buffer(i);
			wait for clk_period;
		end loop;
		write_inst <= '0';	--stop writing instructions
		--rst_bar <= '0', '1' after clk_period;		-- make sure to start at first instruction
		wait for 24*clk_period;
		write_inst <= '1';		--set to write
		--Output instructions form preloaded instruction buffer
		for i in 0 to 15 loop
			instruction <= program_buffer(i);
			wait for clk_period;
		end loop;
		write_inst <= '0';	--stop writing instructions
		wait for 24*clk_period;
		--End of Simulation--
		END_SIM <= true;
		wait;
	end process;
end testbench;
