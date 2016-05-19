library ieee;
use ieee.std_logic_1164.all;

entity TB_DG_0 is
end entity TB_DG_0;

architecture struct of TB_DG_0 is
	signal ClkI: std_logic;
	signal ResetI: std_logic;
	signal RbI: std_logic;
	signal SumI: std_logic_vector(4 downto 0);
	signal RollI: std_logic;
	signal WinI: std_logic;
	signal LoseI: std_logic;
begin

UUT: entity work.DG_NoSum
	port map(
		Clk => ClkI,
		Reset => ResetI,
		Rb => RbI,
		Sum => SumI,
		Roll => RollI,
		Win => WinI,
		Lose => LoseI
	);

Test: entity work.GameTest
	port map(
		Roll => RollI,
		Win => WinI,
		Lose => LoseI,
		Clk => ClkI,
		Reset => ResetI,
		Rb => RbI,
		Sum => SumI
	);

	sim_end_process: process
	begin
		wait for 10000 ns;
		assert false
			report "End of simulation at time " & time'image(now)
			severity Failure;
	end process sim_end_process;

end architecture struct;
