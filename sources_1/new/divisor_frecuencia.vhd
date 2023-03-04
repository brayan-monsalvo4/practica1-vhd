library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_frecuencia is
   port(
    clk100Mhz : in std_logic;
    reset    : in std_logic;
    clk1Hz : out std_logic;
    clk1Khz  : out std_logic;
    clk10hz : out std_logic
   );
end divisor_frecuencia;

architecture arch of divisor_frecuencia is

    CONSTANT Maxfrec : INTEGER := 100000000; -- 100MHz  desde oscilador de Nexys3
     CONSTANT Maxfrec2 : INTEGER := 50000000; -- 100MHz  desde oscilador de Nexys3
    CONSTANT CntMultpx : INTEGER := 50000; -- 1KHz, conteo de 50,000 en 1 y 50,000 en 0
    CONSTANT Cnt10Hz : INTEGER :=   50000; -- 10Hz, conteo de 5,000,000  en 1 y 5,000,000 en 0
    signal cnt_1Hz : INTEGER RANGE 0 to (Maxfrec- 1);
    SIGNAL cnt_1khz: INTEGER RANGE 0 to (CntMultpx - 1) := 0;
      SIGNAL cnt_10hz: INTEGER RANGE 0 to (Cnt10Hz-1) := 0;
    SIGNAL tmp_clk1khz: std_logic :='0';
    signal tmp_clk1hz : std_logic :='0';

    signal tmp_clk10hz : std_logic :='0';


begin

  div_10hz: process(reset, clk100Mhz)
  begin
   if(rising_edge(clk100Mhz)) then
                if(cnt_10hz = (Cnt10Hz-1)) then
                        tmp_clk10hz <= not tmp_clk10hz;
                        cnt_10hz <= 0;
                else
                        cnt_10hz <= cnt_10hz + 1;
                end if;
        end if;
  end process;

  clk10hz <= tmp_clk10hz;

  div_1hz: process(clk100Mhz)
  begin
    if(rising_edge(clk100Mhz)) then
                if(cnt_1hz = (50000000)) then
                        tmp_clk1hz <= not tmp_clk1hz;
                        cnt_1hz <= 0;
                else
                        cnt_1hz <= cnt_1hz + 1;
                end if;
        end if;
  end process;

  clk1Hz <= tmp_clk1hz;

div_1Khz: process(clk100Mhz)
  begin
    if(rising_edge(clk100Mhz)) then
                if(cnt_1khz = (CntMultpx-1)) then
            tmp_clk1khz <= not tmp_clk1khz;
            cnt_1khz <= 0;
        else
            cnt_1khz <= cnt_1khz + 1;
        end if;
        end if;
  end process;

  clk1khz <= tmp_clk1khz;


end arch;
