library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testb is
end testb;

architecture test of testb is
    signal clk : std_logic := '1';
    signal anodos : std_logic_vector(3 downto 0);
    signal segmentos : std_logic_vector(7 downto 0);
    
    signal dec_sec_in : unsigned(3 downto 0);
    signal uni_sec_in : unsigned(3 downto 0);
    signal dec_min_in : unsigned(3 downto 0);
    signal uni_min_in : unsigned(3 downto 0);
    
    signal display1 : unsigned(3 downto 0) := "0111";
    signal display2 : unsigned(3 downto 0) := "0000";
    signal display3 : unsigned(3 downto 0) := "0010";
    signal display4 : unsigned(3 downto 0) := "0000";
    
begin
    uut: entity work.display port map ( 
        clk => clk,
        anodos => anodos,
        segmentos => segmentos,
        dec_sec_in => dec_sec_in,
        uni_sec_in => uni_sec_in,
        dec_min_in => dec_min_in,
        uni_min_in => uni_min_in    
    );
    
    process
    begin
        while true loop
        clk <= not clk;
        wait for 10 ns;
        end loop;
    end process;

    uni_sec_in <= display1;
    dec_sec_in <= display2;
    uni_min_in <= display3;
    dec_min_in <= display4;
  
    
end architecture;
