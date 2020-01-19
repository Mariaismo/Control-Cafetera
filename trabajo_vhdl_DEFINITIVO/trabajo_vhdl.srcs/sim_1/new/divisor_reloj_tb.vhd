--Testbench del divisor de reloj
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_reloj_tb is
end divisor_reloj_tb;

architecture behavioral of divisor_reloj_tb is
component divisor_reloj is  --Estructura del divisor de reolj
	port(	clk: in std_logic;  --Entrada reloj original
	        reset: in std_logic;  --Entrada reset
			clk_dividido: out std_logic);  --Salida reloj dividido
end component;

--Una señal para cada puerto del componente
signal clk_s: std_logic :='0';  --Señal clock se inicializa en 0
signal reset_s: std_logic :='0';  --Señal reset se inicializa en 0
signal clk_dividido_s: std_logic;  --Señal reloj dividido

begin

  uut: divisor_reloj port map(  --Asignación de puertos a las señales correspondientes
	clk => clk_s,  --A la entrada clk se le asigna la señal de reloj clk_s
	reset => reset_s,  --A la entrada reset se le asigna la señal reset_s
	clk_dividido => clk_dividido_s);  --A la salida clk_dividido se le asigna la señal clk_dividido_s

  --Generación de estímulos
  reset_s <='1', '0' after 50 ns;
  clk_s <= not clk_s after 10 ns;

end behavioral;
