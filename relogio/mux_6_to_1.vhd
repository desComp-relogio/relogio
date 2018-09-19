-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library IEEE;
-- STD_LOGIC and STD_LOGIC_VECTOR types, and relevant functions
use ieee.std_logic_1164.all;

-- SIGNED and UNSIGNED types, and relevant functions
use ieee.numeric_std.all;

entity mux_6_to_1 is
	port
	(
		-- Input ports
		A		: in  std_logic_vector(3 downto 0);
		B		: in  std_logic_vector(3 downto 0);
		C		: in  std_logic_vector(3 downto 0);
		D		: in  std_logic_vector(3 downto 0);
		E		: in  std_logic_vector(3 downto 0);
		F		: in  std_logic_vector(3 downto 0);
		sel	: in  std_logic_vector(2 downto 0);

		-- Output ports
		q		: out std_logic_vector(3 downto 0)
	);
	
end entity;
-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture rtl of mux_6_to_1 is

	-- Declarations (optional)

begin

	q <= A when sel = "000" else
		  B when sel = "001" else
		  C when sel = "010" else
		  D when sel = "011" else
		  E when sel = "100" else
		  F;

end architecture;