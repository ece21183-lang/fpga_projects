library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

use work.alulib.all;

entity alu is
  generic ( n : integer := 8);
  port(
    ac   : in  std_logic_vector(n-1 downto 0);
    db   : in  std_logic_vector(n-1 downto 0);
    alus : in  std_logic_vector(7 downto 1); 
    dout : out std_logic_vector(n-1 downto 0)
  );
end entity alu;

architecture arch of alu is
  signal sum, diff, inacc : std_logic_vector(n-1 downto 0);
begin

  
  sum   <= std_logic_vector(unsigned(ac) + unsigned(db));
  diff  <= std_logic_vector(unsigned(ac) - unsigned(db));
  inacc <= std_logic_vector(unsigned(ac) + 1);

  process(ac, db, alus, sum, diff, inacc)
  begin
   
    dout <= (others => '0');

    if alus = "1000000" then          
      dout <= ac and db;

    elsif alus = "1100000" then        
      dout <= ac or db;

    elsif alus = "1010000" then       
      dout <= ac xor db;

    elsif alus = "1110000" then        
      dout <= not ac;

    elsif alus = "0000101" then        
      dout <= sum;

    elsif alus = "0001011" then        
      dout <= diff;

    elsif alus = "0001001" then      
      dout <= inacc;

    elsif alus = "0000100" then        
      dout <= db;

    elsif alus = "0000000" then        
      dout <= (others => '0');

    else
      dout <= (others => '0'); 
    end if;
  end process;

end architecture arch;