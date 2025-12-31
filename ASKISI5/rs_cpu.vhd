library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.cpulib.all;

entity rs_cpu is
  port(
    ARdata     : out std_logic_vector(15 downto 0);
    PCdata     : out std_logic_vector(15 downto 0);
    DRdata     : out std_logic_vector(7 downto 0);
    ACdata     : out std_logic_vector(7 downto 0);
    IRdata     : out std_logic_vector(7 downto 0);
    TRdata     : out std_logic_vector(7 downto 0);
    RRdata     : out std_logic_vector(7 downto 0);
    ZRdata     : out std_logic;
    clock      : in  std_logic;
    reset      : in  std_logic;
    mOP        : out std_logic_vector(26 downto 0);
    addressBus : out std_logic_vector(15 downto 0);
    dataBus    : out std_logic_vector(7 downto 0)
  );
end entity rs_cpu;

architecture arc of rs_cpu is

  signal AR_q, PC_q  : std_logic_vector(15 downto 0);
  signal DR_q, AC_q  : std_logic_vector(7 downto 0);
  signal IR_q, TR_q  : std_logic_vector(7 downto 0);
  signal RR_q        : std_logic_vector(7 downto 0);
  signal ZR_q        : std_logic;
  signal mem_q      : std_logic_vector(7 downto 0);
  signal busmem     : std_logic_vector(7 downto 0);
  signal dataBus_o  : std_logic_vector(7 downto 0);
  signal pcbus_s, drbus_s, trbus_s, rbus_s, acbus_s, membus_s : std_logic := '0';
  signal ram_addr   : std_logic_vector(7 downto 0);
  signal ram_we     : std_logic := '0';
  signal ram_din    : std_logic_vector(7 downto 0);
  signal alus_s     : std_logic_vector(6 downto 0);
  signal acload_s, zload_s, andop_s, orop_s, notop_s, xorop_s, aczero_s, acinc_s, plus_s, minus_s : std_logic := '0';
  type state_t is (S_RESET, S_FETCH1, S_FETCH2);
  signal state : state_t := S_RESET;

begin
  ARdata <= AR_q;
  PCdata <= PC_q;
  DRdata <= DR_q;
  ACdata <= AC_q;
  IRdata <= IR_q;
  TRdata <= TR_q;
  RRdata <= RR_q;
  ZRdata <= ZR_q;

  addressBus <= AR_q;
  dataBus    <= dataBus_o;

  ram_addr <= AR_q(7 downto 0);
  ram_din  <= busmem;

  -- External RAM
  u_ram : extRAM
    port map(
      clk  => clock,
      addr => ram_addr,
      we   => ram_we,
      din  => ram_din,
      dout => mem_q
    );

  -- Data bus mux
  u_bus : data_bus
    port map(
      pc_q     => PC_q(7 downto 0),
      dr_q     => DR_q,
      tr_q     => TR_q,
      r_q      => RR_q,
      ac_q     => AC_q,
      mem_q    => mem_q,
      pcbus    => pcbus_s,
      drbus    => drbus_s,
      trbus    => trbus_s,
      rbus     => rbus_s,
      acbus    => acbus_s,
      membus   => membus_s,
      dataBus_o => dataBus_o,
      busmem    => busmem
    );

  -- ALU control
  u_alus : alus
    port map(
      rbus   => rbus_s,
      acload => acload_s,
      zload  => zload_s,
      andop  => andop_s,
      orop   => orop_s,
      notop  => notop_s,
      xorop  => xorop_s,
      aczero => aczero_s,
      acinc  => acinc_s,
      plus   => plus_s,
      minus  => minus_s,
      drbus  => drbus_s,
      alus   => alus_s
    );

  -- Hardwired 
  process(clock, reset)
  begin
    if reset = '1' then
      state <= S_RESET;

      AR_q <= (others => '0');
      PC_q <= (others => '0');
      IR_q <= (others => '0');
      DR_q <= (others => '0');
      AC_q <= (others => '0');
      RR_q <= (others => '0');
      TR_q <= (others => '0');
      ZR_q <= '0';

      mOP <= (others => '0');

    elsif rising_edge(clock) then

      pcbus_s  <= '0';
      drbus_s  <= '0';
      trbus_s  <= '0';
      rbus_s   <= '0';
      acbus_s  <= '0';
      membus_s <= '0';
      ram_we   <= '0';

      mOP <= (others => '0');

      case state is

        when S_RESET =>
          state <= S_FETCH1;

        when S_FETCH1 =>
          AR_q <= PC_q;
          mOP(0) <= '1';
          state <= S_FETCH2;
        when S_FETCH2 =>
          membus_s <= '1';
          IR_q     <= mem_q;
			 PC_q <= std_logic_vector(unsigned(PC_q) + 1);
          if AC_q = x"00" then
            ZR_q <= '1';
          else
            ZR_q <= '0';
          end if;

          mOP(1) <= '1';
          mOP(2) <= '1';

          state <= S_FETCH1;

      end case;
    end if;
  end process;

end architecture arc;