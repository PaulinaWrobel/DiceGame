library ieee;
use ieee.std_logic_1164.all;

entity GameTest is
port(
	Roll: in std_logic;
	Win: in std_logic;
	Lose: in std_logic;
	Clk: out std_logic;
	Reset: out std_logic;
	Rb: out std_logic;
	Sum: out std_logic_vector(4 downto 0)
);
end entity GameTest;

architecture behav of GameTest is
	type state_type is (SRB, SSUM, SCHECK, SRESET, SWAIT);
	signal state: state_type;
	signal ClkI: std_logic := '0';
	signal SumI: std_logic_vector(4 downto 0) := "00000";

	type array_type is array (12 downto 0) of std_logic_vector(4 downto 0);
	signal SumArray: array_type := ("00100", "00101", "00100", "00101", "00111", "00100", "00110", "00110", "01100", "00011", "00010", "01011", "00111");
	signal n: integer range 0 to 12;

begin

ClkIGen: ClkI <= not ClkI after 10 ns;

Clk <= ClkI;
Sum <= SumI;

TestState: process (ClkI)
begin
	if ClkI = '1' and ClkI'event then
		case state is
			when SRB =>
				if Roll = '1' then
					state <= SSUM;
				end if;
			when SCHECK =>
				state <= SRB;
				if Win = '1' or Lose = '1' then
					state <= SRESET;
				end if;
			when SSUM =>
				if Roll = '0' then
					state <= SWAIT;
				end if;
			when SWAIT =>
				state <= SCHECK;
			when SRESET =>
				state <= SRB;
			when others =>
				state <= SRESET;
		end case;
	end if;
end process TestState;

TestOutput: process (state)
begin
	case state is
		when SRB =>
			Reset <= '0';
			Rb <= '1';
			SumI <= SumI;
			n <= n;
		when SWAIT =>
			Reset <= '0';
			Rb <= '0';
			SumI <= SumI;
			n <= n;
		when SCHECK =>
			Reset <= '0';
			Rb <= '0';
			SumI <= SumI;
			n <= n;
		when SSUM =>
			Reset <= '0';
			Rb <= '0';
			SumI <= SumArray(n);
			n <= n + 1;
		when SRESET =>
			Reset <= '1';
			Rb <= '0';
			SumI <= SumI;
			n <= n;
		when others =>
			Reset <= '1';
			Rb <= '0';
			SumI <= SumI;
			n <= n;
	end case;
end process TestOutput;


end architecture behav;
