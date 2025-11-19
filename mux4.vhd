library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
  generic ( n : integer := 8 );
  port(
    d0  : in  std_logic_vector(n-1 downto 0);
    d1  : in  std_logic_vector(n-1 downto 0);
    d2  : in  std_logic_vector(n-1 downto 0);
    d3  : in  std_logic_vector(n-1 downto 0);
    sel : in  std_logic_vector(1 downto 0);
    y   : out std_logic_vector(n-1 downto 0)
  );
end entity mux4;

architecture rtl of mux4 is
begin
  with sel select
    y <= d0 when "00",
         d1 when "01",
         d2 when "10",
         d3 when "11",
         (others => '0') when others;
end architecture rtl;