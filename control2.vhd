library ieee;
use ieee.std_logic_1164.all;

entity control is
port(
	clk: in std_logic;
	start: in std_logic;
	rst_l: out std_logic;
	s0: out std_logic;
	s1: out std_logic;
	stop: out std_logic
);
end entity control;

architecture behav of control is
	type state_type is (IDLE,RESET,LOAD,SHIFT1,SHIFT2,SHIFT3,SHIFT4);
	signal state: state_type;
begin

fsm_state: process (clk,start)
begin
	if start='1' then
		state <= RESET;
	elsif clk='1' and clk'event then
		case state is
			when RESET => 
				if start='0' then
					state <= LOAD;
				end if;
			when LOAD => 
				state <= SHIFT1;
			when SHIFT1 => 
				state <= SHIFT2;
			when SHIFT2 => 
				state <= SHIFT3;
			when SHIFT3 => 
				state <= SHIFT4;
			when SHIFT4 => 
				state <= IDLE;
			when IDLE =>
				if start='1' then
					state <= RESET;
				end if;
			when others =>
				state <= IDLE; 
		end case;
	end if;
end process fsm_state;

fsm_output: process (state)
begin
case state is
	when RESET => 
		rst_l <= '0';
		stop <= '0';
		s1 <= 'X';
		s0 <= 'X';
	when LOAD =>
		rst_l <= '1';
		stop <= '0';
		s1 <= '1';
		s0 <= '1';
	when SHIFT1 => 
		rst_l <= '1';
		stop <= '0';
		s1 <= '0';
		s0 <= '1';
	when SHIFT2 =>
		rst_l <= '1';
		stop <= '0';
		s1 <= '0';
		s0 <= '1';
	when SHIFT3 =>
		rst_l <= '1';
		stop <= '0';
		s1 <= '0';
		s0 <= '1';
	when SHIFT4 =>
		rst_l <= '1';
		stop <= '0';
		s1 <= '0';
		s0 <= '1';
	when IDLE => 
		rst_l <= '1';
		stop <= '1';
		s1 <= '0';
		s0 <= '0';
	when others =>
		rst_l <= '1';
		stop <= '1';
		s1 <= '0';
		s0 <= '0';
end case;
end process fsm_output;

end architecture behav;