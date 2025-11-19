library ieee;
use ieee.std_logic_1164.all;

entity mux2 is
  generic ( n : integer := 8 );
  port(
    d0  : in  std_logic_vector(n-1 downto 0);
    d1  : in  std_logic_vector(n-1 downto 0);
    sel : in  std_logic;
    y   : out std_logic_vector(n-1 downto 0)
  );
end entity mux2;

architecture rtl of mux2 is
begin
  y <= d0 when sel = '0' else d1;
end architecture rtl;