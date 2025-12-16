library ieee;
use ieee.std_logic_1164.all;

entity instr_dec is
  port(
    din  : in  std_logic_vector(3 downto 0);
    dout : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of instr_dec is
begin
  process(din)
  begin
    dout <= (others => '0');
    case din is
      when "0000" => dout(0)  <= '1';  --Εντολή INOP
      when "0001" => dout(1)  <= '1';  --Εντολή ILDAC
      when "0010" => dout(2)  <= '1';  --Εντολή ISTAC
      when "0011" => dout(3)  <= '1';  --Εντολή IMVAC
      when "0100" => dout(4)  <= '1';  --Εντολή IMOVR
      when "0101" => dout(5)  <= '1';  --Εντολή IJUMP
      when "0110" => dout(6)  <= '1';  --Εντολή IJMPZ
      when "0111" => dout(7)  <= '1';  --Εντολή IJPNZ
      when "1000" => dout(8)  <= '1';  --Εντολή IADD
      when "1001" => dout(9)  <= '1';  --Εντολή SUB
      when "1010" => dout(10) <= '1';  --Εντολή IINAC
      when "1011" => dout(11) <= '1';  --Εντολή CLAC
      when "1100" => dout(12) <= '1';  --Εντολή IAND
      when "1101" => dout(13) <= '1';  --Εντολή IOR
      when "1110" => dout(14) <= '1';  --Εντολή IXOR
      when others => dout(15) <= '1';  --Εντολή INOT
    end case;
  end process;
end architecture;