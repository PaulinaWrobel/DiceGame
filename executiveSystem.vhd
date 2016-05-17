library IEEE;
use IEEE.std_logic_1164.all;

entity executiveSystem is
  port(A_in: in std_logic_vector(3 downto 0);
    B_in: in std_logic_vector(3 downto 0);
    S0_in: in std_logic;
    S1_in: in std_logic;
    rst_in: in std_logic;
    clk_in: in std_logic;
    outputs: out std_logic_vector(4 downto 0)
  );
end executiveSystem;

architecture struct of executiveSystem is
    signal sum : std_logic;
    signal Q_A: std_logic_vector(3 downto 0);
    signal Q_B : std_logic_vector(3 downto 0);
    signal next_c : std_logic;
    signal last_c : std_logic;
	signal ce : std_logic;

begin

regA: entity work.shift_reg
	port map(S0=>S0_in, S1=>S1_in, P=>A_in, DSR=>sum, DSL=>'0', CP=>clk_in, MR_L=>rst_in, Q=>Q_A);
regB: entity work.shift_reg
	port map(S0=>S0_in, S1=>S1_in, P=>B_in, DSR=>'0', DSL=>'0', CP=>clk_in, MR_L=>rst_in, Q=>Q_B);
fullAdder: entity work.fullAdder
	port map(a=>Q_A(0), b=>Q_B(0), c_in=>last_c, c_out=>next_c, s=>sum);
DFF: entity work.DFF
	port map(d=>next_c, clk=>clk_in, rst=>rst_in, ce=>ce, q=>last_c);

outputs(4)<= last_c;
outputs(3 downto 0)<=Q_A;

ce <= S1_in or S0_in;

end struct;