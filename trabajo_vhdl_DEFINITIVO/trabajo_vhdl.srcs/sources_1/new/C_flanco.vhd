--Hay un m�dulo de flanco para cada bot�n (4)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flanco is  --Entradas y salidas del flanco
	port(
	     	boton: in std_logic;  --Entradas estado del boton (salida del modulo anterior)
	     	clk: in std_logic; --Entrada "clk"
			btn_final: out std_logic:='0');  --Salida "btn_final" qaue indica finalmente el estado de cada bot�n, pulsado o no
end flanco;

architecture behavioral of flanco is
signal salida_D1,salida_D2: std_logic;  --Se�ales salida_D1 y salida_D2 que son las salidas de los dos biestables
begin

biestable_D1:	process(clk,boton) --Primer biestable
		begin
			if (clk'event and clk='1') then  --Si hay un evento en el clk (inicial) o vale 1
				salida_D1<=boton;  --A la se�al "salida_D1" se le asigna el valor de la entrada "boton"
			end if;
		end process;

biestable_D2: process(clk,salida_D1) 
		begin
			if(clk'event and clk='1') then  --Si hay un evento en el clk (inicial) o vale 1
				salida_D2<=salida_D1;  --A la se�al "salida_D2" se le asigna el valor de la entrada "salida_D1"
			end if;
		end process;
btn_final<=salida_D1 and (not salida_D2);  --A la salida del m�dulo se le asigna el valor de la operaci�n and entre "salida_D1" y "not salida_D2"
end behavioral;

