library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is
  port(a: in std_logic;
    b: in std_logic;
    c_in: in std_logic; 
    c_out: out std_logic;
    s: out std_logic
  );
end fullAdder;

architecture behav of fullAdder is
begin
    s <= c_in xor a xor b;
    c_out <= (a and b) or (c_in and (a xor b));
end behav;
