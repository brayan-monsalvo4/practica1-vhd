library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity temporizador is
    Port ( 
        --entradas de minutos y segundos, ambos se leen como un vector de 6 bits
        min_in, sec_in : in  std_logic_vector(5 downto 0);         
        --pausa=0 y ejecucion=1
        enable : in  std_logic;
        --ciclos de reloj, clk de 100Mhz y clk_1s a 1 Hz
        clk : in  std_logic;
        clk_1s : in std_logic;
        
        reset : in  std_logic;

        --indica el modo 1=ascendente y 0 descendente
        modo : in std_logic;
        
        --senales que indican las decenas y unidades de segundo
        dec_sec_out : out std_logic_vector(3 downto 0);
        uni_sec_out : out std_logic_vector(3 downto 0);
        
        --senales que indican las decenas y unidades de minutos
        dec_min_out : out std_logic_vector(3 downto 0);
        uni_min_out : out std_logic_vector(3 downto 0);
        
        --leds que indican el estado en el que se encuentra
        led_estado_inicial : out std_logic;
        led_estado_ejecucion : out std_logic;
        led_estado_pausado: out std_logic;
        led_estado_finalizado: out std_logic;
        
        --creo que no tiene algun uso, pero se mantiene para no romper nada
        fin : out std_logic);
end temporizador;

architecture Behavioral of temporizador is
    --posibles estados
    type estados is (inicial, ejecucion_asc, pausado, finalizado);
    signal estado_actual : estados := inicial;
    
    --contadores usados
    signal segundos_total : integer := 0;
    signal contador_segundos : integer := 0;
    signal segundos_total_aux : integer := 0;
    
    --indica el fin del contador
    signal fin_aux : std_logic :='0';
    
    --senales auxiliares para los leds de estado
    signal led_inicial_aux : std_logic :='0';
    signal led_ejecucion_aux : std_logic :='0';
    signal led_pausado_aux : std_logic :='0';
    signal led_finalizado_aux : std_logic :='0';
    
    
begin
    
    process (clk, clk_1s, reset)
    begin
        --convierte los minutos de entrada a segundos , y despues le suma los segundos de entrada para tener toda la informacion en 
        --una unica senal
        segundos_total <= ( to_integer(unsigned(min_in)) * 60 ) + (to_integer(unsigned(sec_in)));
        
        if(reset='1') then
                estado_actual <= inicial;
                contador_segundos <= 0;
        elsif(enable='0') then
            estado_actual <= pausado;
        elsif(rising_edge(clk_1s)) then
            case estado_actual is
                when inicial =>
                    --si los segundos de entrada o los minutos de entrada son mayores a 0, pasa del estado inicial al estado ejecucion
                    if(unsigned(sec_in) > 0 or unsigned(min_in) > 0) then
                        if(enable='1') then
                            estado_actual <= ejecucion_asc;
                        end if;
                    end if;
                
                
                --dentro del estado ejecucion, se hacen los calculos para el conteo ascendente y descendente 
                --simultaneamente, asi al momento de cambiar de modo en medio de la ejecucion,
                --continua dicha ejecucion sin reiniciar
                when ejecucion_asc =>
                
                    --si el contador de segundos es igual al total de segundos a temporizar
                    --o los segundos restantes para llegar a 0 es igual a 0
                    --(finaliza la ejecucion)
                    if(contador_segundos = segundos_total or (segundos_total - contador_segundos) = 0) then
                        estado_actual <= finalizado;
                        
                    --si el contador de segundos es menor a total de segundos 
                    --o los segundos restantes para llegar a 0 es mayor que 0
                    --(todavia no termina la ejecucion)
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
    
--manda las decenas de minuto:
--dividiendo el contador de segundos entre 60, y despues entre 10 para obtener unicamente las decenas
dec_min_out <= std_logic_vector( to_unsigned( (contador_segundos/60)/10 , 4)) when modo='1' else
                std_logic_vector( to_unsigned( (segundos_total_aux/60)/10 , 4)) when modo='0';

--manda las unidades de minuto:
--dividiendo los segundos entre 60, y despues le aplica un modulo 10 para obtener las unidades de minuto 
uni_min_out <= std_logic_vector( to_unsigned( (contador_segundos/60) mod 10, 4 ) ) when modo='1' else
                std_logic_vector( to_unsigned( (segundos_total_aux/60) mod 10, 4 ))  when modo='0';
                
--manda las decenas de segundos:
--aplicandole un modulo 60 a los segundos, y despues diviendo el resultado para obtener las decenas de segundo
dec_sec_out <= std_logic_vector( to_unsigned( (contador_segundos mod 60)/10, 4 ) ) when modo='1' else
                std_logic_vector( to_unsigned( (segundos_total_aux mod 60)/10, 4 ) ) when modo='0';

--manda las unidades de segundos:
--aplicandole un modulo 60 a los segundos, para despues aplicarle nuevamente un modulo 10, de esta manera obteniendo solamente las
--unidades de segundo
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

