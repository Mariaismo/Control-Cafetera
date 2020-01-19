LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY cafetera_tb IS -- Definimos la entidad del testbench sin añadir ningún puerto.
END cafetera_tb;
 
ARCHITECTURE behavioral OF cafetera_tb IS 
 
    COMPONENT cafetera -- Declaramos como un componente el circuito de la cafetera que vamos a implementar, como entradas tendremos el boton y el reloj, y como salidas los cuatro displays y el led.
    PORT(
         clk : IN  std_logic; 
         boton : IN  std_logic_vector(3 downto 0); -- Vector de 4 (Utilizaremos 4 botones).
         display1 : OUT  std_logic_vector(7 downto 0); -- Vector de 8 (Utilizaremos los displays de 7 segmentos).
         display2 : OUT  std_logic_vector(7 downto 0);
         display3 : OUT  std_logic_vector(7 downto 0);
         display4 : OUT  std_logic_vector(7 downto 0);
         led : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
-- Declaramos una señal por cada puerto del componente.
   signal clk : std_logic := '0'; -- Le asignamos el valor 0 por defecto.
   signal btn : std_logic_vector(3 downto 0) := (others => '0');


   signal display1 : std_logic_vector(7 downto 0);
   signal display2 : std_logic_vector(7 downto 0);
   signal display3 : std_logic_vector(7 downto 0);
   signal display4 : std_logic_vector(7 downto 0);
   signal led : std_logic_vector(7 downto 0);
 
BEGIN
 -- Realizamos la instanciación, conectando los puertos a las señales correspondientes.
   uut: cafetera PORT MAP ( 
          clk => clk,
          boton => btn,
          display1 => display1,
          display2 => display2,
          display3 => display3,
          display4 => display4,
          led => led
        );

   clk_process :process -- Genera un pulso cada 10 ns.
   begin
		clk <= '0';
		wait for 5ns; -- El reloj se mantiene en 0 hasta que pasa la mitad del periodo (5 ns).
		clk <= '1';
		wait for 5ns; -- El reloj se mantiene en 1 hasta que pasa la mitad del periodo (5 ns).
   end process;
 -- Generamos los estímulos.
   stim_proc: process
   begin		

      wait for 100 ns;	
      wait for 100ns;
	  btn<="0001";
	  wait for 50 ns;
	  btn<="0000";

      wait;
   end process;

END;
