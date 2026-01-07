library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.cpulib.all;

entity rs_cpu is
  port(
    ARdata     : out std_logic_vector(15 downto 0);
    PCdata     : out std_logic_vector(15 downto 0);
    SPdata     : out std_logic_vector(15 downto 0);
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
end entity;

architecture arc of rs_cpu is

  signal AR_q, PC_q, SP_q : std_logic_vector(15 downto 0);
  signal IR_q : std_logic_vector(7 downto 0);
  signal mem_q, busmem, dataBus_o : std_logic_vector(7 downto 0);

  signal pcbus_s, membus_s : std_logic;
  signal ram_we : std_logic;

  type state_t is (
    S_RESET, S_FETCH1, S_FETCH2, S_DECODE,
    S_LDSP, S_CALL1, S_CALL2
  );
  signal state : state_t;

begin

  ARdata <= AR_q;
  PCdata <= PC_q;
  SPdata <= SP_q;
  IRdata <= IR_q;

  addressBus <= AR_q;
  dataBus    <= dataBus_o;

  u_ram : externalRAM
    port map(
      clk  => clock,
      addr => AR_q(7 downto 0),
      we   => ram_we,
      din  => busmem,
      dout => mem_q
    );

  u_bus : data_bus
    port map(
      pc_q      => PC_q(7 downto 0),
      dr_q      => (others=>'0'),
      tr_q      => (others=>'0'),
      r_q       => (others=>'0'),
      ac_q      => (others=>'0'),
      mem_q     => mem_q,
      pcbus     => pcbus_s,
      drbus     => '0',
      trbus     => '0',
      rbus      => '0',
      acbus     => '0',
      membus    => membus_s,
      dataBus_o => dataBus_o,
      busmem    => busmem
    );

  process(clock, reset)
  begin
    if reset = '1' then
      state <= S_RESET;
      AR_q <= (others=>'0');
      PC_q <= (others=>'0');
      SP_q <= (others=>'0');
      IR_q <= (others=>'0');

    elsif rising_edge(clock) then
      pcbus_s <= '0';
      membus_s <= '0';
      ram_we <= '0';

      case state is

        when S_RESET =>
          state <= S_FETCH1;

        when S_FETCH1 =>
          AR_q <= PC_q;
          state <= S_FETCH2;

        when S_FETCH2 =>
          membus_s <= '1';
          IR_q <= mem_q;
          PC_q <= std_logic_vector(unsigned(PC_q) + 1);
          state <= S_DECODE;

        when S_DECODE =>
          if IR_q = x"80" then
            state <= S_LDSP;
          elsif IR_q = x"82" then
            state <= S_CALL1;
          else
            state <= S_FETCH1;
          end if;

        when S_LDSP =>
          SP_q <= (others=>'0');
          SP_q(7 downto 0) <= IR_q;
          state <= S_FETCH1;

        when S_CALL1 =>
          AR_q <= SP_q;
          pcbus_s <= '1';
          ram_we <= '1';
          state <= S_CALL2;

        when S_CALL2 =>
          PC_q(7 downto 0) <= IR_q;
          SP_q <= std_logic_vector(unsigned(SP_q) - 1);
          state <= S_FETCH1;

      end case;
    end if;
  end process;

end architecture;
