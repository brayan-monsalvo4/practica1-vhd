library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity temporizador is
    Port ( 
        min_in, sec_in : in  std_logic_vector(5 downto 0);
        enable : in  std_logic;
        clk : in  std_logic;
        clk_1s : in std_logic;
        reset : in  std_logic;
        modo : in std_logic;
        
        dec_sec_out : out std_logic_vector(3 downto 0);
        uni_sec_out : out std_logic_vector(3 downto 0);
        
        dec_min_out : out std_logic_vector(3 downto 0);
        uni_min_out : out std_logic_vector(3 downto 0);
        
        led_estado_inicial : out std_logic;
        led_estado_ejecucion : out std_logic;
        led_estado_pausado: out std_logic;
        led_estado_finalizado: out std_logic;
        
        fin : out std_logic);
end temporizador;

architecture Behavioral of temporizador is
    type estados is (inicial, ejecucion_asc, pausado, finalizado);

    signal estado_actual : estados := inicial;

    
   signal segundos_total : integer := 0;
   signal contador_segundos : integer := 0;
   signal segundos_total_aux : integer := 0;
    
    --indica el fin del contador
    signal fin_aux : std_logic :='0';
    
    signal led_inicial_aux : std_logic :='0';
    signal led_ejecucion_aux : std_logic :='0';
    signal led_pausado_aux : std_logic :='0';
    signal led_finalizado_aux : std_logic :='0';
    
    
begin

    process (clk, clk_1s, reset)
    begin
        segundos_total <= ( to_integer(unsigned(min_in)) * 60 ) + (to_integer(unsigned(sec_in)));
        
        if(reset='1') then
                estado_actual <= inicial;
                contador_segundos <= 0;
        elsif(enable='0') then
            estado_actual <= pausado;
        elsif(rising_edge(clk_1s)) then
            case estado_actual is
                when inicial =>
                    if(unsigned(sec_in) > 0 or unsigned(min_in) > 0) then
                        if(enable='1') then
                            estado_actual <= ejecucion_asc;
                        end if;
                    end if;
                
                when ejecucion_asc =>
                    if(contador_segundos = segundos_total or (segundos_total - contador_segundos) = 0) then
                        estado_actual <= finalizado;
                    elsif(contador_segundos < segundos_total or (segundos_total - contador_segundos) > 0) then
                        contador_segundos <= contador_segundos + 1;
                        segundos_total_aux <= segundos_total - contador_segundos;
                    end if;
                when finalizado =>
                    null;
                
                when pausado =>
                    if(enable='1') then
                        estado_actual <= ejecucion_asc;
                    end if;
                    
                when others =>
                    null;
            end case;
        end if;
    end process;
    
dec_min_out <= std_logic_vector( to_unsigned( (contador_segundos/60)/10 , 4)) when modo='1' else
                std_logic_vector( to_unsigned( (segundos_total_aux/60)/10 , 4)) when modo='0';


uni_min_out <= std_logic_vector( to_unsigned( (contador_segundos/60) mod 10, 4 ) ) when modo='1' else
                std_logic_vector( to_unsigned( (segundos_total_aux/60) mod 10, 4 ))  when modo='0';

dec_sec_out <= std_logic_vector( to_unsigned( (contador_segundos mod 60)/10, 4 ) ) when modo='1' else
                std_logic_vector( to_unsigned( (segundos_total_aux mod 60)/10, 4 ) ) when modo='0';

uni_sec_out <= std_logic_vector( to_unsigned( (contador_segundos mod 60) mod 10, 4 ) ) when modo='1' else
                std_logic_vector( to_unsigned( (segundos_total_aux mod 60) mod 10, 4 ) ) when modo='0';

    process (estado_actual)
    begin
        case estado_actual is
            when inicial =>
                led_inicial_aux <= '1';
                led_ejecucion_aux <= '0';
                led_pausado_aux <= '0';
                led_finalizado_aux <= '0';
                fin_aux <= '0';
                
            when ejecucion_asc =>
                led_inicial_aux <= '0';
                led_ejecucion_aux <= '1';
                led_pausado_aux <= '0';
                led_finalizado_aux <= '0';
                  fin_aux <= '0';
                
            when finalizado =>
                led_inicial_aux <= '0';
                led_ejecucion_aux <= '0';
                led_pausado_aux <= '0';
                led_finalizado_aux <= '1';
                fin_aux <= '1';
            
            when pausado =>
                led_inicial_aux <= '0';
                led_ejecucion_aux <= '0';
                led_finalizado_aux <= '0';
                led_pausado_aux <= '1';
                fin_aux <= '0';
                
            when others =>
                null;
                
        end case;
    end process;
    
    led_estado_inicial <= led_inicial_aux;
    led_estado_ejecucion <= led_ejecucion_aux;
    led_estado_pausado <= led_pausado_aux;
    led_estado_finalizado <= led_finalizado_aux;
    
    
  fin <= fin_aux;
    
    
end Behavioral;

