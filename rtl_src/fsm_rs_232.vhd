--Descripcion	: Maquina de Estados Finitos encargada del control de la transmision
--					  de datos usando el protocolo de comunicacion serie RS-232.
				  
------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.pack_232.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity fsm_rs_232 is
	generic( largo_dato: natural := 8);
	port(	reset, clk, ini_tx: in std_logic;
			datos_in: in std_logic_vector(largo_dato-1 downto 0);
			tx_serie, tx_activa: out std_logic);
end fsm_rs_232;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of fsm_rs_232 is
------- Declaracion del tipo nuevo para --------------------
------- los diferentes estados -----------------------------
	type estados is (reposo, start, desplazamiento, paridad, stop);
	signal siguiente_estado, estado_presente: estados;
------- Declaracion de las señales internas ----------------
	signal fin_shift: std_logic;
begin
	
------------------------------------------------------------
-- Proceso de Estado Presente (Logica Secuencial)
------------------------------------------------------------
	est_pr: process (clk, reset)
	begin
		if(reset = '0') then
			estado_presente <= reposo;
		elsif(rising_edge(clk)) then
			estado_presente <= siguiente_estado;
		end if;
	end process est_pr;

------------------------------------------------------------
-- Proceso de Proximo Estado (Logica Combinacional)
------------------------------------------------------------
	prox_est: process (ini_tx, estado_presente, fin_shift)
	begin
		siguiente_estado <= estado_presente;
		------- Eleccion del proximo estado dependiente ---------
		------- del valor de las entradas -----------------------
		case estado_presente is
			when reposo =>
				if(ini_tx = '1') then
					siguiente_estado <= start;
				end if;
			when start =>
				siguiente_estado <= desplazamiento;
			when desplazamiento =>
				if(fin_shift = '1') then
					siguiente_estado <= paridad;
				end if;
			when paridad =>
				siguiente_estado <= stop;
			when others =>
				siguiente_estado <= reposo;
		end case;
	end process prox_est;
	
------------------------------------------------------------
-- Proceso de Salida (Logica Secuencial)
------------------------------------------------------------
	log_sal: process (clk, reset, datos_in)
		variable cont_shift: unsigned(2 downto 0) := (others => '0');
		constant max_datos: std_logic_vector(2 downto 0) := "111";
		variable datos_buf: std_logic_vector(largo_dato-1 downto 0);
	begin
		if(reset = '0') then
			tx_serie <= '1';
			tx_activa <= '0';
			fin_shift <= '0';
			cont_shift := (others => '0');
		elsif(rising_edge(clk)) then
			fin_shift <= '0';
			tx_serie <= '1';
			tx_activa <= '0';
			case estado_presente is
				when reposo => 
					datos_buf := datos_in;
				------ Transmision del bit de start ------------------
				when start => 
					tx_serie <= '0';
					tx_activa <= '1';
				------ Transmision serie del dato ingresado ----------
				when desplazamiento => 
					tx_activa <= '1';
					tx_serie <= datos_buf(to_integer(cont_shift));
					cont_shift := cont_shift + 1;
					if(std_logic_vector(cont_shift) >= max_datos) then
						fin_shift <= '1';
					end if;
				------ Transmision serie del bit de paridad ----------
				when paridad =>
					tx_activa <= '1';
					tx_serie <= paridad(datos_buf);
				------ Transmision serie del bit de stop -------------
				when others =>
					tx_activa <= '1';
			end case;
		end if;
	end process log_sal;

end beh;