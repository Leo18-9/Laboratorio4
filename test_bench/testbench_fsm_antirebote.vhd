-- Descripcion: Simulacion funcional de la maquina de estado del
-- 				 circuito antirebote por medio de un Test Bench

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
entity testbench_fsm_antirebote is
end testbench_fsm_antirebote;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of testbench_fsm_antirebote is
------- Declaracion de señales internas --------------------
	signal test_sel: std_logic_vector(1 downto 0);
	signal test_rst: std_logic := '1';
	signal test_ent: std_logic := '0';
	signal test_clk: std_logic := '0';
	signal test_sal: std_logic;
begin

------ Instanciacion del circuito antirebote ---------------
	U: entity work.fsm_antirebote port map(clk => test_clk, sel => test_sel, rst => test_rst, ent => test_ent, sal => test_sal);
	
------ Generacion de Señales de simulacion -----------------
	test_clk <= not test_clk after 52us;
	test_sel <= "01";
	test_rst <= '0', '1' after 200us;
	----------- Proceso que simula los rebotes --------------
	----------- en la entrada -------------------------------
	process
	begin
		wait for 500us;
		for i in 0 to 100 loop
			test_ent <= not(test_ent);
			wait for 200us;
		end loop;
		wait for 1us;
		test_ent <= '0';
		wait for 10000us;
		test_ent <= '1';
		for i in 0 to 100 loop
			test_ent <= not(test_ent);
			wait for 200us;
		end loop;
		wait for 1us;
		test_ent <= '1';
		wait;
	end process;
end beh;