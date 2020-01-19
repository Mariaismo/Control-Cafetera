LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY display_tb IS
END display_tb;
 
ARCHITECTURE behavioral OF display_tb IS 
 
    COMPONENT display
    PORT(
         display1 : IN  std_logic_vector(7 downto 0);
         display2 : IN  std_logic_vector(7 downto 0);
         display3 : IN  std_logic_vector(7 downto 0);
         display4 : IN  std_logic_vector(7 downto 0);
         clk : IN  std_logic;
         imagen : OUT  std_logic_vector(7 downto 0);
         num_display : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
   signal display1 : std_logic_vector(7 downto 0) := (others => '0');
   signal display2 : std_logic_vector(7 downto 0) := (others => '0');
   signal display3 : std_logic_vector(7 downto 0) := (others => '0');
   signal display4 : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';

   signal imagen : std_logic_vector(7 downto 0);
   signal num_display : std_logic_vector(3 downto 0);

 
BEGIN
 
   uut: display PORT MAP (
          display1 => display1,
          display2 => display2,
          display3 => display3,
          display4 => display4,
          clk => clk,
          imagen => imagen,
          num_display => num_display
        );

   clk_process :process
   begin
		clk <= '0';
		wait for 10ns;
		clk <= '1';
		wait for 10ns;
   end process;
 
   stim_proc: process
   begin		

		wait for 50 ns;
		display1<= "10001001"; --H
		display2<= "11000000"; --O
		display3<= "11000111"; --L
		display4<= "10001000"; --A

      wait;
   end process;

END;