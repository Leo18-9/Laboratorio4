-- Descripcion: Simulacion funcional de 8 multiplexer de 2 a 1 por medio de
-- 				 un Test Bench

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity testbench_mux_rom is
end testbench_mux_rom;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------

architecture tb_behave of testbench_mux_rom is
------- Declaracion de señales internas --------------------
	signal test_sel: std_logic;
	signal test_ent_1, test_ent_2: std_logic_vector(7 downto 0);
	signal test_sal_mux: std_logic_vector(7 downto 0);
begin
	
------ Instanciacion del conjunto de multiplexers -------
	UUT: entity work.mux_rom port map(sel => test_sel, ent_1 => test_ent_1, ent_2 => test_ent_2, sal_mux => test_sal_mux);

------ Generacion de Señales de simulacion -----------------
	test_sel <=  '0', '1' after 100ps, '0' after 200ps, '1' after 300ps, '0' after 400ps;
	test_ent_1 <= "00000000", "00010000" after 100ps, "10000000" after 200ps, "00000001" after 300ps, "01000010" after 400ps; 
	test_ent_2 <= "11111111", "11110111" after 100ps, "01111111" after 200ps, "11111110" after 300ps, "11011101" after 400ps;
end tb_behave;