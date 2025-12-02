library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library lpm;
use lpm.lpm_components.all;
use work.mseqlib.all;

entity mseq is
    port(
        ir            : in  std_logic_vector(3 downto 0);
        clock, reset  : in  std_logic;
        z             : in  std_logic;
        code          : out std_logic_vector(35 downto 0);
        mOPs          : out std_logic_vector(26 downto 0)
    );
end mseq;

architecture arc of mseq is
    
    signal mpc      : std_logic_vector(5 downto 0);
    signal next_mpc : std_logic_vector(5 downto 0);
    
    signal code_int : std_logic_vector(35 downto 0);
    
    signal sel_field  : std_logic_vector(2 downto 0);  
    signal addr_field : std_logic_vector(5 downto 0);  
    signal mops_int   : std_logic_vector(26 downto 0); 
    
    signal pc_plus1 : std_logic_vector(5 downto 0);
    signal ir_addr  : std_logic_vector(5 downto 0);
    
    signal sel_s : std_logic_vector(1 downto 0);

begin

    u_mpc : regnbit
        generic map ( n => 6 )
        port map(
            din   => next_mpc,
            clk   => clock,
            rst   => reset,
            ld    => '1',
            inc   => '0',
            dout  => mpc
        );

    u_rom : mseq_rom
        port map(
            address => mpc,
            clock   => clock,
            q       => code_int
        );

    code <= code_int;

    sel_field  <= code_int(35 downto 33);
    mops_int   <= code_int(32 downto 6);
    addr_field <= code_int(5  downto 0);

    mOPs <= mops_int;
	
    pc_plus1 <= mpc + "000001";
    ir_addr  <= "00" & ir;


    process(sel_field, z)
    begin
        case sel_field is
            when "000" =>
                
                sel_s <= "00";      

            when "001" =>
                
                sel_s <= "01";      

            when "010" =>
                
                if z = '1' then
                    sel_s <= "01";  
                else
                    sel_s <= "00";  
                end if;

            when others =>
                
                sel_s <= "10";      
        end case;
    end process;

    u_mux : mux4
        generic map ( n => 6 )
        port map(
            d0  => pc_plus1,
            d1  => addr_field,
            d2  => ir_addr,
            d3  => (others => '0'),
            sel => sel_s,
            y   => next_mpc
        );

end arc;