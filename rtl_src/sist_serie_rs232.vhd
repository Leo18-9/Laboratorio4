--Descripcion	: Sistema de alto nivel que se encarga de interconectar los
--					  componentes y hacer posible la transmision de los mensajes
--					  almacenados dentro de las memorias ROM, a traves de un 
--					  transmisor serie RS-232
				  
------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.pack_232.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity sist_serie_rs232 is
	port(	clk_50, reset_asin, inicio: in std_logic;
			sel_msj, sel_frec: in std_logic_vector(1 downto 0);
			sal_serie, transm_act: out std_logic;
			num_msj: out std_logic_vector(6 downto 0));
end sist_serie_rs232;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of sist_serie_rs232 is
------- Declaracion de las señales internas ----------------
	signal clk: std_logic;
	signal reset_sin_50, reset_sin: std_logic;
	signal sel_frec_ant, sel_msj_ant: std_logic_vector(1 downto 0);
	signal inicio_sinc: std_logic;
	signal en_cont_dir, en_rom_inf, en_rom_inst, sel_rom_dir, ini_transm: std_logic;
	signal cont_fin, transm_activa: std_logic;
	signal direccion: std_logic_vector(6 downto 0);
	signal dato_inf, dato_inst, dato: std_logic_vector(7 downto 0);
	signal bin_msj, bin_msj_2: std_logic_vector(3 downto 0);
begin
	
	bin_msj_2 <= "00"&sel_msj;
------- Instanciacion de los componentes necesarios --------
	---- Componentes de control de la frecuencia de trabajo -
	U1: entity work.reset port map(clk => clk_50, rst => reset_asin, rst_a_s => reset_sin_50);
	U2: entity work.fsm_antirebote_50 port map(clk_50 => clk_50, rst => reset_sin_50, ent => sel_frec(0), sal => sel_frec_ant(0));
	U3: entity work.fsm_antirebote_50 port map(clk_50 => clk_50, rst => reset_sin_50, ent => sel_frec(1), sal => sel_frec_ant(1));
	U4: entity work.div_frec port map(clk_50 => clk_50, sel => sel_frec_ant, clk_sel => clk, reset => reset_sin_50);
	
	---- Componentes de entrada a la FSM principal ----------
	U5: entity work.reset port map(clk => clk, rst => reset_asin, rst_a_s => reset_sin);
	U6: entity work.fsm_antirebote port map(clk => clk, sel => sel_frec_ant, rst => reset_sin, ent => sel_msj(0), sal => sel_msj_ant(0));
	U7: entity work.fsm_antirebote port map(clk => clk, sel => sel_frec_ant, rst => reset_sin, ent => sel_msj(1), sal => sel_msj_ant(1));
	U8: entity work.Sincro port map(CLK => clk, RST => reset_sin, D => inicio, Q => inicio_sinc);
	
	---- Componentes de Control de la eleccion de los -------
	---- mensajes e inicio de la transmision ----------------
	U9: entity work.fsm_control port map(clk => clk, sel_msj => sel_msj_ant, reset => reset_sin, 
			inicio => inicio_sinc, fin_cont => cont_fin, en_cont => en_cont_dir, en_rom_inf => en_rom_inf,
			en_rom_inst => en_rom_inst, sel_rom => sel_rom_dir, ini_tx => ini_transm,
			bcd_msj => bin_msj, tx_activa => transm_activa);
	U10: entity work.cont_dir port map(clk => clk, res => reset_sin, enable => en_cont_dir, sel => sel_msj_ant, fin_datos => cont_fin, dir => direccion);
	U11: entity work.decoBCD7seg port map(ent => bin_msj_2,leds => num_msj);
	
	---- Componentes encargados de entregar los mensajes ----
	---- a transmitir ---------------------------------------
	U12: entity work.rom_inf port map(clk => clk, en_mem => en_rom_inf, dir => direccion, dato => dato_inf);
	U13: entity work.rom_inst_rs_232 port map(clock => clk, rden => en_rom_inst, address => direccion, q => dato_inst);
	U14: entity work.mux_rom port map(sel => sel_rom_dir, ent_1 => dato_inf, ent_2 => dato_inst, sal_mux => dato);
	
	---- Componente encargado de la transmision serie -------
	---- usando el protocolo RS-232 -------------------------
	U15: entity work.fsm_rs_232 port map(clk => clk, datos_in => dato, reset => reset_sin,
		ini_tx => ini_transm, tx_serie => sal_serie, tx_activa => transm_activa);
	transm_act <= transm_activa;
	
end beh;