-- Descripcion: Simulacion funcional del Contador temporizador por medio de
-- 				 un Test Bench

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity testbench_cont_anti is
end testbench_cont_anti;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture tb_behave of testbench_cont_anti is
------- Declaracion de señales internas --------------------
	signal test_res: std_logic := '0';
	signal test_enable: std_logic := '0';
	signal test_clk: std_logic := '0';
	signal test_sel: std_logic_vector(1 downto 0);
	signal test_act: std_logic := '0';
begin

------ Instanciacion del Contador temporizador ---------------------
	U: entity work.cont_anti port map(clk => test_clk, res => test_res, enable => test_enable, sel =>  test_sel, act => test_act);
	
------ Generacion de Señales de simulacion -----------------
	test_clk <= not test_CLK after 4.34us;
	test_res <= '1', '0' after 100us; --'1' after 35000us, '0' after 35100us;
	test_enable <= '0', '1' after 1000us;
	test_sel <= "11";

end tb_behave;