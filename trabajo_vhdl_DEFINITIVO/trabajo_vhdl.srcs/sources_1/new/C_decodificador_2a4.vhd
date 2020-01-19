--controlar el displaay que se enciende en cada momento.
--Display ánodo común, para que luzca un segmento aplicar al terminal no común '0'.
--Comparten señales de control de los segmentos, todos segmento A unidos, hasta el G.
--Se encienden en secuencia. Líneas de control de los segmentos (ANx) reflejen el número correspondiente al dígito activo en ese momento. 
-- Se ve continuo gracias a la velocidad que el ojo no lo detecta.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decodificador_2a4 is

	generic(var: bit := '0');
	
	port (	entrada_dec: in std_logic_vector(1 downto 0);--le llega el estado
			rst: in std_logic;
			salida_dec: out std_logic_vector (3 downto 0));

end decodificador_2a4;
--permite controlar los displays que se encienden.
architecture Behavioral of decodificador_2a4 is
begin
	process(entrada_dec,rst)
	variable norst: std_logic;
	variable salida_i: std_logic_vector (salida_dec'range);
	begin
		norst := not (rst); 
		if norst = '0' then salida_i:= "0000";   
			elsif entrada_dec="00" then salida_i:="0001";  
			elsif entrada_dec="01" then salida_i:="0010"; 
			elsif entrada_dec="10" then salida_i:="0100"; 
			else salida_i:="1000";
		end if;
		if var='0' then salida_dec<=not (salida_i); -- Salida negada displays.
			else salida_dec<= salida_i;
		end if;
	end process;
end Behavioral;