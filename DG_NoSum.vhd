library ieee;
use ieee.std_logic_1164.all;

entity DG_NoSum is
port(
	Clk: in std_logic;
	Reset: in std_logic;
	Rb: in std_logic;
	Sum: in std_logic_vector(4 downto 0);
	Roll: out std_logic;
	Win: out std_logic;
	Lose: out std_logic
);
end entity DG_NoSum;

architecture behav of DG_NoSum is
	type state_type is (SINIT, SWIN, SLOSE, SROLL1, SCHECK1, SROLL2, SCHECK2, SIDLE, SWAIT1, SWAIT2);
	signal state: state_type;
	signal D7: std_logic;
	signal D711: std_logic;
	signal D2312: std_logic;
	signal Eq: std_logic;
	signal Sp: std_logic;

	signal SumReg: std_logic_vector(4 downto 0);

begin

PointRegister: process (Sp)
begin
	SumReg <= SumReg;
	if Sp = '1' and Sp'event then
		SumReg <= Sum;
	end if;
end process PointRegister;

Comparator:
	Eq <= '1' when SumReg = Sum else '0';

TestLogic: process (Sum)
begin
	D7 <= '0';
	D711 <= '0';
	D2312 <= '0';
	if Sum = "00111" then
		D7 <= '1';
	end if;
	if Sum = "00111" or Sum = "01011" then
		D711 <= '1';
	end if;
	if Sum = "00010" or Sum = "00011" or Sum = "01100" then
		D2312 <= '1';
	end if;
end process TestLogic;

ControlState: process (Clk)
begin
	if Clk = '1' and Clk'event then
		if Reset = '1' then
			state <= SINIT;
		else
			case state is
				when SINIT =>
					if Rb = '1' then
						state <= SROLL1;
					end if;
				when SWIN =>
				when SLOSE =>
				when SROLL1 =>
					if Rb = '0' then
						state <= SWAIT1;
					end if;
				when SWAIT1 =>
						state <= SCHECK1;
				when SCHECK1 =>
					if D711 = '1' then
						state <= SWIN;
					elsif D2312 = '1' then
						state <= SLOSE;
					else
						state <= SIDLE;
					end if;
				when SIDLE =>
					if Rb = '1' then
						state <= SROLL2;
					end if;
				when SROLL2 =>
					if Rb = '0' then
						state <= SWAIT2;
					end if;
				when SWAIT2 =>
					state <= SCHECK2;
				when SCHECK2 =>
					if Eq = '1' then
						state <= SWIN;
					elsif D7 = '1' then
						state <= SLOSE;
					else
						state <= SIDLE;
					end if;
				when others =>
					state <= SINIT;
			end case;
		end if;
	end if;
end process ControlState;

ControlOutput: process (state)
begin
	case state is
		when SINIT =>
			Win <= '0';
			Lose <= '0';
			Roll <= '0';
			Sp <= '0';
		when SWIN =>
			Win <= '1';
			Lose <= '0';
			Roll <= '0';
			Sp <= '0';
		when SLOSE =>
			Win <= '0';
			Lose <= '1';
			Roll <= '0';
			Sp <= '0';
		when SROLL1 =>
			Win <= '0';
			Lose <= '0';
			Roll <= '1';
			Sp <= '0';
		when SWAIT1 =>
			Win <= '0';
			Lose <= '0';
			Roll <= '0';
			Sp <= '0';
		when SCHECK1 =>
			Win <= '0';
			Lose <= '0';
			Roll <= '0';
			Sp <= '0';
		when SIDLE =>
			Win <= '0';
			Lose <= '0';
			Roll <= '0';
			Sp <= '1';
		when SROLL2 =>
			Win <= '0';
			Lose <= '0';
			Roll <= '1';
			Sp <= '0';
		when SWAIT2 =>
			Win <= '0';
			Lose <= '0';
			Roll <= '0';
			Sp <= '0';
		when SCHECK2 =>
			Win <= '0';
			Lose <= '0';
			Roll <= '0';
			Sp <= '0';
		when others =>
			Win <= '0';
			Lose <= '0';
			Roll <= '0';
			Sp <= '0';
	end case;

end process ControlOutput;

end architecture behav;
