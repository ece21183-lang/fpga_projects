library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rs_cpu is
end entity;

architecture sim of tb_rs_cpu is

  signal ARdata     : std_logic_vector(15 downto 0);
  signal PCdata     : std_logic_vector(15 downto 0);
  signal SPdata     : std_logic_vector(15 downto 0);
  signal DRdata     : std_logic_vector(7 downto 0);
  signal ACdata     : std_logic_vector(7 downto 0);
  signal IRdata     : std_logic_vector(7 downto 0);
  signal TRdata     : std_logic_vector(7 downto 0);
  signal RRdata     : std_logic_vector(7 downto 0);
  signal ZRdata     : std_logic;
  signal mOP        : std_logic_vector(26 downto 0);
  signal addressBus : std_logic_vector(15 downto 0);
  signal dataBus    : std_logic_vector(7 downto 0);

  signal clock : std_logic := '0';
  signal reset : std_logic := '1';

begin

  -- Clock: 20 ns period
  clock <= not clock after 10 ns;

  -- DUT
  uut : entity work.rs_cpu
    port map(
      ARdata     => ARdata,
      PCdata     => PCdata,
      SPdata     => SPdata,
      DRdata     => DRdata,
      ACdata     => ACdata,
      IRdata     => IRdata,
      TRdata     => TRdata,
      RRdata     => RRdata,
      ZRdata     => ZRdata,
      clock      => clock,
      reset      => reset,
      mOP        => mOP,
      addressBus => addressBus,
      dataBus    => dataBus
    );

  -- Reset process
  process
  begin
    reset <= '1';
    wait for 40 ns;
    reset <= '0';
    wait;
  end process;

end architecture;
