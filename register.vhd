library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is
port(
	S0: in std_logic;
	S1: in std_logic;
	P: in std_logic_vector(3 downto 0);
	DSR: in std_logic;
	DSL: in std_logic;
	CP: in std_logic;
	MR_L: in std_logic;
	Q: out std_logic_vector(3 downto 0)
);
end entity shift_reg;

architecture behav of shift_reg is
	signal Q_i: std_logic_vector(3 downto 0);

begin
	proc1: process (CP,MR_L)
	begin
		if MR_L='0' then
			Q_i <= "0000";
		elsif CP='1' and CP'event then
			if S1='0' and S0='0' then
			elsif S1='1' and S0='0' then
				Q_i <= Q_i(2 downto 0) & DSL;
			elsif S1='0' and S0='1' then
				Q_i <= DSR & Q_i(3 downto 1);
			elsif S1='1' and S0='1' then
				Q_i <= P;
			end if;
		end if;
	end process proc1;
	Q <= Q_i;
end architecture behav;
