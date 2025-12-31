library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity externalRAM is
  port(
    clk   : in  std_logic;
    addr  : in  std_logic_vector(7 downto 0);   -- 0..255
    we    : in  std_logic;                      -- write enable
    din   : in  std_logic_vector(7 downto 0);   -- data to memory
    dout  : out std_logic_vector(7 downto 0)    -- data from memory
  );
end entity;

architecture rtl of extRAM is
begin

  u_ram : altsyncram
    generic map(
      operation_mode         => "SINGLE_PORT",
      width_a                => 8,
      widthad_a              => 8,
      numwords_a             => 256,
      outdata_reg_a          => "UNREGISTERED",   
      init_file              => "extRAM.mif",
      intended_device_family => "Cyclone V",      
      read_during_write_mode_port_a => "NEW_DATA_NO_NBE_READ"
    )
    port map(
      clock0    => clk,
      address_a => addr,
      wren_a    => we,
      data_a    => din,
      q_a       => dout
    );

end architecture;