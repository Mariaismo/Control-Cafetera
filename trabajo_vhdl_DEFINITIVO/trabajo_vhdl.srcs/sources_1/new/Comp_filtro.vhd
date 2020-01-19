--Conjunto del filtro entero formado por: un divisor de reloj, 4 m�dulos antirrebote y 4 m�dulos de flanco
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity filtro is  --Entradas y salidas del filtro
	generic(n: integer range 0 to 2**5-1 := 8); --Declara un entero "n" con valor inicial 8 
	port(	entrada: in std_logic_vector(n - 1 downto 0);
			clk: in std_logic;
			salida: out std_logic_vector(n - 1 downto 0)
	);
end filtro;

architecture Behavioral of filtro is  --Estructura interna del filtro

component divisor_reloj  --Divisor de reloj (nuevo reloj para disminuir la frecuencia)
	generic(max: integer range 0 to 2**26-1 := 150);  --Entero "max" con valor inicial 10
	port(	clk: in std_logic;  --Entradas de reloj
	        reset: in std_logic;  --Entrada reset
			clk_dividido: out std_logic);  --Salida nuevo reloj
end component;

component antirrebote  --Modulo antirrebote
	port (
 clk_div : in std_logic;  --Entrada reloj dividido (salida del m�dulo anterior)
 reset : in std_logic;  --Entrada reset
 btn_in : in std_logic;  --Entrada pulsaci�n del bot�n
 btn_out : out std_logic);  --Salida bot�n ya estabilizado
end component;

component flanco  --Detector de flanco positivo
	port(
			boton: in std_logic;  --Entradas estado del bot�n (salida del modulo anterior)
			clk: in std_logic;  --Entrada se�al de reloj
			btn_final: out std_logic);  --Salida "btn_final" qaue indica finalmente el estado de cada bot�n, pulsado o no
end component;

for all: antirrebote use entity work.antirrebote(behavioral);
for all: flanco use entity work.flanco(behavioral);
for all: divisor_reloj use entity work.divisor_reloj(behavioral);

signal dividido: std_logic;  --Se�al dividido
signal sin_rebote: std_logic_vector (entrada'range);  --Se�al sin_rebote es un vector de 7 elementos
begin
	C_clk: divisor_reloj --Componente "I_clk" que es del tipo divisor_reloj
		generic map (max=> 500000)  --Al entero max se le asigna 500000 que es el valor de 1 segundo
		port map(  --Asignaci�n de se�ales de entrada y salida
			clk => clk,  --Al puerto clk le asigno la se�al clk
			reset => '0',  --Al puerto "reset" le asigno la se�al 0 (flanco negativo)
			clk_dividido => dividido);  --Al puerto "clk_dividido" le asigno la se�al "dividido"
			
	fil: for i IN entrada'range GENERATE  --Se recorren todas las entradas
	C_antirrebote: antirrebote 
	    port map(  --Asignaci�n de se�ales de entrada y salida
			btn_in => entrada(i),  --A la entrada btn_in del modulo antirrebote le asigno la entrada i
			clk_div=>dividido,  --A la entrada clk_div del modulo antirrebote le asigno la se�al dividido
			reset=> '0',  --Al reset le asigno la se�al "0"
			btn_out => sin_rebote(i));  --A la salida del modulo antirrebote le asigno la se�al sin_rebote correspondiente
			
	C_flanco: flanco 
	    port map(  --Asignaci�n de se�ales de entrada y salida
			boton => sin_rebote(i),  --A la entrada "boton" del flanco le asigno la se�al sin_rebote correpondiente
			clk => clk,  --A la estrada clk del flanco le asigno la se�al "clk" original
			btn_final => salida(i));  --A la salida del flanco le asigno una de las salidas del filtro
			
	end GENERATE;
end Behavioral;
