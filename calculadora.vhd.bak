library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculadora is
  port (
    -- Entradas (placa)
    CLOCK_50 : in STD_LOGIC;
    KEY: in STD_LOGIC_VECTOR(3 DOWNTO 0);
    SW: in STD_LOGIC_VECTOR(17 DOWNTO 0);

    -- Saidas (placa)
    LEDR  : out STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
    LEDG  : out STD_LOGIC_VECTOR(8 DOWNTO 0) := (others => '0');
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : OUT STD_LOGIC_VECTOR(6 downto 0)
  );
end entity;


architecture comportamento of calculadora is
  signal auxSaida : std_logic_vector(7 downto 0);
  signal loNibble : std_logic_vector(3 downto 0);
  signal hiNibble : std_logic_vector(7 downto 4);
  signal auxFuncaoULA : std_logic_vector(1 downto 0);
  signal auxOverFlow : std_logic := '0';
  signal auxApaga : std_logic := '1';
  signal auxNegativo : std_logic := '0';
  signal auxCarregaA : std_logic := '0';
  signal auxCarregaB : std_logic := '0';
  signal auxCarregaSaida : std_logic := '0';
  signal auxReset : std_logic := '0';
  signal auxClock : std_logic := '0';
  signal pisca : std_logic := '0';
  signal auxLeituraA : std_logic := '0';
  signal auxLeituraB : std_logic := '0';
  signal ativaPisca : std_logic := '0';
  signal controle : std_logic_vector(15 downto 0);
  --
  signal auxPasso : std_logic_vector(3 downto 0);
  signal auxReiniciaFSM : std_logic := '0';
begin

  -- Instancia o fluxo de dados mais simples:
  FD : entity work.fluxoDados (simples) --(complexo)
    Port map (
      entrada(7 downto 0) => hiNibble & loNibble, funcaoULA => auxFuncaoULA,
       clk => auxClock, rst => auxReset, overflow => auxOverFlow,
      carregaA => auxCarregaA, carregaB => auxCarregaB,
      carregaSaida => auxCarregaSaida, saida => auxSaida      
    );

  -- Displays e Leds:
  freqPisca : entity work.divisorGenerico (divisaoGenerica)  generic map (divisor => 25) --(divisaoGenerica) := 2^divisor  
    port map (clk =>  auxClock, saida_clk => pisca);

  -- Resultado da operacao executada:
  display0 : entity work.conversorHex7seg
    Port map (saida7seg => HEX0, dadoHex => auxSaida(3 downto 0), apaga => auxOverFlow);
  display1 : entity work.conversorHex7seg
    Port map (saida7seg => HEX1, dadoHex => auxSaida(7 downto 4), apaga => auxOverFlow);

  -- Indicador de sinal e overflow:
  display2 : entity work.conversorHex7seg
    Port map (saida7seg => HEX2, dadoHex => (others => '1'), apaga => (not(auxNegativo) or auxOverFlow), negativo => auxNegativo);
  display3 : entity work.conversorHex7seg
    Port map (saida7seg => HEX3, dadoHex => (others => '1'), apaga => not(auxOverFlow), overFlow => auxOverFlow);

  -- Mostra os valores sendo escolhidos nas chaves:
  display4 : entity work.conversorHex7seg
    Port map (saida7seg => HEX4, dadoHex => loNibble);
  display5 : entity work.conversorHex7seg
    Port map (saida7seg => HEX5, dadoHex => hiNibble);

  --Indica a operacao escolhida:
  --  0 = Soma
  --  1 = Subtrai
  --  2 = XOR
  --  3 = AND
  display6 : entity work.conversorHex7seg
    Port map (saida7seg => HEX6, dadoHex => '0' & '0' & auxFuncaoULA);

  -- Indica o estado atual da maquina de estado, em decimal:
  display7 : entity work.conversorHex7seg
    Port map (saida7seg => HEX7, dadoHex => auxPasso, apaga => '0', overFlow => '0', negativo => '0');

  -- Instacia a maquina de estados:
  sequenciador : entity work.SM1
    port map( reset => auxReset, clock => auxClock,
    leituraA => auxLeituraA, leituraB => auxLeituraB,
    controle => controle, passo => auxPasso,
    auxReset => auxReset, reiniciaFSM => auxReiniciaFSM);

  -- conexoes da placa:
  -- Os 8 primeiros LEDS VERMELHOS indicam o valor definido nas chaves.
  LEDR(7 downto 0) <= SW(7 downto 0);

  LEDR(17 downto 16) <= auxFuncaoULA;            -- indica a funçao da ULA nos dois ultimos LEDS VERMELHOS.
   LEDG(3 downto 0) <= not(KEY(3 downto 0));      -- Cada LED VERDE, de 0 a 3, indica se o botao correspondente foi pressionado.
  LEDG(7 downto 4) <= ( others => auxOverFlow);  -- Todos LEDs VERDEs, de 4 a 7, indicam se ocorreu OVERFLOW.
  LEDG(8) <= pisca and ativaPisca;               -- O LED VERDE entre os displays pisca no ESTADO 1.
  --
  auxFuncaoULA <= SW(17 downto 16);
--  00 = Soma
--  01 = Subtrai
--  10 = XOR
--  11 = AND

  loNibble <= SW(3 downto 0);
  hiNibble <= SW(7 downto 4);

  -- Indicador de valor negativo na operaçao:
  auxNegativo <=  auxSaida(7);

  -- conexoes do controleenviado para a FSM
  auxLeituraA <= not(KEY(3));
  auxLeituraB <= not(KEY(2));
  auxReiniciaFSM <= not(KEY(1));
  auxReset <= not(KEY(0));
--  Pressionando a tecla 3, carrega o valor definido nas chaves para a entrada A da ULA;
--  Pressionando a tecla 2, carrega o valor definido nas chaves para a entrada B da ULA;
--  Pressionando a tecla 1, reinicia a maquina de estados para o estado 1;
--  Pressionando a tecla 0, faz um hard reset em todos os registradores.

  -- conexoes do controle enviado pela FSM
  ativaPisca  <= controle(0);
  auxCarregaA  <= controle(2);
  auxCarregaB  <= controle(4);
-- Extras, para usar com o fluxo de dados mais complexo.
--      <= controle(5);
--      <= controle(6);
--      <= controle(7);
--      <= controle(8);
--      <= controle(9);
--      <= controle(10);
--      <= controle(11);
--      <= controle(12);
--      <= controle(13);
--      <= controle(14);
  auxCarregaSaida <= controle(15);

--Estado 1: controle(0)  = 1 (valor decimal = 1) = ativaPisca;
--Estado 2: controle(2)  = 1 (valor decimal = 4) = auxCarregaA;
--Estado 3: controle(4)  = 1 (valor decimal = 16) = auxCarregaB;
--Estado 4: controle(15) = 1 (valor decimal = 32768) = auxCarregaSaida;

   auxClock <= CLOCK_50;

end architecture;