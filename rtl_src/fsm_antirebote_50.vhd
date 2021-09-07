--Descripcion	: Circuito antirebote descripto mediante una maquina de estados
--					  finito. La misma elimina los rebotes indeseados ocacionados por
--					  el accionamiento de las llaves mecanicas.

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Declaracion de Entidad
------------------------------------------------------------
entity fsm_antirebote_50 is
	port(	rst, clk_50, ent: in std_logic;
			sal: out std_logic);
end fsm_antirebote_50;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of fsm_antirebote_50 is
------- Declaracion del tipo nuevo para --------------------
------- los diferentes estados -----------------------------
	type estados is (espera, cuenta, activo);
	signal siguiente_estado, estado_presente: estados;
------- Declaracion de señales internas --------------------
	signal anterior: std_logic;
	signal enable_cont, res_cont: std_logic;
	signal act_cont: std_logic;
begin

------ Instanciacion del contador simple externo ------------
------ que cuenta durante 20ms segun la frecuencia ----------
	U: entity work.cont_anti_50 port map(clk => clk_50, res => res_cont, enable => enable_cont, act => act_cont);
	
------------------------------------------------------------
-- Proceso de Estado Presente (Logica Secuencial)
------------------------------------------------------------
	est_pr: process (clk_50, rst)
	begin
		if(rst = '0') then
			estado_presente <= espera;
		elsif(rising_edge(clk_50)) then
			estado_presente <= siguiente_estado;
		end if;
	end process est_pr;

------------------------------------------------------------
-- Proceso de Proximo Estado (Logica Combinacional)
------------------------------------------------------------
	prox_est: process (ent, estado_presente, rst, anterior, act_cont)
	begin
		enable_cont <= '0';
		res_cont <= '0';
		siguiente_estado <= estado_presente;
		
		------- Actualizacion del reset interno hacia -----------
		------- el contador externo -----------------------------		
		if(rst = '0') then
			res_cont <= '1';
		end if;
		------- Eleccion del proximo estado dependiente ---------
		------- del valor de las entradas -----------------------
		case estado_presente is
			when espera =>
				if(ent = not(anterior)) then
					siguiente_estado <= cuenta;
				end if;
			when cuenta =>
				enable_cont <= '1';
				if(act_cont = '1') then
					res_cont <= '1';
					if(ent = anterior) then
						siguiente_estado <= espera;
					else
						siguiente_estado <= activo;
					end if;
				end if;
			when others => 
				siguiente_estado <= espera;
		end case;
	end process prox_est;
	
------------------------------------------------------------
-- Proceso de Salida (Logica Secuencial)
------------------------------------------------------------
	log_sal: process (clk_50, rst, ent)
	begin
		
		if(rising_edge(clk_50)) then
			if(rst = '0') then
				sal <= '0';
				anterior <= ent;
			else
				case estado_presente is
					when espera => 
						sal <= anterior;
					when cuenta => 
						sal <= anterior;
					when others =>
						anterior <= ent;
						sal <= ent;
				end case;
			end if;
		end if;
	end process log_sal;

end beh;