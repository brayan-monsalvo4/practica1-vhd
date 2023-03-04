library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top_temporizador is
Port (
    senal_reloj : in std_logic;
    sec_in : in std_logic_vector(5 downto 0);
    min_in : in std_logic_vector(5 downto 0);

    boton_reset : in std_logic;
    switch_enable : in std_logic;
    switch_modo : in std_logic;

    led_inicial : out std_logic;
    led_ejecucion : out std_logic;
    led_pausado : out std_logic;
    led_finalizado : out std_logic;

    SEG : out std_logic_vector (7 downto 0);
    AN : out std_logic_vector (3 downto 0)

);
end top_temporizador;

architecture Behavioral of top_temporizador is

    signal aux_sec_in : std_logic_vector(5 downto 0) := "000000";
    signal aux_min_in : std_logic_vector(5 downto 0) := "000000";

component temporizador port
(
        min_in, sec_in : in std_logic_vector(5 downto 0);
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
        led_estado_finalizado: out std_logic
);
end component;

component divisor_frecuencia
port(
    clk100Mhz : in std_logic;
    reset    : in std_logic;
    clk1Hz : out std_logic;
    clk1Khz  : out std_logic;
    clk10hz : out std_logic

);
end component;

component display
port(
        clk : in std_logic;
        anodos : out std_logic_vector (3 downto 0);
        segmentos : out std_logic_vector (7 downto 0);

        dec_sec_in : in std_logic_vector(3 downto 0);
        uni_sec_in : in std_logic_vector(3 downto 0);

        dec_min_in : in std_logic_vector(3 downto 0);
        uni_min_in : in std_logic_vector(3 downto 0)
);
end component;

signal uni_sec_aux : std_logic_vector(3 downto 0) :="0000";
signal dec_sec_aux : std_logic_vector(3 downto 0):="0000";
signal uni_min_aux : std_logic_vector(3 downto 0):="0000";
signal dec_min_aux : std_logic_vector(3 downto 0):="0000";

signal senal_1hz : std_logic:='0';
signal senal_1khz : std_logic:='0';
signal senal_10hz : std_logic:='0';

begin

aux_sec_in <= sec_in;
aux_min_in <= min_in;

    process(sec_in)
    begin
        aux_sec_in <= sec_in;
    end process;

        process(min_in)
    begin
        aux_min_in <= min_in;
    end process;


instancia_divisor : divisor_frecuencia port map(
    clk100Mhz => senal_reloj,
    reset => boton_reset,
    clk1Hz => senal_1hz,
    clk1Khz => senal_1khz,
    clk10hz => senal_10hz
);

instancia_temporizador: temporizador port map
(
    min_in => aux_min_in,
    sec_in => aux_sec_in,
    clk => senal_reloj,
    clk_1s => senal_1hz,
    reset => boton_reset,
    modo => switch_modo,
    dec_sec_out => dec_sec_aux,
    uni_sec_out => uni_sec_aux,
    dec_min_out => dec_min_aux,
    uni_min_out => uni_min_aux,
    led_estado_inicial => led_inicial,
    led_estado_ejecucion => led_ejecucion,
    led_estado_pausado => led_pausado,
    led_estado_finalizado => led_finalizado,
    enable => switch_enable
);

instancia_display : display port map
(
    --clk => senal_1hz,
    clk => senal_10hz,
    anodos => AN,
    segmentos => SEG,
    dec_sec_in => dec_sec_aux,
    uni_sec_in => uni_sec_aux,
    dec_min_in => dec_min_aux,
    uni_min_in => uni_min_aux
);

end Behavioral;
