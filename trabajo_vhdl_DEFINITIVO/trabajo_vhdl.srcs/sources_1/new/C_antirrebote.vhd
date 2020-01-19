--Hay un módulo antirrebote para cada botón (4)
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity antirrebote is
 port (
        clk_div : in std_logic;  --Entrada reloj dividido en el módulo divisor_reloj
        reset : in std_logic;  --Entrada reset
        btn_in : in std_logic;  --Entrada pulsación del botón
        btn_out : out std_logic);  --Salida botón ya estabilizado
end antirrebote;

architecture behavioral of antirrebote is

signal temp: std_logic :='0';

begin

btn_out <= temp;

process (clk_div,btn_in,reset)
begin
	if reset = '1' then temp <= '0';
	elsif clk_div = '1' and clk_div'event then 
		temp <= btn_in;
	end if;
end process;

end behavioral;