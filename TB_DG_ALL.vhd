library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.math_real.all;

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

	type state_type is (SRESET, SROLL, SROLL2, SWAIT, SWRITE);
	signal state: state_type;
	signal n: integer range 0 to 11;

	alias ClkI_10Hz is
 		<<signal .TB_DG_ALL.UUT.clk_10Hz : std_logic>>;
begin

UUT: entity work.DG_ALL
	port map(
	Clk => ClkI,
	Reset => ResetI,
	Rb => RbI,
	Win => WinI,
	Lose => LoseI
	);


ClkI <= not ClkI after 10 ns;

TBState: process (ClkI_10Hz)
begin
	if (ClkI_10Hz = '1' and ClkI_10Hz'event) then
		write_text <= write_text;
		case state is
			when SRESET =>
				state <= SROLL;
			when SROLL =>
				state <= SROLL2;
			when SROLL2 =>
				state <= SWAIT;
			when SWAIT =>
				state <= SWRITE;
			when SWRITE =>
				if (WinI='1' or LoseI='1') then
					write_text <= "NEW";
					state <= SRESET;
				else
					write_text <= "   ";
					state <= SROLL;
				end if;
		end case;
	end if;
end process TBState; 

TBOutputs: process (state)
    variable seed1: positive;
    variable seed2: positive;
    variable re1: integer range 0 to 190;
    variable re2: real;
begin
	case state is
		when SRESET =>
			ResetI <= '1';
			RbI <= '0';
			write_enable <= '0';
		when SROLL =>
			ResetI <= '0';
			RbI <= '1';
			write_enable <= '0';
		when SROLL2 =>
			ResetI <= '0';
			uniform (seed1,seed2,re2);
			re1 := integer (re2 * 190.0); 
			--RbI <= '1', '0' after re1 * 1 ms;
			RbI <= '0';
			write_enable <= '0';
		when SWAIT =>
			ResetI <= '0';
			RbI <= '0';
			write_enable <= '0';
		when SWRITE =>
			ResetI <= '0';
			RbI <= '0';
			write_enable <= '1' after 10 ns;
	end case;
end process TBOutputs; 

--write_text <= "NEW" when (WinI='1' or LoseI='1') else "   ";

write_file: process (write_enable)
	file file_results: text open write_mode is "testbench_results.txt";
	variable line_results: line;
	constant space_char: character := ' ';
	constant sep_char: character := '|';
begin
	if (now = 0 ns) then
		write(line_results, string'("Time"), right, 20);
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
	elsif (write_enable='1' and write_enable'event) then
		write(line_results, now, right, 20);
		write(line_results, space_char);
		write(line_results, sep_char);
       	write(line_results, to_integer(unsigned(<<signal .TB_DG_ALL.UUT.numberA : std_logic_vector(3 downto 0)>>)), right, 2);
       	write(line_results, to_integer(unsigned(<<signal .TB_DG_ALL.UUT.numberB : std_logic_vector(3 downto 0)>>)), right, 2);
       	write(line_results, to_integer(unsigned(<<signal .TB_DG_ALL.UUT.Sum : std_logic_vector(4 downto 0)>>)), right, 4);
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

sim_end_n: process (RbI)
begin
	if (RbI'event and RbI='1') then
		assert n < 10
			report "End of simulation because n = " & integer'image(n)
			severity Failure;
		n <= n + 1;
	end if;
end process sim_end_n;

sim_end_process: process
begin
	wait for 10 sec;
	assert false
		report "End of simulation at time " & time'image(now)
		severity Failure;
end process sim_end_process;

end architecture Behav;
