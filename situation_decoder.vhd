library ieee;
use ieee.std_logic_1164.all;

entity state_dec is
  port(
    din  : in  std_logic_vector(2 downto 0);
    dout : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of state_dec is
begin
  process(din)
  begin
    dout <= (others => '0');
    case din is
      when "000" => dout(0) <= '1';  -- Κατάσταση T0
      when "001" => dout(1) <= '1';  -- Κατάσταση T1
      when "010" => dout(2) <= '1';  -- Κατάσταση T2
      when "011" => dout(3) <= '1';  -- Κατάσταση T3
      when "100" => dout(4) <= '1';  -- Κατάσταση T4
      when "101" => dout(5) <= '1';  -- Κατάσταση T5
      when "110" => dout(6) <= '1';  -- Κατάσταση T6
      when others=> dout(7) <= '1';  -- Κατάσταση T7
    end case;
  end process;
end architecture;