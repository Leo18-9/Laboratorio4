-- Descripcion: Simulacion funcional del Contador de direcciones por medio de
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
entity testbench_cont_dir is
end testbench_cont_dir;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture tb_behave of testbench_cont_dir is
------- Declaracion de señales internas --------------------
	signal test_res: std_logic := '0';
	signal test_enable: std_logic := '0';
	signal test_clk: std_logic := '0';
	signal test_dir: std_logic_vector (6 downto 0);
	signal test_sel: std_logic_vector (1 downto 0);
	signal test_fin_datos: std_logic;
begin

------ Instanciacion del Contador de direcciones -----------
	U: entity work.cont_dir port map(clk => test_clk, res => test_res, enable => test_enable, sel => test_sel, fin_datos => test_fin_datos, dir => test_dir);
	
------ Generacion de Señales de simulacion -----------------
	test_clk <= not test_clk after 52us;
	test_res <= '0', '1' after 100us; --'0' after 2000us, '1' after 2100us;
	test_sel <= "00"; --"01" after 1000us, "10" after 2000us, "11" after 3000us;
	test_enable <= '0', '1' after 504us;

end tb_behave;