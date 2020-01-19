library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cafetera is
	generic(	
	            t_e1_reset: natural := 40;  -- Tiempo que tarda a volver al reposo si en el estado 1 (selección del producto) no detecta actividad
				t_e2_corto: natural := 10; -- Tiempo que tarda en echar el café corto.
				t_e2_largo: natural := 20; -- Tiempo que tarda en echar el cafe largo.
				t_e4_leche: natural := 5); -- Tiempo que tarda en echar la leche.
				
	port(	
	        boton: in std_logic_vector(3 downto 0);
			clk: in std_logic;
			display1, display2, display3, display4: out std_logic_vector(7 downto 0); 
			led: out std_logic_vector(7 downto 0)
			);
end cafetera;

architecture Behavioral of cafetera is

type estado is (E0, E1, E2, E3, E4, E5, E6, E7);
signal estado_actual, estado_siguiente: estado:=E0;
constant second: integer:= 50000000; 
signal contador: natural := 0;
signal tiempo: natural := 0; -- En segundos
signal tiempo_restante: natural :=0;
type cafe is (corto, largo, colacao);
signal tipo_cafe: cafe:=corto;
type leche is (entera, semi, desnatada, nada1);
signal tipo_leche: leche:=nada1;
signal nivel_comp: integer range 0 to 4 :=2;--CAMBIADO
type complemento is (azucar,sacarina, colacao, nada2);
signal tipo_complemento: complemento:=azucar;

begin		
clock: process(clk) -- Actualizamos el estado en función del reloj.
			begin
			if (clk'event and clk='1') then
				estado_actual <= estado_siguiente;
			end if;
			end process;
			
Estados: process(clk) -- Definimos los sucesos de cada estado.
		begin
			if clk='1' and clk'event then
			case estado_actual is
				when E0 => -- Estado inicial o de reposo.
						 -- Empieza a contar el tiempo, va sumando al contador en microsegundos y cuando es mayor que 50000000 suma uno al tiempo en segundos.
							contador<= contador+1;
							if contador >= second then --mayor que
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Pulsando cualquier botón salimos del estado de reposo, pasando al estado 1.
						
						if boton/="0000" then estado_siguiente<=E1;-- La cafetera está en reposo, pero si se pulsa cualquiera de los botones pasamos al estado siguiente.
							contador<=0; tiempo<=0;
						end if;
						
				when E1 => -- Selección del tipo de café.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- El usuario puede elegir Café corto, Café largo o Colacao, en función del boton que pulsado elegirá un producto u otro.
						if boton="1000" then tipo_cafe<= corto;
								estado_siguiente<=E2; contador<=0; tiempo<=0;--Se ha elegido corto, pasamos al estado siguiente (2) para echarlo e inicializamos el contador y el tiempo a cero. 
						elsif boton="0100" then tipo_cafe<= largo;
								estado_siguiente<=E2; contador<=0; tiempo<=0;--Se ha elegido largo, pasamos al estado siguiente (2) para echarlo e inicializamos el contador y el tiempo a cero. 
						elsif boton="0001" then tipo_cafe<= colacao;
								estado_siguiente<=E3; contador<=0; tiempo<=0;--Se ha elegido colacao, pasamos al estado tres para echar la leche e inicializamos el contador y el tiempo a cero. 		
						elsif tiempo >= t_e1_reset then
								estado_siguiente<=E0; contador<=0; tiempo<=0;--Si no pulsamos ningún boton al cabo de un tiemo volverá al reposo
						end if;
						
				when E2=> -- Cuenta atrás y proceso del café.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Una vez elegido el producto si es café corto o largo se procede a esperar el tiempo designado para echarlo y si es colacao se ha pasado directamente al estado 3.
						
						if tipo_cafe=corto then
								tiempo_restante<= t_e2_corto - tiempo;--Al tiempo designado para echar el cafe corto le restamos el tiempo que lleva echandose, obteniendo el tiempo restante que utilizaremos mas adelante para hacer una cuenta atrás.
						elsif tipo_cafe=largo then
								tiempo_restante<= t_e2_largo -tiempo;--Al tiempo designado para echar el cafe largo le restamos el tiempo que lleva echandose, obteniendo el tiempo restante que utilizaremos mas adelante para hacer una cuenta atrás.
						end if;
						if tipo_cafe=corto and tiempo >= t_e2_corto then-- Comparamos el tiempo que lleva echandose el café con el tiempo designado, si es mayor o igual pasamos al estado siguiente e inicializamos el contador y el tiempo a cero.
								estado_siguiente<=E3; contador<=0; tiempo<=0; 
						elsif tipo_cafe=largo and tiempo >= t_e2_largo then-- Comparamos el tiempo que lleva echandose el café con el tiempo designado, si es mayor o igual pasamos al estado siguiente e inicializamos el contador y el tiempo a cero.
								estado_siguiente<=E3; contador<=0; tiempo<=0; 
						elsif tiempo >= t_e1_reset then
								estado_siguiente<=E0; contador<=0; tiempo<=0;--Si no pulsamos ningún boton al cabo de un tiemo volverá al reposo
						end if;
						
				when E3 => -- Selección del tipo de leche.   
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- El usuario puede elegir entre leche entera, semidesnatada, desnatada o sin leche en función del boton que pulse.
						if boton="1000" then tipo_leche<= entera;
								estado_siguiente<=E4; contador<=0; tiempo<=0;--Se ha elegido leche entera, pasamos al estado siguiente (4) para echarla e inicializamos el contador y el tiempo a cero.
						elsif boton="0100" then tipo_leche<= semi;
								estado_siguiente<=E4; contador<=0; tiempo<=0;--Se ha elegido leche semidesnatada, pasamos al estado siguiente (4) para echarla e inicializamos el contador y el tiempo a cero.
						elsif boton="0010" then tipo_leche<= desnatada;
								estado_siguiente<=E4; contador<=0; tiempo<=0;--Se ha elegido leche desnatada, pasamos al estado siguiente (4) para echarla e inicializamos el contador y el tiempo a cero.
						elsif boton="0001" then tipo_leche<= nada1;
								estado_siguiente<=E5; contador<=0; tiempo<=0;--Se ha elegido nada, pasamos directamente al estado 5 para la elección de un complemento e inicializamos el contador y el tiempo a cero.
						elsif tiempo >= t_e1_reset then
								estado_siguiente<=E0; contador<=0; tiempo<=0;--Si no pulsamos ningún boton al cabo de un tiemo volverá al reposo
						end if;
						
				when E4 => -- Cuenta atrás y proceso de la leche.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- Espera el tiempo para la leche.
						
						if tipo_leche=entera then tiempo_restante<= t_e4_leche - tiempo;-- Al tiempo designado para echar la leche le restamos el tiempo actual, obteniendo el tiempo restante que utilizaremos mas tarde para hacer una cuenta atrás.
						elsif tipo_leche=semi then tiempo_restante<= t_e4_leche - tiempo;-- Al tiempo designado para echar la leche le restamos el tiempo actual, obteniendo el tiempo restante que utilizaremos mas tarde para hacer una cuenta atrás.
						elsif tipo_leche=desnatada then tiempo_restante<= t_e4_leche - tiempo;-- Al tiempo designado para echar la leche le restamos el tiempo actual, obteniendo el tiempo restante que utilizaremos mas tarde para hacer una cuenta atrás.
						end if;
						
						if tipo_leche=entera and tiempo >= t_e4_leche then -- Si el tiempo que lleva echandose la leche es mayor o igual que el tiempo designado, pasamos al estado siguiente e inicializamos el tiempo y el contador a cero.
								estado_siguiente<=E5; contador<=0; tiempo<=0;
						elsif tipo_leche=semi and tiempo >= t_e4_leche then -- Si el tiempo que lleva echandose la leche es mayor o igual que el tiempo designado, pasamos al estado siguiente e inicializamos el tiempo y el contador a cero.
								estado_siguiente<=E5; contador<=0; tiempo<=0;
						elsif tipo_leche=desnatada and tiempo >= t_e4_leche then -- Si el tiempo que lleva echandose la leche es mayor o igual que el tiempo designado, pasamos al estado siguiente e inicializamos el tiempo y el contador a cero.
								estado_siguiente<=E5; contador<=0; tiempo<=0;
						elsif tiempo >= t_e1_reset then
								estado_siguiente<=E0; contador<=0; tiempo<=0;--Si no pulsamos ningún boton al cabo de un tiemo volverá al reposo
						end if;
						
				when E5 => -- Selección del tipo de complemento.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- El usuario tiene la opción de elegir azucar, sacarina, colacao o nada, en función del boton que pulse.
						if boton="1000" then tipo_complemento<= azucar; -- Se ha elegido azucar, pasamos al estado siguiente e inicializamos el tiempo y el contador a cero.
								estado_siguiente<=E6; contador<=0; tiempo<=0;
						elsif boton="0100" then tipo_complemento<= sacarina; -- Se ha elegido sacarina, pasamos al estado siguiente e inicializamos el tiempo y el contador a cero.
								estado_siguiente<=E6; contador<=0; tiempo<=0;
						elsif boton="0010" then tipo_complemento<= colacao; -- Se ha elegido colacao, pasamos al estado siguiente e inicializamos el tiempo y el contador a cero.
								estado_siguiente<=E6; contador<=0; tiempo<=0;
						elsif boton="0001" then tipo_complemento<= nada2;-- Se ha elegido nada, volvemos al estado inicial de reposo e inicializamos el tiempo y el contador a cero.
								estado_siguiente<=E7; contador<=0; tiempo<=0;
						elsif tiempo >= t_e1_reset then
								estado_siguiente<=E0; contador<=0; tiempo<=0;--Si no pulsamos ningún boton al cabo de un tiemo volverá al reposo
						end if;
						
				when E6 => -- Selección de la cantidad de complemento que se desea en la bebida.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
						-- El usuario puede elegir cuatro niveles distintos de complemento para su bebida en función del boton que pulse.
						if boton="1000" then nivel_comp<=1; estado_siguiente<=E7; contador<=0; tiempo<=0; --Se ha elegido el nivel 1, volvemos al estado inicial de reposo e inicializamos el tiempo y el contador a cero.
						elsif boton="0100" then nivel_comp<=2; estado_siguiente<=E7; contador<=0; tiempo<=0; --Se ha elegido el nivel 2, volvemos al estado inicial de reposo e inicializamos el tiempo y el contador a cero.
						elsif boton="0010" then nivel_comp<=3;estado_siguiente<=E7; contador<=0; tiempo<=0; --Se ha elegido el nivel 3, volvemos al estado inicial de reposo e inicializamos el tiempo y el contador a cero.
						elsif boton="0001" then nivel_comp<=4;estado_siguiente<=E7; contador<=0; tiempo<=0; --Se ha elegido el nivel 4, volvemos al estado inicial de reposo e inicializamos el tiempo y el contador a cero.
						elsif tiempo >= t_e1_reset then
								estado_siguiente<=E0; contador<=0; tiempo<=0;--Si no pulsamos ningún boton al cabo de un tiemo volverá al reposo
						end if;
				when E7 => -- Selección del tipo de café.
							contador<= contador+1;
							if contador >= second then 
								tiempo<=tiempo + 1;
								contador<=0;
							end if;
							if tiempo >= t_e1_reset then
								estado_siguiente<=E0; contador<=0; tiempo<=0;--Si no pulsamos ningún boton al cabo de un tiemo volverá al reposo
						end if;
				end case;
			end if;			
		end process;
	
displays: process(clk) -- En función del estado en el que nos encontremos los displays mostraran un mensaje u otro.
	begin
		if clk'event and clk='1' then
		case estado_actual is
			when E0 => led<="00000000";  -- En el estado de reposo la cafetera mostrará al usuario un mensaje de bienvenida.
							 display1<= "10001001"; --H
							 display2<= "11000000"; --O
							 display3<= "11000111"; --L
							 display4<= "10001000"; --A
							 
			when E1 => led<="00000001";  -- Para hacer la elección de la bebida se mostrarán las siguientes opciones.
					         display1<= "11000110"; --C (Para el café corto)
					         display2<= "11000111"; --L (Para el cafe largo)
					         display3<= "11111111"; --apagado
					         display4<= "11000000"; --O (Para el colacao)
							
			when E2 => led<="00000011";  -- En este estado se procederá a echar el café corto o el largo, así que el primer display mostrará el producto elegido, el segundo un guion y los dos ultimos una cuenta atrás del tiempo restante del proceso.
							case tipo_cafe is
								when corto => display1<="11000110"; --C
								when others => display1<="11000111"; --L
							end case;
							
							display2<="10111111";-- '-'
							
							case tiempo_restante is --El display 3 se encargará de mostrar las decenas.
								when 0 to 9 =>display3<="11000000"; -- Entre 0 y 9 el display3 mostrará un 0.
								when 10 to 19 =>display3<="11111001"; --Entre 10 y 19 el display 3 mostrará un 1.
								when 20=> display3<="10100100"; -- En 20 mostrará un 2.
								when others => display3<= "01111111";
							end case;
							
							case tiempo_restante is -- El display 4 se encargará de mostrar las unidades.
								when 0 | 10 | 20 =>display4<= "11000000"; -- En 0, 10 o 20 mostrará in 0.
								when 1 | 11 =>display4<= "11111001"; -- En 1 o 11 mostrará un 1.
								when 2 | 12 =>display4<= "10100100"; --En 2 o 12 mostrará un 2.
								when 3 | 13 =>display4<= "10110000"; --En 3 o 13 mostrará un 3.
								when 4 | 14 =>display4<= "10011001"; -- En 4 o 14 mostrará un 4.
								when 5 | 15 =>display4<= "10010010"; -- En 5 o 15 mostrará in 5.
								when 6 | 16 =>display4<= "10000010"; -- En 6 o 16 mostrará un 6
								when 7 | 17 =>display4<= "11111000"; -- En 7 o 17 mostrará un 7.
								when 8 | 18 =>display4<= "10000000"; -- En 8 o 18 mostrará un 8.
								when 9 | 19 =>display4<= "10011000"; -- En 9 o 19 mostrará un 9-
								when others =>display4<= "01111111";  
							end case;
							
			when E3 => led<="00000100";  -- En este estado el usuario elige el tipo de leche así que el los dispalys se muestran las dustintas opciónes.
					         display1<= "10000110"; --E (Leche entera).
					         display2<= "10010010"; --S (Leche semidesnatada).
					         display3<= "10100001"; --d (Leche desnatada).
					         display4<= "10111111"; -- '-' (Nada).
							
			when E4 => led<="00001100";  -- En este estado se procede a echar la leche, así que el primer display muestra la leche elegida y en el resto una cuenta atrás del tiempo que tarde en hacer ese proceso.
							display2<="10111111"; -- El display 2 muestra un guion
							case tipo_leche is
								when entera =>
									 display1<= "10000110";	--E (entera).
								when semi =>
									 display1<= "10010010"; --S (Semidesnatada).	
								when desnatada =>
									 display1<= "10100001";	--d (desnatada).
							    when others =>
									 display1<= "10111111"; -- guion
							end case;
							display3<="10111111"; -- El display tres muestra un guion
							case tiempo_restante is
								when 0 	=>display4<= "11000000"; -- Muestra un 0.
								when 1  =>display4<= "11111001";-- Muestra un 1.
								when 2  =>display4<= "10100100";-- Muestra un 2.
								when 3  =>display4<= "10110000";-- Muestra un 3.
								when 4  =>display4<= "10011001";-- Muestra un 4.
								when 5 	=>display4<= "10010010";-- Muestra un 5.
								when others =>display4<= "01111111";
							end case;
			when E5 => led<="00010000";  -- El usuario puede elegir dustintos complementos, así que en la pantalla le aparecen las distintas opciones.
							display1<= "10001000"; --A (azucar).
							display2<= "10010010"; --S (sacarina).
							display3<= "11000000"; --O (colacao).
							display4<= "10111111"; -- '-' (nada).
							
			when E6 => led<="00100000";  -- El usuario puede elegir distintas intensidades para el complemento elegido anteriormente.
							display1<= "11111001"; -- Intensidad 1.
							display2<= "10100100"; -- Intensidad 2.
							display3<= "10110000"; -- Intensidad 3.
							display4<= "10011001"; -- Intensidad 4.
			
			when E7 => led<="11111111";
			                display1<="11000110";
			                display2<="11000000";
			                display3<="11000000";
			                display4<="11000111";
		end case;
		end if;
	end process;
	
		
end Behavioral;
