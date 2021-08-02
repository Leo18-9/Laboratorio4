-- Descripcion: Simulacion funcional de la maquina de estado del
--					transmisor serie RS-232 por medio de un Test Bench

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
entity testbench_fsm_rs_232 is
end testbench_fsm_rs_232;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of testbench_fsm_rs_232 is
------- Declaracion de señales internas --------------------
	signal test_datos_in: std_logic_vector(7 downto 0);
	signal test_reset: std_logic := '1';
	signal test_clk: std_logic := '0';
	signal test_ini_tx: std_logic := '0';
	signal test_tx_serie, test_tx_activa: std_logic;
begin

------ Instanciacion del Transmisor RS-232 -----------------
	U: entity work.fsm_rs_232 port map(clk => test_clk, datos_in => test_datos_in, reset => test_reset,
		ini_tx => test_ini_tx, tx_serie => test_tx_serie, tx_activa => test_tx_activa);
	
------ Generacion de Señales de simulacion -----------------
	test_clk <= not test_clk after 52us;
	test_datos_in <= "00010111", "11100110" after 1000us;
	test_reset <= '0', '1' after 200us;
	test_ini_tx <= '0', '1' after 400us, '0' after 500us, '1' after 3100us, '0' after 3300us;
	
end beh;