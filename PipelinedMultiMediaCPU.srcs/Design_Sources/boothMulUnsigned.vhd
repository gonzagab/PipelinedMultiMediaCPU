library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
entity boothMulSigned is port(
    a   : in std_logic_vector(15 downto 0);
    b   : in std_logic_vector(15 downto 0);
    m   : out std_logic_vector(31 downto 0));
end boothMulSigned;
 
architecture arch of boothMulSigned is
begin		   
	
	m <= std_logic_vector(unsigned(a)*unsigned(b));
end arch;