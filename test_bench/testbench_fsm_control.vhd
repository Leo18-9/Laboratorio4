-- Descripcion: Simulacion funcional de la maquina de estado de
-- 				 control del sistema total de transmision de 
--					 mensajes por medio de un Test Bench

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Declaracion de Entidad (Vacia)
------------------------------------------------------------
entity testbench_fsm_control is
end testbench_fsm_control;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of testbench_fsm_control is
------- Declaracion de señales internas --------------------
	signal test_sel_msj: std_logic_vector(1 downto 0);
	signal test_reset: std_logic := '1';
	signal test_inicio: std_logic := '0';
	signal test_clk: std_logic := '0';
	signal test_fin_cont: std_logic := '0';
	signal test_tx_activa: std_logic := '0';
	signal test_en_cont, test_en_rom_inf, test_en_rom_inst: std_logic;
	signal test_sel_rom, test_ini_tx: std_logic;
	signal test_bcd_msj: std_logic_vector(3 downto 0);
begin

------ Instanciacion de la FSM Controladora de -------------
------ la transmision de mensajes --------------------------
	U: entity work.fsm_control port map(clk => test_clk, sel_msj => test_sel_msj, reset => test_reset, 
			inicio => test_inicio, fin_cont => test_fin_cont, en_cont => test_en_cont, en_rom_inf => test_en_rom_inf,
			en_rom_inst => test_en_rom_inst, sel_rom => test_sel_rom, ini_tx => test_ini_tx,
			bcd_msj => test_bcd_msj, tx_activa => test_tx_activa);
	
------ Generacion de Señales de simulacion -----------------
	test_clk <= not test_clk after 50us;
	test_sel_msj <= "10";
	test_inicio <= '1', '0' after 150us, '1' after 400us;
	test_reset <= '0', '1' after 50us;
	test_fin_cont <= '0', '1' after 1450us, '0' after 1650us;
	test_tx_activa <= '0', '1' after 549us, '0' after 849us, '1' after 1049us, '0' after 1349us;
	
end beh;