library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
port(
	clk: in std_logic;
	start: in std_logic;
	number: out std_logic_vector(3 downto 0)
);
end entity counter;

architecture behav of counter is
	signal number_i: std_logic_vector(3 downto 0) := "0000";
begin

count: process (clk)
begin
	if (clk'event and clk='1' and start='1') then
		number_i <= std_logic_vector(unsigned(number_i) + 1);
		if (number_i="0110") then
			number_i <= "0000";
		end if;
	end if;
end process count;

number <= number_i;

end architecture behav;
