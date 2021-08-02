--Descripcion	: Divisor de frecuencia con entrada de seleccion para elegir entre
--					  las frecuencias 4.8KHz, 9.6KHz, 38.4KHz y 115.2KHz. El mismo se implemento
--					  utilizando un contador simple.					  

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
entity div_frec is
------ Generic que permite seleccionar el largo ------------
------ del contador para obtener la frecuencia -------------
------ deseada ---------------------------------------------
	generic( ancho_cont: natural := 13);   
	port( sel: in std_logic_vector(1 downto 0);
			clk_50: in std_logic;
			reset: in std_logic;
			clk_sel: out std_logic); 
end entity;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of div_frec is
------- Declaracion de señales internas --------------------
	signal clk_sel_i : std_logic := '0';
	signal clk_sel_i2 : std_logic := '0';
	signal cont_int : unsigned (ancho_cont-1 downto 0) := (others => '0');
	signal sal_int : std_logic_vector (ancho_cont-1 downto 0);
	signal rst: std_logic := '0';
begin

------ Proceso del contador simple ----------- 
	cont_proc: process(clk_50, reset)
	begin
		if(reset = '0') then
			cont_int <= (others => '0');
		elsif(rst = '1') then
			cont_int <= (others => '0');
		elsif(rising_edge(clk_50)) then
			cont_int <= cont_int + 1;
		end if;
		sal_int <= std_logic_vector(cont_int);
	end process cont_proc;


------ Proceso que entrega los clocks de 4800Hz ------------
------ 9600Hz 38400Hz 115200Hz -----------------------------
	clks_proc : process(sel, sal_int, clk_sel_i, clk_sel_i2, clk_50)
		constant frec_4800: std_logic_vector(ancho_cont-1 downto 0) := "1010001011000";
		constant frec_9600: std_logic_vector(ancho_cont-1 downto 0) := "0101000101100";
		constant frec_38400: std_logic_vector(ancho_cont-1 downto 0) := "0001010001011";
		constant frec_115200: std_logic_vector(ancho_cont-1 downto 0) := "0000011011001";
	begin
	if(rising_edge(clk_50)) then
		rst <= '0';
	--- Seleccion de la frecuencia del clock de salida ------
		case sel is
		------------------ 4800 baudios ----------------------
		when "00" => 
			if(sal_int >= frec_4800) then
				clk_sel_i2 <= not(clk_sel_i);
				clk_sel_i <= clk_sel_i2;
				rst <= '1';
			end if;
		------------------ 9600 baudios ----------------------
		when "01" =>
			if(sal_int >= frec_9600) then
				clk_sel_i2 <= not(clk_sel_i);
				clk_sel_i <= clk_sel_i2;
				rst <= '1';
			end if;
		------------------ 38400 baudios ---------------------
		when "10" => 
			if(sal_int >= frec_38400) then
				clk_sel_i2 <= not(clk_sel_i);
				clk_sel_i <= clk_sel_i2;
				rst <= '1';
			end if;
		----------------- 115200 baudios ----------------------
		when others => 
			if(sal_int >= frec_115200) then
				clk_sel_i2 <= not(clk_sel_i);
				clk_sel_i <= clk_sel_i2;
				rst <= '1';
			end if;
		end case;
	end if;
	end process clks_proc;
	
------ Asignacion del valor de salida -------------------
	clk_sel <= clk_sel_i;
end beh;