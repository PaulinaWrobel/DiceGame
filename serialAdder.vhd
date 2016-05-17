library ieee;
use ieee.std_logic_1164.all;

entity serialAdder is
port(
	start: in std_logic;
    clk: in std_logic;
	IN_A: in std_logic_vector(3 downto 0);
	IN_B: in std_logic_vector(3 downto 0);
	leds: out std_logic_vector(4 downto 0);
	stop: out std_logic
);
end entity serialAdder;

architecture struct of serialAdder is
	
	signal s0_i, s1_i, rst_i: std_logic;

begin

controlUnit: entity work.control
	port map(
		clk => clk,
		start => start,
		rst_l => rst_i,
		s0 => s0_i,
		s1 => s1_i,
		stop => stop
	);

executiveUnit: entity work.executiveSystem
	port map(
		A_in=> IN_A, 
    		B_in=> IN_B, 
    		S0_in=> s0_i, 
	        S1_in=> s1_i, 
	        rst_in=> rst_i, 
			clk_in=> clk, 
	    	outputs=> leds 
	);



end architecture struct;
