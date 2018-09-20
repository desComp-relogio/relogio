library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fluxoDados is
    Port (
			DHIn: in std_logic_vector(3 downto 0);
			UHIn: in std_logic_vector(3 downto 0);
			DMIn: in std_logic_vector(3 downto 0);
			UMIn: in std_logic_vector(3 downto 0);
			DSIn: in std_logic_vector(3 downto 0);
			USIn: in std_logic_vector(3 downto 0);
			Mux_sel_6: in std_logic_vector(2 downto 0);
			Mux_sel_5: in std_logic_vector(2 downto 0);
			isAjusta: in std_logic;
			DH_ajusta: in std_logic_vector(3 downto 0);
			UH_ajusta: in std_logic_vector(3 downto 0);
			DM_ajusta: in std_logic_vector(3 downto 0);
			UM_ajusta: in std_logic_vector(3 downto 0);
			funcaoULA: in std_logic_vector(1 downto 0);
			clk, rst:  in std_logic;
			carregaA:  in std_logic;
			carregaB:  in std_logic;
			carregaSaida: in std_logic;
			
			Z				: out std_logic;
			entradaA_ULA: out std_logic_vector(3 downto 0);
			entradaB_ULA: out std_logic_vector(3 downto 0);
			saida_REG : out std_logic_vector(3 downto 0);
			overflow: out std_logic
			);
end entity;

architecture simples of fluxoDados is
  signal ULA_IN_A, ULA_IN_B, ULA_OUT, REG_ULA  : std_logic_vector(3 downto 0);
  signal OUT_MUX_A, OUT_MUX_B 					  : std_logic_vector(3 downto 0);
  signal DHReg_in, UHReg_in, DMReg_in, UMReg_in, DSReg_in, USReg_in: std_logic_vector(3 downto 0);
  signal DHMux_in, UHMux_in, DMMux_in, UMMux_in: std_logic_vector(3 downto 0);
  signal DHReg_en, UHReg_en, DMReg_en, UMReg_en, DSReg_en, USReg_en: std_logic;
  signal overflowLocal : std_logic;
  signal reg_out_signal: std_logic_vector(3 downto 0);
  constant one : std_logic_vector(3 downto 0) := "0001";
  constant two : std_logic_vector(3 downto 0) := "0010";
  constant four : std_logic_vector(3 downto 0) := "0100";
  constant six : std_logic_vector(3 downto 0) := "0110";
  constant ten : std_logic_vector(3 downto 0) := "1010";
  signal DH, UH, DM, UM, DS, US: std_logic_vector(3 downto 0);
  
begin
	 Mux_6		 : entity work.mux_6_to_1 Port map (A => DH, B => UH, C => DM, D => UM, E => DS, F => US, sel => Mux_sel_6, q => OUT_MUX_A);
	 Mux_5		 : entity work.mux_5_to_1 Port map (A => one, B => two, C => four, D => six, E => ten, sel => Mux_sel_5, q => OUT_MUX_B);
    ULA         : entity work.ULA Port map (A => ULA_IN_A, B => ULA_IN_B, C => ULA_OUT, Sel => funcaoULA, overflow => overflowLocal);
    regEntradaA : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => OUT_MUX_A, DOUT => ULA_IN_A, CLK => clk, RST => rst, ENABLE => carregaA);
    regEntradaB : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => OUT_MUX_B, DOUT => ULA_IN_B, CLK => clk, RST => rst, ENABLE => carregaB);
    regSaida    : entity work.registradorGenerico generic map (larguraDados => 5) port map (DIN => overflowLocal & ULA_OUT, DOUT(3 downto 0) => reg_out_signal, DOUT(4) => overflow, CLK => clk, RST => rst, ENABLE => carregaSaida);
    Demux       : entity work.demux_6 Port map (DIN => reg_out_signal, sel => Mux_sel_6, A => DHMux_in, B => UHMux_in, C => DMMux_in, D => UMMux_in, E => DSReg_in, F => USReg_in);
	 Mux_2_DH	 : entity work.mux_2 port map(A => DH_ajusta, B => DHMux_in, sel => isAjusta, q => DHReg_in);
	 Mux_2_UH	 : entity work.mux_2 port map(A => UH_ajusta, B => UHMux_in, sel => isAjusta, q => UHReg_in);
	 Mux_2_DM	 : entity work.mux_2 port map(A => DM_ajusta, B => DMMux_in, sel => isAjusta, q => DMReg_in);
	 Mux_2_UM	 : entity work.mux_2 port map(A => UM_ajusta, B => UMMux_in, sel => isAjusta, q => UMReg_in);
	 Demux_EN	 : entity work.demux_6_std_logic port map (DIN => '1', sel => Mux_sel_6, A => DHReg_en, B => UHReg_en, C => DMReg_en, D => UMReg_en, E => DSReg_en, F => USReg_en);
	 regDH		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => DHReg_in, DOUT => DH, CLK => clk, RST => rst, ENABLE => DHReg_en);
	 regUH		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => UHReg_in, DOUT => UH, CLK => clk, RST => rst, ENABLE => UHReg_en);
	 regDM		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => DMReg_in, DOUT => DM, CLK => clk, RST => rst, ENABLE => DMReg_en);
	 regUM		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => UMReg_in, DOUT => UM, CLK => clk, RST => rst, ENABLE => UMReg_en);
	 regDS		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => DSReg_in, DOUT => DS, CLK => clk, RST => rst, ENABLE => DSReg_en);
	 regUS		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => USReg_in, DOUT => US, CLK => clk, RST => rst, ENABLE => USReg_en);
	 
	 Z <= NOT (ULA_OUT(3) OR ULA_OUT(2) OR ULA_OUT(1) OR ULA_OUT(0));
	 entradaA_ULA <= ULA_IN_A;
    entradaB_ULA <= ULA_IN_B;
	 saida_REG <= reg_out_signal;
end architecture;