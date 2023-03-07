library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity display is
    port (
        clk : in std_logic;
        anodos : out std_logic_vector (3 downto 0);
        segmentos : out std_logic_vector (7 downto 0);

        dec_sec_in : in std_logic_vector(3 downto 0);
        uni_sec_in : in std_logic_vector(3 downto 0);

        dec_min_in : in std_logic_vector(3 downto 0);
        uni_min_in : in std_logic_vector(3 downto 0)
    );
end display;

architecture Behavioral of display is

     -- 50Mzh/100000=500Hz
    constant max_refresh_count: INTEGER := 100000; 
    signal refresh_count: INTEGER range 0 to max_refresh_count;
    signal display_sel: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	
    signal contador : integer :=0;
    
    signal dec_sec_bcd : std_logic_vector(3 downto 0) :="0000";
    signal uni_sec_bcd : std_logic_vector(3 downto 0) :="0000";
    signal dec_min_bcd : std_logic_vector(3 downto 0) :="0000";
    signal uni_min_bcd : std_logic_vector(3 downto 0) :="0000";

begin

    anodos <= display_sel;
    
    
--    process(dec_sec_in)
--    begin
--        dec_sec_bcd <= dec_sec_in;
--    end process;
    
--    process(uni_sec_in)
--    begin
--        uni_sec_bcd <= uni_sec_in;
--    end process;
    
--    process(dec_min_in)
--    begin
--        dec_min_bcd <= dec_min_in;
--    end process;
    
--    process(uni_min_in)
--    begin
--        uni_min_bcd <= uni_min_in;
--    end process;

    gen_clock: process(clk)
    begin
    
        if( rising_edge(clk) ) then
            if (contador < 3) then
		      contador <= contador + 1;
          else
            contador <=0;
            end if;
        end if;
		  
    end process; 

    mostrar_display : process(contador)
    begin
        case contador is
            when 0 =>
                display_sel <= "1110";
            when 1 =>
                display_sel <= "1101";
            when 2 =>
                display_sel <= "1011";
            when 3 => 
                display_sel <= "0111";
            when others =>
                display_sel <= "1111";     
        end case;
        
        case display_sel is
            when "1110" =>
                case uni_sec_in is
                    when "0000" => segmentos <= "11000000";
                    when "0001" => segmentos <= "11111001";
                    when "0010" => segmentos <= "10100100";
                    when "0011" => segmentos <= "10110000";
                    when "0100" => segmentos <= "10011001";
                    when "0101" => segmentos <= "10010010";
                    when "0110" => segmentos <= "10000010";
                    when "0111" => segmentos <= "11111000";
                    when "1000" => segmentos <= "10000000";
                    when "1001" => segmentos <= "10010000";
                    
                    when others => segmentos <= "11111001";
                end case;
            
            when "1101" =>
                case dec_sec_in is
                    when "0000" => segmentos <= "11000000";
                    when "0001" => segmentos <= "11111001";
                    when "0010" => segmentos <= "10100100";
                    when "0011" => segmentos <= "10110000";
                    when "0100" => segmentos <= "10011001";
                    when "0101" => segmentos <= "10010010";
                    when "0110" => segmentos <= "10000010";
                    when "0111" => segmentos <= "11111000";
                    when "1000" => segmentos <= "10000000";
                    when "1001" => segmentos <= "10010000";
                    
                    when others => segmentos <= "11111001";
                end case;
                
            when "1011" =>
                case uni_min_in is
                    when "0000" => segmentos <= "11000000";
                    when "0001" => segmentos <= "11111001";
                    when "0010" => segmentos <= "10100100";
                    when "0011" => segmentos <= "10110000";
                    when "0100" => segmentos <= "10011001";
                    when "0101" => segmentos <= "10010010";
                    when "0110" => segmentos <= "10000010";
                    when "0111" => segmentos <= "11111000";
                    when "1000" => segmentos <= "10000000";
                    when "1001" => segmentos <= "10010000";
                    
                    when others => segmentos <= "11111001";
                end case;
                
            when "0111" =>
                case dec_min_in is
                    when "0000" => segmentos <= "11000000";
                    when "0001" => segmentos <= "11111001";
                    when "0010" => segmentos <= "10100100";
                    when "0011" => segmentos <= "10110000";
                    when "0100" => segmentos <= "10011001";
                    when "0101" => segmentos <= "10010010";
                    when "0110" => segmentos <= "10000010";
                    when "0111" => segmentos <= "11111000";
                    when "1000" => segmentos <= "10000000";
                    when "1001" => segmentos <= "10010000";
                    
                    when others => segmentos <= "11111001";
                end case;
                
            when others =>
                segmentos <= "11111111";
                    
        end case;
    end process;
    
end Behavioral;
