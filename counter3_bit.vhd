library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter3_bit is
  port(
    clock : in  std_logic;
    rst   : in  std_logic; 
    inc   : in  std_logic;
    count : out std_logic_vector(2 downto 0)
  );
end entity;

architecture rtl of counter3_bit is
  signal c : std_logic_vector(2 downto 0);
begin
  process(clock)
  begin
    if rising_edge(clock) then
      if rst = '1' then
        c <= (others => '0');
      elsif inc = '1' then
        c <= c + "001";
      end if;
    end if;
  end process;

  count <= c;
end architecture;