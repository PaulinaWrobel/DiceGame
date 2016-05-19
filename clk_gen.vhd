library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clk_gen is
	port(
		clk_in: in std_logic;
		clk_1MHz: out std_logic;
		clk_1kHz: out std_logic;
		clk_10Hz: out std_logic;
		clk_A: out std_logic;
		clk_B: out std_logic
	);
end clk_gen;

architecture behav of clk_gen is
constant N_1MHz: natural := 50/2;
constant N_1kHz: natural := 1000;
constant N_10Hz: natural := 100;
constant N_A: natural := 7;
constant N_B: natural := 5;

signal count_1MHz: integer range 0 to N_1MHz := 0;
signal count_1kHz: integer range 0 to N_1kHz := 0;
signal count_10Hz: integer range 0 to N_10Hz := 0;
signal count_A: integer range 0 to N_A := 0;
signal count_B: integer range 0 to N_B := 0;

signal clk_1MHz_i: std_logic := '0';
signal clk_1kHz_i: std_logic := '0';
signal clk_10Hz_i: std_logic := '0';
signal clk_A_i: std_logic := '0';
signal clk_B_i: std_logic := '0';

signal en_1MHz: std_logic := '0';
signal en_1kHz: std_logic := '0';
signal en_10Hz: std_logic := '0';
signal en_A: std_logic := '0';
signal en_B: std_logic := '0';

begin
----------------- 1MHz ---------------------
timer_1MHz: process (clk_in)
begin
	if (clk_in'event and clk_in='1') then
		if count_1MHz = (N_1MHz-1) then
			count_1MHz <= 0;
			en_1MHz <= '1';
		else
			count_1MHz <= count_1MHz + 1;
			en_1MHz <= '0';
		end if;
	end if;
end process timer_1MHz;

output_1MHz: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1') then
		clk_1MHz_i <= not clk_1MHz_i;
	end if;
end process output_1MHz;

clk_1MHz <= clk_1MHz_i;
----------------- 1MHz ---------------------
----------------- 1kHz ---------------------
timer_1kHz: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1') then
		if count_1kHz = (N_1kHz-1) then
			count_1kHz <= 0;
			en_1kHz <= '1';
		else
			count_1kHz <= count_1kHz + 1;
			en_1kHz <= '0';
		end if;
	end if;
end process timer_1kHz;

output_1kHz: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1' and en_1kHz='1') then
		clk_1kHz_i <= not clk_1kHz_i;
	end if;
end process output_1kHz;

clk_1kHz <= clk_1kHz_i;
----------------- 1kHz ---------------------
----------------- 10Hz ---------------------
timer_10Hz: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1' and en_1kHz='1') then
		if count_10Hz = (N_10Hz-1) then
			count_10Hz <= 0;
			en_10Hz <= '1';
		else
			count_10Hz <= count_10Hz + 1;
			en_10Hz <= '0';
		end if;
	end if;
end process timer_10Hz;

output_10Hz: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1' and en_1kHz='1' and en_10Hz='1') then
		clk_10Hz_i <= not clk_10Hz_i;
	end if;
end process output_10Hz;

clk_10Hz <= clk_10Hz_i;
----------------- 10Hz ---------------------
------------------- A ----------------------
timer_A: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1' and en_1kHz='1') then
		if count_A = (N_A-1) then
			count_A <= 0;
			en_A <= '1';
		else
			count_A <= count_A + 1;
			en_A <= '0';
		end if;
	end if;
end process timer_A;

output_A: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1' and en_1kHz='1' and en_A='1') then
		clk_A_i <= not clk_A_i;
	end if;
end process output_A;

clk_A <= clk_A_i;
------------------- A ----------------------
------------------- B ----------------------
timer_B: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1' and en_1kHz='1') then
		if count_B = (N_B-1) then
			count_B <= 0;
			en_B <= '1';
		else
			count_B <= count_B + 1;
			en_B <= '0';
		end if;
	end if;
end process timer_B;

output_B: process (clk_in)
begin
	if (clk_in'event and clk_in='1' and en_1MHz='1' and en_1kHz='1' and en_B='1') then
		clk_B_i <= not clk_B_i;
	end if;
end process output_B;

clk_B <= clk_B_i;
------------------- A ----------------------

end behav;
