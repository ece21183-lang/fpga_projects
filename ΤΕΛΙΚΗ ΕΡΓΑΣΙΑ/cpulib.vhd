library ieee;
use ieee.std_logic_1164.all;

package cpulib is

  component alus is
    port(
      rbus, acload, zload, andop,
      orop, notop, xorop, aczero,
      acinc, plus, minus, drbus : in  std_logic;
      alus                      : out std_logic_vector(6 downto 0)
    );
  end component;

  component data_bus is
    port(
      pc_q   : in  std_logic_vector(7 downto 0);
      dr_q   : in  std_logic_vector(7 downto 0);
      tr_q   : in  std_logic_vector(7 downto 0);
      r_q    : in  std_logic_vector(7 downto 0);
      ac_q   : in  std_logic_vector(7 downto 0);
      mem_q  : in  std_logic_vector(7 downto 0);

      pcbus  : in  std_logic;
      drbus  : in  std_logic;
      trbus  : in  std_logic;
      rbus   : in  std_logic;
      acbus  : in  std_logic;
      membus : in  std_logic;

      dataBus_o : out std_logic_vector(7 downto 0);
      busmem    : out std_logic_vector(7 downto 0)
    );
  end component;

  component externalRAM is
    port(
      clk  : in  std_logic;
      addr : in  std_logic_vector(7 downto 0);
      we   : in  std_logic;
      din  : in  std_logic_vector(7 downto 0);
      dout : out std_logic_vector(7 downto 0)
    );
  end component;

end package cpulib;

package body cpulib is
end package body cpulib;