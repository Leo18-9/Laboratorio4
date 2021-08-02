--Descripcion	: Conjunto variable de Multiplexores 2 a 1 
				  
------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity mux_rom is
	------ Generic que define la cantidad de ----------------
	------ multiplexers a generar --------------------------
	generic(	largo_dato: natural := 8);
	port(ent_1, ent_2: in std_logic_vector(largo_dato-1 downto 0);
		  sel: in std_logic;
		  sal_mux: out std_logic_vector(largo_dato-1 downto 0));
end mux_rom;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture behav of mux_rom is
begin
	------ Instruccion Concurrente que describe el ----------
	------ comprtamiento de los multiplexers ----------------
	with sel select
		sal_mux <= ent_1 when '0',		--Primera ROM
					  ent_2 when others;	--Segunda ROM
end behav;