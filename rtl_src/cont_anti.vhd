--Descripcion	: Contador simple utilizado para contar durante 20ms
--					  dependiendo de las frecuencias y entrada de seleccion 
--					  que ingresan. Salida de un bit que indica que termino
--					  la temporizacion.
				  
------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity cont_anti is
	generic( cont_ancho: natural := 12);
	port(	enable, res, clk: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			act: out std_logic);
end cont_anti;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of cont_anti is
------- Declaracion de señales internas --------------------
	signal cont: unsigned(cont_ancho-1 downto 0);
	signal sal_int: std_logic_vector (cont_ancho-1 downto 0);
	signal act_i: std_logic;
begin

	-------- Proceso del Contador Simple -------------
	cont_proc: process(clk, res, enable)
	begin
		if(res = '1') then
			cont <= (others => '0');
		elsif(rising_edge(clk)) then
			if(enable = '1') then
				cont <= cont + 1;
			end if;
		end if;
		sal_int <= std_logic_vector(cont);
	end process cont_proc;
	
	-------- Proceso que elige el maximo valor -------
	-------- del contador para llegar a 20ms ---------
	-------- segun la entrada de seleccion -----------
	sel_proc: process(sel, sal_int)
		constant max_cont1: std_logic_vector(cont_ancho-1 downto 0) := "000001100000"; --4800 baudios
		constant max_cont2: std_logic_vector(cont_ancho-1 downto 0) := "000011000000"; --9600 baudios											
		constant max_cont3: std_logic_vector(cont_ancho-1 downto 0) := "001100000000"; --38400 baudios
		constant max_cont4: std_logic_vector(cont_ancho-1 downto 0) := "100100000000"; --115200 baudios
	begin
		act_i <= '0';
		case sel is
		------------ 4800 baudios --------------
			when "00" => 
				if(sal_int >= max_cont1) then
					act_i <= '1';
				end if;
		------------ 38400 baudios --------------
			when "10" => 
				if(sal_int >= max_cont3) then
					act_i <= '1';
				end if;
		------------ 115200 baudios --------------
			when "11" =>
		   	if(sal_int >= max_cont4) then
					act_i <= '1';
				end if;
		------------ 9600 baudios --------------
			when others =>
				if(sal_int >= max_cont2) then
					act_i <= '1';
				end if;	
		end case;	
	end process sel_proc;

---------- Asignacion del valor de salida ------------
act <= act_i;
	
end beh;