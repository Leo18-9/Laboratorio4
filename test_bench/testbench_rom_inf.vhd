-- Descripcion: Simulacion funcional de la memoria ROM inferida por medio de
-- 				 un Test Bench

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Declaracion de Entidad (Vacia)
------------------------------------------------------------
entity testbench_rom_inf is
end testbench_rom_inf;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of testbench_rom_inf is
------- Declaracion de señales internas --------------------
	signal test_en_mem: std_logic;
	signal test_clk: std_logic := '1';
	signal test_dir: std_logic_vector(6 downto 0);
	signal test_dato: std_logic_vector(7 downto 0);
begin

------ Instanciacion de la Memoria Inferida ----------------
	U: entity work.rom_inf port map(clk => test_clk, en_mem => test_en_mem, dir => test_dir, dato => test_dato);
	
------ Generacion de Señales de simulacion -----------------
	test_clk <= not test_clk after 10us;
	test_en_mem <= '0', '1' after 100us;
	test_dir <= "0000000", "0000001" after 120us, "0000010" after 140us, "0000011" after 160us,
					"0000100" after 180us,  "0000101" after 200us,  "0000110" after 220us,  "0000111" after 240us,
					"0001000" after 260us, "0001001" after 280us, "0001010" after 300us,  "0001011" after 320us,
					"0001100" after 340us, "0001101" after 360us, "0001110" after 380us;
end beh;