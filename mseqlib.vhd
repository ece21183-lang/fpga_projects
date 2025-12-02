library ieee;
use ieee.std_logic_1164.all;

package mseqlib is

    component regnbit
        generic (
            n : integer := 8
        );
        port(
            din   : in  std_logic_vector(n-1 downto 0);
            clk   : in  std_logic;
            rst   : in  std_logic;
            ld    : in  std_logic;
            inc   : in  std_logic;
            dout  : out std_logic_vector(n-1 downto 0)
        );
    end component;

    component mux4
        generic (
            n : integer := 8
        );
        port(
            d0  : in  std_logic_vector(n-1 downto 0);
            d1  : in  std_logic_vector(n-1 downto 0);
            d2  : in  std_logic_vector(n-1 downto 0);
            d3  : in  std_logic_vector(n-1 downto 0);
            sel : in  std_logic_vector(1 downto 0);
            y   : out std_logic_vector(n-1 downto 0)
        );
    end component;

    component mseq_rom
        port(
            address : in  std_logic_vector(5 downto 0);
            clock   : in  std_logic;
            q       : out std_logic_vector(35 downto 0)
        );
    end component;

end mseqlib;

package body mseqlib is
end mseqlib;