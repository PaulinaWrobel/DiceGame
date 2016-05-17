library IEEE;
use IEEE.std_logic_1164.all;

entity DFF is
  port(d: in std_logic;
    clk: in std_logic;
    rst: in std_logic;
	ce: in std_logic;
    q: out std_logic
  );
end DFF;

architecture behav of DFF is
begin
    ff: process(clk, rst)
    begin
	if (rst='0') then
		q <= '0';
	elsif (clk'event and clk='1') then
		if ce='1' then
			q <= d;
		end if;
	end if;
    end process;
end behav;
