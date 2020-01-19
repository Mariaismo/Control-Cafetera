library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--se crea un bucle de estados que cambia cada vez que hay un cambio del reloj dividido.
--con cada pulso del reloj dividido se lo pasas al decodificador que encenderá.
-- al ser tan rápido verás todos los display encedidos.
entity clk_dis_state is
	port(
	  clk_div: in std_logic;--le entra el reloj con la disminución en frecuencia
	  salida_estado: out std_logic_vector(1 downto 0) --nos saca el estado en el que estamos
	);
end clk_dis_state;

architecture behavioral of clk_dis_state is
signal contador: natural range 0 to 3:=0;
begin 
	process(clk_div)
	begin
	   if clk_div = '1' and clk_div'event then
			if contador = 0 then salida_estado<="00";
				contador<=contador +1 ;
			elsif contador = 1 then 
				salida_estado<="01";
				contador<=contador +1;
			elsif contador = 2 then
				salida_estado<="10";
				contador<=contador +1;
			else
				salida_estado<="11";
				contador<=0;
			end if;
		end if;
	end process;
end behavioral;