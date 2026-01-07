library ieee;
use ieee.std_logic_1164.all;

entity data_bus is
  port(
    -- data
    pc_q   : in  std_logic_vector(7 downto 0);
    dr_q   : in  std_logic_vector(7 downto 0);
    tr_q   : in  std_logic_vector(7 downto 0);
    r_q    : in  std_logic_vector(7 downto 0);
    ac_q   : in  std_logic_vector(7 downto 0);
    mem_q  : in  std_logic_vector(7 downto 0);

    -- buffers (enables)
    pcbus  : in  std_logic;
    drbus  : in  std_logic;
    trbus  : in  std_logic;
    rbus   : in  std_logic;
    acbus  : in  std_logic;
    membus : in  std_logic;

    -- outputs
    dataBus_o : out std_logic_vector(7 downto 0);
    busmem    : out std_logic_vector(7 downto 0)
  );
end entity data_bus;

architecture rtl of data_bus is
begin
  process(pc_q, dr_q, tr_q, r_q, ac_q, mem_q, pcbus, drbus, trbus, rbus, acbus, membus)
    variable vbus : std_logic_vector(7 downto 0);
  begin
    vbus := (others => '0');

    if    pcbus  = '1' then vbus := pc_q;
    elsif drbus  = '1' then vbus := dr_q;
    elsif trbus  = '1' then vbus := tr_q;
    elsif rbus   = '1' then vbus := r_q;
    elsif acbus  = '1' then vbus := ac_q;
    elsif membus = '1' then vbus := mem_q;
    else
      vbus := (others => '0'); -- idle bus
    end if;

    dataBus_o <= vbus;
    busmem    <= vbus;         
  end process;
end architecture rtl;