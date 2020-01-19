--Un solo divisor de reloj
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor_reloj is  --Entradas y salidas del divisor de reloj
	generic (max: natural := 10);  --Entero "max" con valor inicial 10
	port(	clk: in std_logic; --Entradas de reloj
	        reset: in std_logic;--Entrada reset
			clk_dividido: out std_logic);  --Salida nuevo reloj
end divisor_reloj;

architecture behavioral of divisor_reloj is
  subtype contador_t is natural range 0 to max;
  signal contador: contador_t;  --Señal "contador" con valor inicial 0		
begin
  divisor:	process(clk,reset) --Cada 10 pulsos de reloj "normal" da un pulso el reloj dividido
  begin
    if reset = '1' then  --Si la señal de reset vale 1
      contador <= 0;  --A la señal "contador" se le asigna el valor 0
      clk_dividido <= '0';  --A la señal "clk_dividido" se le asigna el valor 0
    elsif clk'event and clk = '1' then  --Si hay un flanco positivo en la entrada clk o clk=1
      if contador >= max - 1 then  --Si la señal "contador" es mayor o igual que max-1=9
        clk_dividido <= '1';  --A la señal "clk_dividido" se le asigna el valor 1
        contador <= 0;  --A la señal "contador" se le asigna el valor 0
      else  --Si no se cumple ninguno de los dos casos anteriores
        clk_dividido <= '0';  ----Al reloj dividido" se le asigna el valor 0
        contador <=contador + 1;  --La señal contador incrementa en 1 su valor
      end if;
    end if;
  end process;
end behavioral;