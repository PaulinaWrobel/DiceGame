library ieee;
use ieee.std_logic_1164.all;

entity DG_ALL is
port(
	Clk: in std_logic;
	Reset: in std_logic;
	Rb: in std_logic;
	Win: out std_logic;
	Lose: out std_logic;
	sseg: out std_logic_vector(6 downto 0);
	an: out std_logic_vector(3 downto 0);
	dp: out std_logic
);
end entity DG_ALL;

architecture struct of DG_ALL is
	attribute LOC : string;
	attribute LOC of sseg : signal is "H14 J17 G14 D16 D17 F18 L18";
	attribute LOC of an : signal is "F17 H17 C18 F15";
	attribute LOC of dp : signal is "C17";
	attribute LOC of Clk : signal is "B8";
	attribute LOC of Reset : signal is "B18";
	attribute LOC of Rb : signal is "D18";
	attribute LOC of Win : signal is "J14";
	attribute LOC of Lose : signal is "J15";

	signal Roll, stop, Rb_stop: std_logic;
	signal Sum: std_logic_vector(4 downto 0);
	signal numberA: std_logic_vector(3 downto 0);
	signal numberB: std_logic_vector(3 downto 0);
	signal clk_1MHz, clk_1kHz, clk_10Hz, clk_A, clk_B: std_logic;
	signal Sum_display: std_logic_vector(3 downto 0);

begin

--Rb_stop <= not stop;
Rb_stop <= Rb and (not stop);

clk_gen: entity work.clk_gen
	port map(
		clk_in => Clk,
		clk_1MHz => clk_1MHz,
		clk_1kHz => clk_1kHz,
		clk_10Hz => clk_10Hz,
		clk_A => clk_A,
		clk_B => clk_B
	);

DG_NoSum: entity work.DG_NoSum
	port map(
		Clk => clk_10Hz,
		Reset => Reset,
		Rb => Rb_stop,
		Sum => Sum,
		Roll => Roll,
		Win => Win,
		Lose => Lose
	);

adder: entity work.serialAdder
	port map(
		start => Roll,
		clk => clk_1kHz,
		IN_A => numberA,
		IN_B => numberB,
		leds => Sum,
		stop => stop
	);

counterA: entity work.counter
	port map(
		clk => clk_A,
		start => Roll,
		number => numberA
	);

counterB: entity work.counter
	port map(
		clk => clk_B,
		start => Roll,
		number => numberB
	);

Sum_display <= "000" & Sum(4);
display: entity work.led4dp_driver
	port map(
		a => numberA,
		b => numberB,
		c => Sum_display,
		d => Sum(3 downto 0),
		dp_dcba => "0100",
		clk_in => clk_1kHz,
		sseg => sseg,
		an => an,
		dp => dp
	);

end architecture struct;
