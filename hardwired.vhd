library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.hardwiredlib.all;

entity hardwired is
  port(
    ir: in  std_logic_vector(3 downto 0);
    clock, reset : in  std_logic;
    z :in  std_logic;
    mOPs : out std_logic_vector(26 downto 0)
  );
end hardwired;

architecture arc of hardwired is
  signal I : std_logic_vector(15 downto 0);
  signal cnt : std_logic_vector(2 downto 0);
  signal T : std_logic_vector(7 downto 0);
  signal T0, T1, T2, T3, T4, T5, T6, T7 : std_logic;
  signal FETCH1, FETCH2, FETCH3 : std_logic;
  signal NOP1 : std_logic;
  signal LDAC1, LDAC2, LDAC3, LDAC4, LDAC5 : std_logic;
  signal STAC1, STAC2, STAC3, STAC4, STAC5 : std_logic;
  signal MVAC1, MOVR1 : std_logic;
  signal JUMP1, JUMP2, JUMP3 : std_logic;
  signal JMPZY1, JMPZY2, JMPZY3 : std_logic;
  signal JMPZN1, JMPZN2 : std_logic;
  signal JPNZY1, JPNZY2, JPNZY3 : std_logic;
  signal JPNZN1, JPNZN2: std_logic;
  signal ADD1, SUB1, INAC1, CLAC1 : std_logic;
  signal AND1, OR1, XOR1, NOT1 : std_logic;
  signal inc_s : std_logic;
  signal clr_s : std_logic;
  signal z_n : std_logic;
  signal ARLOAD, ARINC, PCLOAD, PCINC, DRLOAD, TRLOAD, IRLOAD : std_logic;
  signal RLOAD, ACLOAD, ZLOAD, READ, WRITE, MEMBUS, BUSMEM: std_logic;
  signal PCBUS, DRBUS, TRBUS, RBUS, ACBUS : std_logic;
  signal ANDOP, OROP, XOROP, NOTOP, ACINC, ACZERO, PLUS, MINUS : std_logic;

  constant B_ARLOAD : integer := 26;
  constant B_ARINC : integer := 25;
  constant B_PCLOAD: integer := 24;
  constant B_PCINC: integer := 23;
  constant B_DRLOAD : integer := 22;
  constant B_TRLOAD : integer := 21;
  constant B_IRLOAD : integer := 20;
  constant B_RLOAD : integer := 19;
  constant B_ACLOAD : integer := 18;
  constant B_ZLOAD : integer := 17;
  constant B_READ : integer := 16;
  constant B_WRITE : integer := 15;
  constant B_MEMBUS : integer := 14;
  constant B_BUSMEM : integer := 13;
  constant B_PCBUS : integer := 12;
  constant B_DRBUS : integer := 11;
  constant B_TRBUS : integer := 10;
  constant B_RBUS  : integer := 9;
  constant B_ACBUS : integer := 8;
  constant B_ANDOP : integer := 7;
  constant B_OROP : integer := 6;
  constant B_XOROP : integer := 5;
  constant B_NOTOP : integer := 4;
  constant B_ACINC : integer := 3;
  constant B_ACZERO : integer := 2;
  constant B_PLUS : integer := 1;
  constant B_MINUS : integer := 0;

begin

  z_n <= not z;

  U_IDEC : instr_dec
    port map(
      din  => ir,
      dout => I
    );

  U_CNT : counter3_bit
    port map(
      clock => clock,
      rst   => (reset or clr_s),
      inc   => inc_s,
      count => cnt
    );

  U_SDEC : state_dec
    port map(
      din  => cnt,
      dout => T
    );

  T0 <= T(0); 
  T1 <= T(1); 
  T2 <= T(2); 
  T3 <= T(3);
  T4 <= T(4); 
  T5 <= T(5); 
  T6 <= T(6); 
  T7 <= T(7);

  FETCH1 <= T0;
  FETCH2 <= T1;
  FETCH3 <= T2;  
  NOP1  <= I(0) and T3;
  LDAC1 <= I(1) and T3;
  LDAC2 <= I(1) and T4;
  LDAC3 <= I(1) and T5;
  LDAC4 <= I(1) and T6;
  LDAC5 <= I(1) and T7;
  STAC1 <= I(2) and T3;
  STAC2 <= I(2) and T4;
  STAC3 <= I(2) and T5;
  STAC4 <= I(2) and T6;
  STAC5 <= I(2) and T7;
  MVAC1 <= I(3) and T3;
  MOVR1 <= I(4) and T3;
  JUMP1 <= I(5) and T3;
  JUMP2 <= I(5) and T4;
  JUMP3 <= I(5) and T5;
  JMPZY1 <= I(6) and z  and T3;
  JMPZY2 <= I(6) and z  and T4;
  JMPZY3 <= I(6) and z  and T5;
  JMPZN1 <= I(6) and z_n and T3;
  JMPZN2 <= I(6) and z_n and T4;
  JPNZY1 <= I(7) and z_n and T3;
  JPNZY2 <= I(7) and z_n and T4;
  JPNZY3 <= I(7) and z_n and T5;
  JPNZN1 <= I(7) and z  and T3;
  JPNZN2 <= I(7) and z  and T4;
  ADD1  <= I(8) and T3;
  SUB1  <= I(9) and T3;
  INAC1 <= I(10) and T3;
  CLAC1 <= I(11) and T3;
  AND1  <= I(12) and T3;
  OR1   <= I(13) and T3;
  XOR1  <= I(14) and T3;
  NOT1  <= I(15) and T3;


  clr_s <= NOP1 or LDAC5 or STAC5 or MVAC1 or MOVR1 or  ADD1 or SUB1 or INAC1 or CLAC1 or AND1 or OR1 or XOR1 or NOT1 or  JUMP3 or JMPZY3 or JMPZN2 or JPNZY3 or JPNZN2;
  inc_s <= '1' when (reset = '0' and clr_s = '0') else '0';
  ARLOAD <= FETCH1 or FETCH3 or LDAC3 or STAC3;
  ARINC  <= LDAC1 or STAC1 or JMPZY1 or JPNZY1;
  PCLOAD <= JUMP3 or JMPZY3 or JPNZY3;
  PCINC  <= FETCH2 or LDAC1 or LDAC2 or STAC1 or STAC2 or JMPZN1 or JMPZN2 or JPNZN1 or JPNZN2;
  DRLOAD <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1  or STAC2  or STAC4  or JUMP1  or JUMP2  or   JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2;
  TRLOAD <= LDAC2 or STAC2 or JUMP2 or JMPZY2 or JPNZY2;
  IRLOAD <= FETCH3;
  RLOAD  <= MVAC1;
  ACLOAD <= LDAC5 or MOVR1 or ADD1 or SUB1 or INAC1 or CLAC1 or AND1  or OR1   or XOR1 or NOT1;
  ZLOAD  <= LDAC5 or MOVR1 or ADD1 or SUB1 or INAC1 or CLAC1 or AND1  or OR1   or XOR1 or NOT1;
  READ   <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1  or STAC2  or JUMP1  or JUMP2  or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2;
  WRITE  <= STAC5;
  MEMBUS <= FETCH2 or LDAC1 or LDAC2 or LDAC4 or STAC1  or STAC2  or JUMP1  or JUMP2  or JMPZY1 or JMPZY2 or JPNZY1 or JPNZY2;
  BUSMEM <= STAC5;
  PCBUS  <= FETCH1 or FETCH3;
  DRBUS  <= LDAC2 or LDAC3 or LDAC5 or STAC2 or STAC3 or STAC5 or JUMP2 or JUMP3 or JMPZY2 or JMPZY3 or JPNZY2 or JPNZY3;
  TRBUS  <= LDAC3 or STAC3 or JUMP3 or JMPZY3 or JPNZY3;
  RBUS   <= MOVR1 or ADD1 or SUB1 or AND1 or OR1 or XOR1;
  ACBUS  <= STAC4 or MVAC1;
  ANDOP  <= AND1;
  OROP   <= OR1;
  XOROP  <= XOR1;
  NOTOP  <= NOT1;
  ACINC  <= INAC1;
  ACZERO <= CLAC1;
  PLUS   <= ADD1;
  MINUS  <= SUB1;

  
  process(all)
    variable v : std_logic_vector(26 downto 0);
  begin
    v := (others => '0');

    v(B_ARLOAD) := ARLOAD;
    v(B_ARINC) := ARINC;
    v(B_PCLOAD) := PCLOAD;
    v(B_PCINC) := PCINC;
    v(B_DRLOAD) := DRLOAD;
    v(B_TRLOAD) := TRLOAD;
    v(B_IRLOAD):= IRLOAD;
    v(B_RLOAD) := RLOAD;
    v(B_ACLOAD) := ACLOAD;
    v(B_ZLOAD) := ZLOAD;
    v(B_READ)  := READ;
    v(B_WRITE) := WRITE;
    v(B_MEMBUS) := MEMBUS;
    v(B_BUSMEM) := BUSMEM;
    v(B_PCBUS) := PCBUS;
    v(B_DRBUS) := DRBUS;
    v(B_TRBUS) := TRBUS;
    v(B_RBUS)  := RBUS;
    v(B_ACBUS) := ACBUS;
    v(B_ANDOP) := ANDOP;
    v(B_OROP)  := OROP;
    v(B_XOROP) := XOROP;
    v(B_NOTOP) := NOTOP;
    v(B_ACINC) := ACINC;
    v(B_ACZERO) := ACZERO;
    v(B_PLUS)  := PLUS;
    v(B_MINUS) := MINUS;

    mOPs <= v;
  end process;

end arc;