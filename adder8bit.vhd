library ieee;
use ieee.std_logic_1164.all;

entity adder8bit is
  generic ( n : integer := 8 );
  port(
    a   : in  std_logic_vector(n-1 downto 0);
    b   : in  std_logic_vector(n-1 downto 0);
    cin : in  std_logic;
    s   : out std_logic_vector(n-1 downto 0);
    cout: out std_logic
  );
end entity adder8bit;

architecture structural of adder8bit is
  component adder1bit
    port(
      a    : in  std_logic;
      b    : in  std_logic;
      cin  : in  std_logic;
      s    : out std_logic;
      cout : out std_logic
    );
  end component;

  signal c : std_logic_vector(n downto 0);
begin
  c(0) <= cin;
  cout <= c(n);

  adders: for i in 0 to n-1 generate
    adder_i: adder1bit
      port map(
        a    => a(i),
        b    => b(i),
        cin  => c(i),
        s    => s(i),
        cout => c(i+1)
      );
  end generate adders;

end architecture structural;