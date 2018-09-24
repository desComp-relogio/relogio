LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico is
    generic
    (divisor : natural := 8);
    port(
        clk         :   in std_logic;
        saida_clk :   out std_logic
        );
end entity;

architecture divisaoPor2 of divisorGenerico is
    signal tick : std_logic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            tick <= not tick;
        end if;
    end process;
    saida_clk <= tick;
end architecture;


architecture divisaoGenerica of divisorGenerico is
    signal cnt : std_logic_vector(divisor downto 0);
    begin  
        process(clk)
        begin
            if rising_edge(clk) then  
                cnt <= std_logic_vector(unsigned(cnt) + 1);
            end if;  
        end process;   
        saida_clk <= cnt(divisor);
end architecture;