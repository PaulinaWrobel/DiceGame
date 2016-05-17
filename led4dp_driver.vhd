library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led4dp_driver is
    Port ( a : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN0
           b : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN1
           c : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN2
           d : in  STD_LOGIC_VECTOR (3 downto 0);       -- digit AN3 
           dp_dcba : in  STD_LOGIC_VECTOR (3 downto 0);
           clk_in : in  STD_LOGIC;                      -- ~ 1kHz
           sseg : out  STD_LOGIC_VECTOR (6 downto 0);   -- active Low
           an : out  STD_LOGIC_VECTOR (3 downto 0);     -- active Low
           dp : out STD_LOGIC);                         -- active Low
end led4dp_driver;

architecture Behavioral of led4dp_driver is
signal one_hot,address,digit: std_logic_vector(3 downto 0):="1110";
signal seg: std_logic_vector(6 downto 0);
signal dpi: std_logic;

begin

address <= one_hot;
an_out: an <= one_hot;
sseg_out: sseg <= not(seg);
dp_out: dp <= not(dpi); 

data_mux: with address select
    digit <= a when "1110",
        b when "1101",
        c when "1011",
        d when others;

dp_mux: with address select
    dpi <= dp_dcba(0) when "1110",
        dp_dcba(1) when "1101",
        dp_dcba(2) when "1011",
        dp_dcba(3) when others;

addr_reg: process(clk_in)
begin
    if rising_edge(clk_in) then 
        one_hot <= one_hot(2 downto 0) & one_hot(3);
    end if;    
end process;

sseg_dec: with digit select             --        0
    seg <= "0000110" when "0001",       --      -----
        "1011011" when "0010",          --    5|     |1
        "1001111" when "0011",          --     |  6  |
        "1100110" when "0100",          --      -----
        "1101101" when "0101",          --    4|     |2
        "1111101" when "0110",          --     |     |
        "0000111" when "0111",          --      -----
        "1111111" when "1000",          --        3
        "1101111" when "1001",
        "1110111" when "1010",
        "1111100" when "1011",
        "0111001" when "1100",
        "1011110" when "1101",
        "1111001" when "1110",
        "1110001" when "1111",
        "0111111" when others;

end Behavioral;

