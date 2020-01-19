library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display is
	port(	display1,display2,display3,display4: in std_logic_vector(7 downto 0);
			clk: in std_logic;
			imagen: out std_logic_vector(7 downto 0);
			num_display: out std_logic_vector(3 downto 0));
end display;

architecture Behavioral of display is

	component multiplexor_4a1
	generic(n: natural range 1 to 32:=8);
	port(	display_1: in std_logic_vector (n - 1 downto 0);
			display_2: in std_logic_vector (n - 1 downto 0);
			display_3: in std_logic_vector (n - 1 downto 0);
			display_4: in std_logic_vector (n - 1 downto 0);
			estado:	in	std_logic_vector(1 downto 0);
			segmento: out std_logic_vector (n -1 downto 0));
	end component;
	
	COMPONENT decodificador_2a4
	PORT(
		entrada_dec : IN std_logic_vector(1 downto 0);
		rst: IN std_logic;          
		salida_dec : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT clk_dis_state
	PORT(
		clk_div : IN std_logic;          
		salida_estado : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT divisor_reloj
		generic (max: natural:= 10);
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		clk_dividido : OUT std_logic
		);
	END COMPONENT;
		
for all: multiplexor_4a1 use entity work.multiplexor_4a1(Behavioral);
for all: decodificador_2a4 use entity work.decodificador_2a4(Behavioral);
for all: divisor_reloj use entity work.divisor_reloj(Behavioral);
for all: clk_dis_state use entity work.clk_dis_state(Behavioral);
	


signal estado_int: std_logic_vector(1 downto 0);
signal clk_div_int: std_logic;
begin
--INSTANCIACIÓN
C_multiplexor_4a1: multiplexor_4a1 PORT MAP(-- 3º.
		display_1 => display1,
		display_2 => display2,
		display_3 => display3,
		display_4 => display4,
		estado => estado_int,
		segmento => imagen
	); 

C_decodificador_2a4: decodificador_2a4 PORT MAP(-- 3º.
		entrada_dec => estado_int,
		rst => '0',
		salida_dec => num_display
	);
	
C_clk_dis_state: clk_dis_state PORT MAP( -- 2º.
		clk_div => clk_div_int,
		salida_estado => estado_int -- (sale 00,01,10,11).
	);
	
C_divisor_reloj: divisor_reloj -- 1º.
	generic map( max => 50000)
	PORT MAP(
		clk => clk,
		reset => '0',
		clk_dividido => clk_div_int
	);


end Behavioral;