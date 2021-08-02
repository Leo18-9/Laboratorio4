--Descripcion	: Memoria ROM inferida desde el codigo VHDL. Su distribucion es
--					  128 x 8

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity rom_inf is
	------ Generic que define la cantidad de datos ----------
	------ y el largo de los mismos dentro de la ------------
	------ memoria ------------------------------------------
	generic(	largo_dato: natural := 8;
				largo_dir: natural := 7);
	port(	clk, en_mem: in std_logic;
			dir: in std_logic_vector(largo_dir-1 downto 0);
			dato: out std_logic_vector(largo_dato-1 downto 0));
end rom_inf;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of rom_inf is
	--------- Tamaño de la memoria --------------------------
	constant mem_size: natural := 2**largo_dir;
	--------- Tipo que indica el largo de los datos  --------
	type mem_tipo is array(mem_size-1 downto 0) of std_logic_vector(largo_dato-1 downto 0);
	--------- Inicializacion de los valores dentro de -------
	--------- la memoria ROM inferida -----------------------
	constant mem_rom: mem_tipo :=
		(	0 => x"43", 1 => x"75", 2 => x"72", 3 => x"73", 4 => x"6f", 5 => x"20", 6 => x"56", 
			7 => x"48", 8 => x"44", 9 => x"4c", 10 => x"2d", 11 => x"46", 12 => x"50",
			13 => x"47", 14 => x"41", 15 => x"45", 16 => x"6c", 17 => x"20", 18 => x"71", -- 14 => "41" termina el primer msj
			19 => x"75", 20 => x"65", 21 => x"20", 22 => x"61", 23 => x"62", 24 => x"61", 
			25 => x"6e", 26 => x"64", 27 => x"6f", 28 => x"6e",29 => x"61", 30 => x"20",
			31 => x"6e", 32 => x"6f", 33 => x"20", 34 => x"74", 35 => x"69", 36 => x"65",
			37 => x"6e", 38 => x"65", 39 => x"20", 40 => x"70", 41 => x"72", 42 => x"65",
			43 => x"6d", 44 => x"69", 45 => x"6f", others => x"00");
	
	-------- Atributo que fuerzan a que la memoria ----------
	-------- se implemente dentro de los bloques ------------
	-------- dedicados de memoria del FPGA ------------------
	attribute romstyle: string;
	attribute romstyle of mem_rom: constant is "M9K";
begin
	-------- Proceso que describe el funcionamiento ---------
	-------- de la memoria ----------------------------------
	rom_proc: process(clk, en_mem)
	begin
		if(rising_edge(clk)) then
			if(en_mem = '1') then
				dato <= mem_rom(to_integer(unsigned(dir)));
			end if;
		end if;
	end process rom_proc;

end beh;