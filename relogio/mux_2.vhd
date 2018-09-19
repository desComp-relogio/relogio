-- Declarations (optional)-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library IEEE;
-- STD_LOGIC and STD_LOGIC_VECTOR types, and relevant functions
use ieee.std_logic_1164.all;

-- SIGNED and UNSIGNED types, and relevant functions
use ieee.numeric_std.all;

entity mux_2 is
	port
	(
		-- Input ports
		A		: in  std_logic_vector(3 downto 0);
		B		: in  std_logic_vector(3 downto 0);
		sel	: in  std_logic;

		-- Output ports
		q		: out std_logic_vector(3 downto 0)	
	);
	
end entity;
-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture rtl of mux_2 is

begin

	q <= A when sel = "0" else
		  B; 
		  
end architecture;