-- Descripcion: Sincronizador controlado por flanco positivo del reloj y
-- 				 reset activo en bajo. Se usan 2 ff-D en cascada para evitar
-- 				 una señal metaestable a la salida.

------------------------------------------------------------
--Declaracion de Librerias
------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Declaracion de Entidad 
------------------------------------------------------------
entity Sincro is
	generic( sincro_width : natural := 2);
	port(D, CLK, RST: in std_logic;
			Q: out std_logic);
end Sincro;

------------------------------------------------------------
-- Arquitectura
------------------------------------------------------------
architecture beh of Sincro is
------- Declaracion de señales internas --------------------
	signal reg_i: std_logic_vector(sincro_width-1 downto 0) := (others => '0');
begin

-- Los registros cuentan con un reset sincronico y
-- se controlan con el flanco positivo del clock

------- Descripcion del sincronizador ------------------------
	reg_d:process (CLK, RST)
	 begin
		if(RST = '0') then
			reg_i <= (others => '0');
		elsif(rising_edge (CLK)) then
			for i in 1 to reg_i'high loop 
				reg_i(i) <= reg_i(i-1);
			end loop;
			reg_i(0) <= D;
		end if;
	end process reg_d;
	
----- Asignacion de la salida del sincronizador-------------
	Q <= reg_i(reg_i'high);
end beh;