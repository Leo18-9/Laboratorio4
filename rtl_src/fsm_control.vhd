--Descripcion	: Maquina de Estados Finitos encargada del control del sistema
--					  de transmision de mensajes almacenados dentro de memorias ROM.
				  
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
entity fsm_control is
 	generic(	largo_dir: natural := 7);
	port(	reset, clk, inicio, fin_cont: in std_logic;
			tx_activa: in std_logic;
			sel_msj: in std_logic_vector(1 downto 0);
			en_cont, en_rom_inf, en_rom_inst: out std_logic;
			sel_rom, ini_tx: out std_logic;
			bcd_msj: out std_logic_vector(3 downto 0));
end fsm_control;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of fsm_control is
------- Declaracion del tipo nuevo para --------------------
------- los diferentes estados -----------------------------
	type estados is (reposo, msj1, msj2, msj3, msj4, transmision);
	signal siguiente_estado, estado_presente: estados;
begin
	
------------------------------------------------------------
-- Proceso de Estado Presente (Logica Secuencial)
------------------------------------------------------------
	est_pr: process (clk, reset, siguiente_estado)
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
	prox_est: process(inicio, estado_presente, sel_msj, fin_cont, tx_activa)
	begin
		siguiente_estado <= estado_presente;
		
		------- Eleccion del proximo estado dependiente ---------
		------- del valor de las entradas -----------------------
		case estado_presente is
			when reposo =>
				if(inicio = '1') then
					siguiente_estado <= reposo;
				else
				------ Seleccion de los estados mensajes ----------
					case sel_msj is
						when "00" =>
							siguiente_estado <= msj1;
						when "01" =>
							siguiente_estado <= msj2;
						when "10" =>
							siguiente_estado <= msj3;
						when others =>
							siguiente_estado <= msj4;
					end case;
				end if;
			------ Logica de los estados mensajes -----------------
			when msj1 =>
					if(tx_activa = '0') then
						siguiente_estado <= transmision;
					end if;
			when msj2 =>
					if(tx_activa = '0') then
						siguiente_estado <= transmision;
					end if;
			when msj3 =>
					if(tx_activa = '0') then
						siguiente_estado <= transmision;
					end if;
			when msj4 =>
					if(tx_activa = '0') then
						siguiente_estado <= transmision;
					end if;
			------ Transmision de los mensajes --------------------
			when others =>
				if(fin_cont = '0') then
				if(tx_activa = '1') then
				case sel_msj is
					when "00" =>
						siguiente_estado <= msj1;
					when "01" =>
						siguiente_estado <= msj2;
					when "10" =>
						siguiente_estado <= msj3;
					when others =>
						siguiente_estado <= msj4;
				end case;
				end if;
				else
					siguiente_estado <= reposo;
				end if;
		end case;
	end process prox_est;
	
------------------------------------------------------------
-- Proceso de Salida (Logica Secuencial)
------------------------------------------------------------
	log_sal: process (clk, reset, tx_activa, sel_msj, estado_presente)
	begin
		if(reset = '0') then
			en_cont <= '0';
			en_rom_inf <= '0';
			en_rom_inst <= '0';
			ini_tx <= '0';
			sel_rom <= '0';
			bcd_msj <= "1111";
		elsif(rising_edge(clk)) then
			en_cont <= '0';
			en_rom_inf <= '0';
			en_rom_inst <= '0';
			ini_tx <= '0';
			sel_rom <= '0';
			bcd_msj <= "1111";
			case estado_presente is
				when reposo => 
					null;
				------ salidas de los estados mensajes -----------------
				when msj1 => 
					bcd_msj <= "0001";
					en_rom_inst <= '1';
					sel_rom <= '1';
					if(tx_activa = '0') then
						en_cont <= '1';
					end if;
				when msj2 => 
					bcd_msj <= "0010";
					en_rom_inst <= '1';
					sel_rom <= '1';
					if(tx_activa = '0') then
						en_cont <= '1';
					end if;
				when msj3 => 
					bcd_msj <= "0011";
					en_rom_inf <= '1';
					if(tx_activa = '0') then
						en_cont <= '1';
					end if;
				when msj4 => 
					bcd_msj <= "0100";
					en_rom_inf <= '1';
					if(tx_activa = '0') then
						en_cont <= '1';
					end if;
				------ Salidas de la transmision --------------------
				when others =>
					ini_tx <= '1';
					case sel_msj is
						when "00" =>
							bcd_msj <= "0001";
							en_rom_inst <= '1';
							sel_rom <= '1';
						when "01" =>
							bcd_msj <= "0010";
							en_rom_inst <= '1';
							sel_rom <= '1';
						when "10" =>
							bcd_msj <= "0011";
							en_rom_inf <= '1';
						when others =>
							bcd_msj <= "0100";
							en_rom_inf <= '1';
					end case;
			end case;
		end if;
	end process log_sal;

end beh;