-- Descripcion: Simulacion funcional del Divisor de Frecuencia por medio de
-- 				 un Test Bench

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Declaracion de Entidad (Vacia)
------------------------------------------------------------
entity testbench_div_frec is
end testbench_div_frec;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of testbench_div_frec is
------- Declaracion de señales internas --------------------
	signal test_sel: std_logic_vector(1 downto 0);
	signal test_reset: std_logic;
	signal test_clk_50: std_logic := '0';
	signal test_clk_sel: std_logic;
begin

------ Instanciacion del Divisor de Frecuencia -------------
	U: entity work.div_frec port map(clk_50 => test_clk_50, sel => test_sel, clk_sel => test_clk_sel, reset => test_reset);
	
------ Generacion de Señales de simulacion -----------------
	test_clk_50 <= not test_clk_50 after 10ns;
	test_sel <= "00","01" after 500us, "10" after 1000us, "11" after 100us;
	test_reset <= '0', '1' after 100ns;
end beh;