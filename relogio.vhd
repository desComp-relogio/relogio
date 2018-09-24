library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity relogio is
  port (
    -- Entradas (placa)
    CLOCK_50 : in STD_LOGIC;
    KEY: in STD_LOGIC_VECTOR(3 DOWNTO 0);
    SW: in STD_LOGIC_VECTOR(17 DOWNTO 0);
	 
	 Mux_sel_6, Mux_sel_5: out STD_LOGIC_VECTOR(2 downto 0);
	 funcaoULA: out STD_LOGIC_VECTOR(1 downto 0);
	 state: out STD_LOGIC_VECTOR(3 downto 0);
	 is_ajusta, EnDH, EnUH, EnDM, EnUM, EnDS, EnUS, ResDH, ResUH, ResDM, ResUM, ResDS, ResUS, um_seg_out: out STD_LOGIC;
	 DH_out, UH_out, DM_out, UM_out, DS_out, US_out: out STD_LOGIC_VECTOR(3 downto 0);
	 controle_out: out STD_LOGIC_VECTOR(20 downto 0);
	 
    LEDR  : out STD_LOGIC_VECTOR(17 DOWNTO 0) := (others => '0');
    LEDG  : out STD_LOGIC_VECTOR(8 DOWNTO 0) := (others => '0');
	 
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : OUT STD_LOGIC_VECTOR(6 downto 0)
  );
end entity;


architecture comportamento of relogio is
	signal Mux_sel_6_aux: std_logic_vector(2 downto 0) := "000";
	signal Mux_sel_5_aux: std_logic_vector(2 downto 0) := "000";
	signal funcaoULA_aux: std_logic_vector(1 downto 0) := "00";
	signal state_aux	  : std_logic_vector(4 downto 0) := "00000";
	signal is_ajusta_aux: std_logic := '0';
	signal auxReset : std_logic := '0';
	signal valor_ajusta_aux:  std_logic_vector(3 downto 0);		 
	signal EnDH_aux:  std_logic := '0';
	signal EnUH_aux:  std_logic := '0';
	signal EnDM_aux:  std_logic := '0';
	signal EnUM_aux:  std_logic := '0';
	signal EnDS_aux:  std_logic := '0';
	signal EnUS_aux:  std_logic := '0';
	
	signal ResDH_aux:  std_logic := '0';
	signal ResUH_aux:  std_logic := '0';
	signal ResDM_aux:  std_logic := '0';
	signal ResUM_aux:  std_logic := '0';
	signal ResDS_aux:  std_logic := '0';
	signal ResUS_aux:  std_logic := '0';
	signal sempre	 :	 std_logic := '1';
	signal um_seg	 :	 std_logic := '0';
	signal ajusta	 :	 std_logic := '0';
	signal but_doneUM :  std_logic := '0';
	signal but_doneDM :  std_logic := '0';
	signal but_doneUH :  std_logic := '0';
	signal but_doneDH :  std_logic := '0';
	signal sw_value : std_logic_vector(3 downto 0) := "0000";

	signal Z_aux	  : std_logic;
	signal DH_out_aux: std_logic_vector(3 downto 0);
	signal UH_out_aux: std_logic_vector(3 downto 0);
	signal DM_out_aux: std_logic_vector(3 downto 0);
	signal UM_out_aux: std_logic_vector(3 downto 0);
	signal DS_out_aux: std_logic_vector(3 downto 0);
	signal US_out_aux: std_logic_vector(3 downto 0);
	signal auxOverFlow: std_logic;
	
	signal controle : std_logic_vector(20 downto 0);
begin

  -- Instancia o fluxo de dados mais simples:
  FD : entity work.fluxoDados (simples) --(complexo)
    Port map (
		mux_sel_6 => mux_sel_6_aux, mux_sel_5 => mux_sel_5_aux, funcaoULA => funcaoULA_aux,
      is_ajusta => is_ajusta_aux, valor_ajusta => valor_ajusta_aux, clk => CLOCK_50, rst => auxReset,
		EnDH => EnDH_aux, EnUH => EnUH_aux, EnDM => EnDM_aux, EnUM => EnUM_aux, EnDS => EnDS_aux, EnUS => EnUS_aux,
		ResDH => ResDH_aux, ResUH => ResUH_aux, ResDM => ResDM_aux, ResUM => ResUM_aux, ResDS => ResDS_aux, ResUS => ResUS_aux,
		Z => Z_aux, DH_out => DH_out_aux, UH_out => UH_out_aux, DM_out => DM_out_aux, UM_out => UM_out_aux,
		DS_out => DS_out_aux, US_out => US_out_aux, overflow => auxOverFlow
    );

--  -- Displays e Leds:
--  freqPisca : entity work.divisorGenerico (divisaoGenerica)  generic map (divisor => 25) --(divisaoGenerica) := 2^divisor  
--    port map (clk =>  auxClock, saida_clk => pisca);
--
  -- Resultado da operacao executada:
  
  
  display0 : entity work.conversorHex7seg
    Port map (saida7seg => HEX0, dadoHex => US_out_aux);
  display1 : entity work.conversorHex7seg
    Port map (saida7seg => HEX1, dadoHex => DS_out_aux);

  -- Indicador de sinal e overflow:
  display2 : entity work.conversorHex7seg
    Port map (saida7seg => HEX2, dadoHex => UM_out_aux);
  display3 : entity work.conversorHex7seg
    Port map (saida7seg => HEX3, dadoHex => DM_out_aux);
--
  -- Mostra os valores sendo escolhidos nas chaves:
  display4 : entity work.conversorHex7seg
    Port map (saida7seg => HEX4, dadoHex => UH_out_aux);
  display5 : entity work.conversorHex7seg	
    Port map (saida7seg => HEX5, dadoHex => DH_out_aux);
--
--  --Indica a operacao escolhida:
--  --  0 = Soma
--  --  1 = Subtrai
--  --  2 = XOR
--  --  3 = AND
  display6 : entity work.conversorHex7seg
    Port map (saida7seg => HEX6, dadoHex => valor_ajusta_aux);
--
  -- Indica o estado atual da maquina de estado, em decimal:
  display7 : entity work.conversorHex7seg
    Port map (saida7seg => HEX7, dadoHex => '0' &  '0' & '0' & SW(17));
--
  -- Instacia a maquina de estados:
	sequenciador : entity work.SM1
    port map( reset => auxReset, clock => CLOCK_50,
				  ajusta => ajusta, but_doneUM => but_doneUM, but_doneDM => but_doneDM, but_doneUH => but_doneUH, but_doneDH => but_doneDH, 
				  Z => Z_aux, sempre => sempre, um_seg => um_seg,controle => controle, state => state_aux);  --,
				  
	clk_1seg: entity work.clk_div port map(clk_50 => CLOCK_50, clk_1s => um_seg);
	
	ResDH_aux <= controle(20);	
	ResUH_aux <= controle(19);
	ResDM_aux <= controle(18);
	ResUM_aux <= controle(17);
	ResDS_aux <= controle(16);
	ResUS_aux <= controle(15);
	
	EnDH_aux <= controle(14);
	EnUH_aux <= controle(13);
	EnDM_aux <= controle(12);
	EnUM_aux <= controle(11);
	EnDS_aux <= controle(10);
	EnUS_aux <= controle(9);	
	
	is_ajusta_aux <= controle(8);
	funcaoULA_aux <= controle(7 downto 6);
	Mux_sel_5_aux <= controle(5 downto 3);
	Mux_sel_6_aux <= controle(2 downto 0);
	
	ajusta <= SW(17);
	
	but_doneUM <= KEY(0);
	but_doneDM <= KEY(1);
	but_doneUH <= KEY(2);
	but_doneDH <= KEY(3);
	
	sw_value <= SW(3 downto 0);
	
	process(sw_value, state_aux)
	begin
	if to_integer(unsigned(state_aux)) = 17 then
	
		case to_integer(unsigned(sw_value)) 	is
			when 10 to 15 => valor_ajusta_aux <= "1001";
			when others => valor_ajusta_aux <= sw_value;
		end case;
	
	elsif to_integer(unsigned(state_aux)) = 18 then
		
		case to_integer(unsigned(sw_value)) 	is
			when 6 to 15 => valor_ajusta_aux <= "0101";
			when others => valor_ajusta_aux <= sw_value;
		end case;
	
	elsif to_integer(unsigned(state_aux)) = 19 then
		
		if ( DH_out_aux = "0010") then 
			case to_integer(unsigned(sw_value)) 	is
				when 4 to 15 => valor_ajusta_aux <= "0011";
				when others => valor_ajusta_aux <= sw_value;
			end case;
		else
			case to_integer(unsigned(sw_value)) 	is
				when 10 to 15 => valor_ajusta_aux <= "1001";
				when others => valor_ajusta_aux <= sw_value;
			end case;
		end if;
		
	elsif to_integer(unsigned(state_aux)) = 20 then
		
		case to_integer(unsigned(sw_value)) 	is
			when 3 to 15 => valor_ajusta_aux <= "0010";
			when others => valor_ajusta_aux <= sw_value;
		end case;
	
	end if;
	end process;

end architecture;