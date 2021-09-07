--Descripcion	: circuito de reset activo asincronicamente y desactivado
--					  sincronicamente. El circuito es controlado por flanco
--					  positivo del clock.
--					  Se usa un reset activado asincronicamente para evitar problemas con 
--					  registros que funionan con distintos clocks. Mientras que la desactivacion
--					  sincronica se utiliza para evitar la violacion de los tiempos de
--					  recuperacion y remocion.

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity reset is
------ Generic que indica la cantidad de flip flop ---------
------ internos y su valor de activacion -------------------
	generic(rst_width:integer := 2;					
			  rst_active_value:std_logic := '0');
	port( clk : in std_logic;
			rst : in std_logic;
			rst_a_s: out std_logic);
end entity reset;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture rst_beh of reset is
------- Declaracion de señales internas --------------------
	signal rst_i: std_logic_vector(rst_width downto 0);  
begin

------- Proceso que describe el reset activado de ----------
------- de forma asincronica y desactivado de forma --------
------- sincronica -----------------------------------------																	  
	process(rst, clk) 
	begin
	---- Recepcion del reset de forma asincronica -----------
	if (rst = rst_active_value) then 				
		rst_i <= (others => rst_active_value); 
		rst_a_s <= '0'; 
	---- Al recibir un flanco positivo del reloj se ---------
	---- desactiva el reset de forma sincronica, ------------
	---- manteniendo el valor de salida de los f-f ----------
	---- en el valor del rst desactivado --------------------
	elsif (rising_edge(clk)) then 					
		rst_i(0) <= not rst_active_value; 			
		for i in 0 to rst_width-1 loop 				
			rst_i(i+1) <= rst_i(i); 					
		end loop; 
	end if; 
	---- Asignacion del valor de salida ---------------------
		rst_a_s <= rst_i(rst_width-1);				 
	end process; 
end rst_beh;