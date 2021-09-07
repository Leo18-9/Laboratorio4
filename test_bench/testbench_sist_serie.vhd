-- Descripcion: Simulacion funcional del sistema de comunicacion usando
--					 el protocolo de comunicacion RS-232 por medio de
-- 				 un Test Bench

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Declaracion de Entidad (Vacia)
------------------------------------------------------------
entity testbench_sist_serie is
end testbench_sist_serie;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of testbench_sist_serie is
------- Declaracion de señales internas --------------------
	signal test_sel_msj, test_sel_frec: std_logic_vector(1 downto 0);
	signal test_reset_asin: std_logic := '1';
	signal test_inicio: std_logic := '0';
	signal test_clk_50: std_logic := '0';
	signal test_sal_serie: std_logic;
	signal test_transm_act: std_logic;
	signal test_num_msj: std_logic_vector(6 downto 0);
begin

------ Instanciacion del Sistema de transmision ------------
------ serie completo --------------------------------------
	U: entity work.sist_serie_rs232 port map(clk_50 => test_clk_50, sel_msj => test_sel_msj,
			 sel_frec => test_sel_frec, reset_asin => test_reset_asin, inicio => test_inicio,
			 sal_serie => test_sal_serie, num_msj => test_num_msj, transm_act => test_transm_act);
			 
------ Generacion de Señales de simulacion -----------------
	test_clk_50 <= not test_clk_50 after 10ns;
	test_sel_frec <= "10", "01" after 100000us;
	test_sel_msj <= "00", "10" after 121000us;
	test_inicio <= '1', '0' after 400us, '1' after 800us, '0' after 142000us, '1' after 144000us;
	test_reset_asin <= '0', '1' after 50us;
	
end beh;