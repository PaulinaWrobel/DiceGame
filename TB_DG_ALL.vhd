library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity TB_DG_ALL is
end entity TB_DG_ALL;

architecture Behav of TB_DG_ALL is
	signal ClkI: std_logic := '0';
	signal ResetI: std_logic := '0';
	signal RbI: std_logic := '0';
	signal WinI: std_logic;
	signal LoseI: std_logic;
	signal write_enable: std_logic;
	signal write_text: string(1 to 3);
begin

	UUT: entity work.DG_ALL
		port map(
		Clk => ClkI,
		Reset => ResetI,
		Rb => RbI,
		Win => WinI,
		Lose => LoseI
		);


	ClkI <= not ClkI after 20 ns;

	Reset: process (ClkI)
	begin
		if (ClkI'event and ClkI='1') then
			if (WinI='1' or LoseI='1') then
				ResetI <= '1';
			end if;
			if (ResetI='1') then
				ResetI <= '0';
				RbI <= '1' after 40 ms, '0' after 240 ms;
			end if;
		end if;
	end process Reset;

	write_text <= "NEW" when (WinI='1' or LoseI='1') else "   ";

	--write_enable <= not ClkI;
	write_enable <= not <<signal .UUT.Roll : std_logic>> after 1 ns;
	write_file: process (write_enable)
		file file_results: text open write_mode is "testbench_results.txt";
		variable line_results: line;
		constant space_char: character := ' ';
		constant sep_char: character := '|';
	begin
		if now = 0 ns then
			write(line_results, string'("Time"), right, 10);
			write(line_results, space_char);
			write(line_results, sep_char);
        	write(line_results, string'("A"), right, 2);
        	write(line_results, string'("B"), right, 2);
        	write(line_results, string'("SUM"), right, 4);
			write(line_results, space_char);
			write(line_results, sep_char);
        	write(line_results, string'("Win"), right, 5);
        	write(line_results, string'("Lose"), right, 5);
			write(line_results, sep_char);
			write(line_results, space_char);
        	write(line_results, string'("Game"), left, 5);
        	writeline(file_results, line_results);
		elsif write_enable='1' and write_enable'event then
			write(line_results, now, right, 10);
			write(line_results, space_char);
			write(line_results, sep_char);
        	write(line_results, to_integer(unsigned(<<signal .UUT.numberA : std_logic_vector(3 downto 0)>>)), right, 2);
        	write(line_results, to_integer(unsigned(<<signal .UUT.numberB : std_logic_vector(3 downto 0)>>)), right, 2);
        	write(line_results, to_integer(unsigned(<<signal .UUT.Sum : std_logic_vector(4 downto 0)>>)), right, 4);
			write(line_results, space_char);
			write(line_results, sep_char);
        	write(line_results, WinI, right, 5);
        	write(line_results, LoseI, right, 5);
			write(line_results, sep_char);
			write(line_results, space_char);
        	write(line_results, write_text, left, 5);
        	writeline(file_results, line_results);
		end if;
	end process write_file;

	sim_end_process: process
	begin
		wait for 1 sec;
		assert false
			report "End of simulation at time " & time'image(now)
			severity Failure;
	end process sim_end_process;

end architecture Behav;
