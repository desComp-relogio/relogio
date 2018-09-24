-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library IEEE;
-- STD_LOGIC and STD_LOGIC_VECTOR types, and relevant functions
use ieee.std_logic_1164.all;

-- SIGNED and UNSIGNED types, and relevant functions
use ieee.numeric_std.all;

entity demux_6_std_logic is
	port
	(
		-- Input ports
		DIN		: in  std_logic;
		sel	: in  std_logic_vector(2 downto 0);

		-- Output ports
		A		: out  std_logic;
		B		: out  std_logic;
		C		: out  std_logic;
		D		: out  std_logic;
		E		: out  std_logic;
		F		: out  std_logic
		
	);
	
end entity;
-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture rtl of demux_6_std_logic is

	-- Declarations (optional)

begin
	process(sel)
	begin
		case sel is
			when "000" => A <= DIN;
			when "001" => B <= DIN;
			when "010" => C <= DIN;
			when "011" => D <= DIN;
			when "100" => E <= DIN;
			when "101" => F <= DIN;
		end case;
	end process;
end architecture;