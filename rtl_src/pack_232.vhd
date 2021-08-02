library ieee;
use ieee.std_logic_1164.all;

package pack_232 is
	function paridad(d_in: std_logic_vector) return std_logic;
end pack_232;

package body pack_232 is
	function paridad(d_in: std_logic_vector) return std_logic is
		variable bit_paridad: std_logic;
	begin
		bit_paridad := '0';
		for i in 0 to d_in'length-1 loop
			bit_paridad := bit_paridad xor d_in(i);
		end loop;
		return bit_paridad; 
	end paridad;
end;