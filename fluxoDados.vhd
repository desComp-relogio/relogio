library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fluxoDados is
    Port (
			Mux_sel_6: in std_logic_vector(2 downto 0);
			Mux_sel_5: in std_logic_vector(2 downto 0);
			funcaoULA: in std_logic_vector(1 downto 0);
			is_ajusta: in std_logic;
			valor_ajusta: in std_logic_vector(3 downto 0);		 
			clk, rst:  in std_logic;
			EnDH, EnUH, EnDM, EnUM, EnDS, EnUS: in std_logic;
			ResDH, ResUH, ResDM, ResUM, ResDS, ResUS: in std_logic;
			
			Z				: out std_logic;
			DH_out:	out std_logic_vector(3 downto 0);
			UH_out:	out std_logic_vector(3 downto 0);
			DM_out:	out std_logic_vector(3 downto 0);
			UM_out:	out std_logic_vector(3 downto 0);
			DS_out:	out std_logic_vector(3 downto 0);
			US_out:	out std_logic_vector(3 downto 0);
			overflow: out std_logic
			);
end entity;

architecture simples of fluxoDados is
	signal OUT_MUX_A, OUT_MUX_B, ULA_OUT, MUX_OUT, DH, UH, DM, UM, DS, US: std_logic_vector(3 downto 0);
	signal overflowLocal : std_logic;
	constant one : std_logic_vector(3 downto 0) := "0001";
	constant two : std_logic_vector(3 downto 0) := "0010";
	constant four : std_logic_vector(3 downto 0) := "0100";
	constant six : std_logic_vector(3 downto 0) := "0110";
	constant ten : std_logic_vector(3 downto 0) := "1010";
  
begin
	mux_6: entity work.mux_6_to_1 port map (A => US,B => DS, C => UM, D => DM, E => UH, F => DH, sel => mux_sel_6, q => OUT_MUX_A);
	mux_5: entity work.mux_5_to_1 port map (A => one,B => two, C => four, D => six, E => ten, sel => mux_sel_5, q => OUT_MUX_B);
	ULA:	 entity work.ULA port map (A => OUT_MUX_A, B => OUT_MUX_B, sel => funcaoULA, C => ULA_OUT, overflow => overflowLocal);
	mux_2: entity work.mux_2 port map (A => ULA_OUT, B => valor_ajusta, sel => is_ajusta, q => MUX_OUT);
	regDH		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => MUX_OUT, DOUT => DH, CLK => clk, RST => ResDH, ENABLE => EnDH);
	regUH		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => MUX_OUT, DOUT => UH, CLK => clk, RST => ResUH, ENABLE => EnUH);
	regDM		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => MUX_OUT, DOUT => DM, CLK => clk, RST => ResDM, ENABLE => EnDM);
	regUM		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => MUX_OUT, DOUT => UM, CLK => clk, RST => ResUM, ENABLE => EnUM);
	regDS		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => MUX_OUT, DOUT => DS, CLK => clk, RST => ResDS, ENABLE => EnDS);
	regUS		 : entity work.registradorGenerico generic map (larguraDados => 4) port map (DIN => MUX_OUT, DOUT => US, CLK => clk, RST => ResUS, ENABLE => EnUS);
	 
	Z <= NOT (ULA_OUT(3) OR ULA_OUT(2) OR ULA_OUT(1) OR ULA_OUT(0));
	DH_out <= DH;
	UH_out <= UH;
	DM_out <= DM;
	UM_out <= UM;
	DS_out <= DS;
	US_out <= US;
end architecture;