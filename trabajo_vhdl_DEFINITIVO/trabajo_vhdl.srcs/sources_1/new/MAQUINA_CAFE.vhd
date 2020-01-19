library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAQUINA_CAFE is
Port ( clk : in  STD_LOGIC;
       boton_placa : in  STD_LOGIC_VECTOR (3 downto 0);
       control_segmentos : out  STD_LOGIC_VECTOR (7 downto 0);
       control_displays : out  STD_LOGIC_VECTOR (3 downto 0);
       led : out  STD_LOGIC_VECTOR (7 downto 0)
	  );
end MAQUINA_CAFE;

architecture Behavioral of MAQUINA_CAFE is

component filtro is
		generic(n: integer range 0 to 2**5-1 := 8);
		port(	entrada: in std_logic_vector(n - 1 downto 0);
				clk: in std_logic;
				salida: out std_logic_vector(n - 1 downto 0)
		);
	end component;
	
component cafetera
	port(
		clk : IN std_logic;
		boton : IN std_logic_vector(3 downto 0);          
		display1 : OUT std_logic_vector(7 downto 0);
		display2 : OUT std_logic_vector(7 downto 0);
		display3 : OUT std_logic_vector(7 downto 0);
		display4 : OUT std_logic_vector(7 downto 0);
		led : OUT std_logic_vector(7 downto 0)
		
		);
	end component;	
	
component display
	port(
		display1 : IN std_logic_vector(7 downto 0);
		display2 : IN std_logic_vector(7 downto 0);
		display3 : IN std_logic_vector(7 downto 0);
		display4 : IN std_logic_vector(7 downto 0);
		clk : IN std_logic;          
		imagen : OUT std_logic_vector(7 downto 0);
		num_display : OUT std_logic_vector(3 downto 0)
		);
	end component;
	
signal boton_filtrado: std_logic_vector(3 downto 0);
signal display1,display2,display3,display4: std_logic_vector(7 downto 0);
	
begin

Comp_filtro: filtro
		generic map(n=>4)
		port map(
			entrada => boton_placa,
			clk => clk,
			salida =>boton_filtrado
	);
	
Comp_Estado_cafetera: cafetera port map(
		clk => clk,
		boton => boton_filtrado,
		display1 => display1,
		display2 => display2,
		display3 => display3,
		display4 => display4,
		led => led
		
	);
	
Comp_display: display port map(
		display1 => display1,
		display2 => display2,
		display3 => display3,
		display4 => display4,
		clk => clk,
		imagen => control_segmentos,
		num_display => control_displays
	);

end Behavioral;
