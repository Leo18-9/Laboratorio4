--Descripcion	: Contador simple que entrega las direcciones de los datos
--					  almacenados en memorias ROM e indica cuando se han enviado
--					  todos los datos (direcciones).
				  
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
entity cont_dir is
	-------- Generic que define las direcciones -------------
	-------- iniciales y finales de cada uno de -------------
	-------- los mensajes -----------------------------------
	generic( ancho_cont: natural := 7;
				ini_msj1: std_logic_vector := "0000000";
				fin_msj1: std_logic_vector := "0101110";
				ini_msj2: std_logic_vector := "0110000";
				fin_msj2: std_logic_vector := "1001011";
				ini_msj3: std_logic_vector := "0000000";
				fin_msj3: std_logic_vector := "0001111";
				ini_msj4: std_logic_vector := "0001111";
				fin_msj4: std_logic_vector := "0101110");
	port( enable, res, clk: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			dir: out std_logic_vector(ancho_cont-1 downto 0);
			fin_datos: out std_logic);
end cont_dir;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of cont_dir is
------- Declaracion de las señales internas ----------------
	signal primer_dato: std_logic;
begin
	
	-------- Proceso del Contador Simple --------------------
	cont_proc: process(clk, res, enable)
		variable ini, fin, max_cont: std_logic_vector(ancho_cont-1 downto 0) := "1111111";
		variable cont: unsigned(ancho_cont-1 downto 0);
		constant ref: std_logic_vector(ancho_cont-1 downto 0) := "1111111";
	begin
		

		if(rising_edge(clk)) then
			if(res = '0') then
				cont := unsigned(ini);
				primer_dato <= '0';
			else
			fin_datos <= '0';
			--------- Seleccion del inicio y final del --------
			--------- mensaje a transmitir --------------------
			case sel is
				when "00" =>
					ini := ini_msj1;
					fin := fin_msj1;
				when "01" =>
					ini := ini_msj2;
					fin := fin_msj2;
				when "10" =>
					ini := ini_msj3;
					fin := fin_msj3;
				when others =>
					ini := ini_msj4;
					fin := fin_msj4;
			end case;
			 
			if(enable = '1') then
			---------- Primer enable establece el inicio ---------
			---------- del mensaje de la salida ------------------
				if(primer_dato = '0') then
					cont:= unsigned(ini);
					max_cont := fin;
					primer_dato <= '1';
				else
					cont := cont + 1;
					if(std_logic_vector(cont) >= max_cont) then
						fin_datos <= '1';
						primer_dato <= '0';
						cont := unsigned(ref);
					end if;
				end if;
			end if;
			end if;
		end if;
-------- Asignacion del valor de salida -----------------------
		dir <= std_logic_vector(cont);
		
	end process cont_proc;
end beh;