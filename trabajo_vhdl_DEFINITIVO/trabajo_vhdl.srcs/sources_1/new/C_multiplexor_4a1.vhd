--mete al display las entradas correspondientes que le llega del cafetera
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity  multiplexor_4a1 is
	generic(n: natural range 1 to 32 :=8);

	port(	display_1: in std_logic_vector (n - 1 downto 0);
			display_2: in std_logic_vector (n - 1 downto 0);
			display_3: in std_logic_vector (n - 1 downto 0);
			display_4: in std_logic_vector (n - 1 downto 0);
			estado: in std_logic_vector(1 downto 0);
			segmento: out std_logic_vector (n - 1 downto 0));

end multiplexor_4a1;

architecture behavioral of multiplexor_4a1 is

	begin
		process(display_1,display_2,display_3,display_4,estado)
		begin
			case estado IS
				when "00" => segmento <= display_1;
				when "01" => segmento <= display_2;
				when "10" => segmento <= display_3;
				when others => segmento <= display_4;
			end case;
		end process;

end behavioral;
