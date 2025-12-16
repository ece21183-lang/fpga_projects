library ieee;
use ieee.std_logic_1164.all;

package hardwiredlib is

  component instr_dec
    port(
      din  : in  std_logic_vector(3 downto 0);
      dout : out std_logic_vector(15 downto 0)
    );
  end component;

  component state_dec
    port(
      din  : in  std_logic_vector(2 downto 0);
      dout : out std_logic_vector(7 downto 0)
    );
  end component;

  component counter3_bit
    port(
      clock : in  std_logic;
      rst   : in  std_logic;
      inc   : in  std_logic;
      count : out std_logic_vector(2 downto 0)
    );
  end component;

end package;

package body hardwiredlib is
end package body;