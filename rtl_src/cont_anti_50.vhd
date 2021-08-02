--Descripcion	: Contador simple utilizado para contar durante 20ms
--					  para una frecuencia de 50MHz. Salida de un bit 
--					  que indica que termino la temporizacion.
				  
------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Declaracion de Entidad
---------------------------------------------------------
entity cont_anti_50 is
	generic( cont_ancho: natural := 20);
	port(	enable, res, clk: in std_logic;
			act: out std_logic);
end cont_anti_50;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of cont_anti_50 is
------- Declaracion de señales internas --------------------
	signal cont: unsigned(cont_ancho-1 downto 0);
	signal sal_int: std_logic_vector (cont_ancho-1 downto 0);
	signal act_i: std_logic;
begin
	-------- Proceso del Contador Simple -------------
	cont_proc: process(clk, res, enable)
		constant max_cont: std_logic_vector(cont_ancho-1 downto 0) := "11110100001001000000"; --20ms para un reloj de 50MHz
	begin
		if(res = '1') then
			cont <= (others => '0');
		elsif(rising_edge(clk)) then
			act_i <= '0';
			if(enable = '1') then
				cont <= cont + 1;
				if(std_logic_vector(cont) >= max_cont) then
					act_i <= '1';
				end if;
			end if;
		end if;
	end process cont_proc;

act <= act_i;
	
end beh;