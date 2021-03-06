-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- Generated by Quartus Prime Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition
-- Created on Thu Sep 27 17:29:22 2018

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SM1 IS
    PORT (
        reset : IN STD_LOGIC := '0';
        clock : IN STD_LOGIC;
        Z : IN STD_LOGIC := '0';
        sempre : IN STD_LOGIC := '0';
        um_seg : IN STD_LOGIC := '0';
        ajusta : IN STD_LOGIC := '0';
        but_doneDM : IN STD_LOGIC := '0';
        but_doneUH : IN STD_LOGIC := '0';
        but_doneDH : IN STD_LOGIC := '0';
        controle : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
        state : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        um_ajusta : OUT STD_LOGIC
    );
END SM1;

ARCHITECTURE BEHAVIOR OF SM1 IS
    TYPE type_fstate IS (soma_us,compara_us,reset_all,compara_ds,compara_um,compara_dm,compara_uh_4,compara_uh_10,compara_dh_2,soma_ds,soma_dh,soma_um,soma_dm,soma_uh,espera_seg,isAjusta,ajustaUM,ajusta_DM,ajusta_UH,ajusta_DH);
    SIGNAL fstate : type_fstate;
    SIGNAL reg_fstate : type_fstate;
    SIGNAL reg_controle : STD_LOGIC_VECTOR(20 DOWNTO 0) := "000000000000000000000";
    SIGNAL reg_state : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00000";
BEGIN
    PROCESS (clock,reg_fstate)
    BEGIN
        IF (clock='1' AND clock'event) THEN
            fstate <= reg_fstate;
        END IF;
    END PROCESS;

    PROCESS (fstate,reset,Z,sempre,um_seg,ajusta,but_doneDM,but_doneUH,but_doneDH,reg_controle,reg_state)
    BEGIN
        IF (reset='1') THEN
            reg_fstate <= reset_all;
            reg_controle <= "000000000000000000000";
            reg_state <= "00000";
            controle <= "000000000000000000000";
            state <= "00000";
            um_ajusta <= '0';
        ELSE
            reg_controle <= "000000000000000000000";
            reg_state <= "00000";
            um_ajusta <= '0';
            controle <= "000000000000000000000";
            state <= "00000";
            CASE fstate IS
                WHEN soma_us =>
                    IF ((sempre = '1')) THEN
                        reg_fstate <= compara_us;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= soma_us;
                    END IF;

                    reg_state <= "00010";

                    reg_controle <= "000000000001000000000";
                WHEN compara_us =>
                    IF ((Z = '1')) THEN
                        reg_fstate <= soma_ds;
                    ELSIF (NOT((Z = '1'))) THEN
                        reg_fstate <= compara_ds;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= compara_us;
                    END IF;

                    reg_state <= "00011";

                    reg_controle <= "000000000000001100000";
                WHEN reset_all =>
                    IF ((sempre = '1')) THEN
                        reg_fstate <= isAjusta;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= reset_all;
                    END IF;

                    reg_state <= "00000";

                    reg_controle <= "111111000000000000000";
                WHEN compara_ds =>
                    IF ((Z = '1')) THEN
                        reg_fstate <= soma_um;
                    ELSIF (NOT((Z = '1'))) THEN
                        reg_fstate <= compara_um;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= compara_ds;
                    END IF;

                    reg_state <= "00101";

                    reg_controle <= "000000000000001011001";
                WHEN compara_um =>
                    IF ((Z = '1')) THEN
                        reg_fstate <= soma_dm;
                    ELSIF (NOT((Z = '1'))) THEN
                        reg_fstate <= compara_dm;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= compara_um;
                    END IF;

                    reg_state <= "00111";

                    reg_controle <= "000000000000001100010";
                WHEN compara_dm =>
                    IF ((Z = '1')) THEN
                        reg_fstate <= soma_uh;
                    ELSIF (NOT((Z = '1'))) THEN
                        reg_fstate <= compara_uh_4;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= compara_dm;
                    END IF;

                    reg_state <= "01001";

                    reg_controle <= "000000000000001011011";
                WHEN compara_uh_4 =>
                    IF ((Z = '1')) THEN
                        reg_fstate <= compara_dh_2;
                    ELSIF (NOT((Z = '1'))) THEN
                        reg_fstate <= compara_uh_10;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= compara_uh_4;
                    END IF;

                    reg_state <= "01011";

                    reg_controle <= "000000000000001010100";
                WHEN compara_uh_10 =>
                    IF ((Z = '1')) THEN
                        reg_fstate <= soma_dh;
                    ELSIF (NOT((Z = '1'))) THEN
                        reg_fstate <= isAjusta;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= compara_uh_10;
                    END IF;

                    um_ajusta <= '1';

                    reg_state <= "01100";

                    reg_controle <= "000000000000001100100";
                WHEN compara_dh_2 =>
                    IF ((Z = '1')) THEN
                        reg_fstate <= reset_all;
                    ELSIF (NOT((Z = '1'))) THEN
                        reg_fstate <= espera_seg;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= compara_dh_2;
                    END IF;

                    reg_state <= "01110";

                    reg_controle <= "000000000000001001101";
                WHEN soma_ds =>
                    IF ((sempre = '1')) THEN
                        reg_fstate <= compara_ds;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= soma_ds;
                    END IF;

                    reg_state <= "00100";

                    reg_controle <= "000001000010000000001";
                WHEN soma_dh =>
                    IF ((sempre = '1')) THEN
                        reg_fstate <= isAjusta;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= soma_dh;
                    END IF;

                    um_ajusta <= '1';

                    reg_state <= "01101";

                    reg_controle <= "010000100000000000101";
                WHEN soma_um =>
                    IF ((sempre = '1')) THEN
                        reg_fstate <= compara_um;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= soma_um;
                    END IF;

                    reg_state <= "00110";

                    reg_controle <= "000010000100000000010";
                WHEN soma_dm =>
                    IF ((sempre = '1')) THEN
                        reg_fstate <= compara_dm;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= soma_dm;
                    END IF;

                    reg_state <= "01000";

                    reg_controle <= "000100001000000000011";
                WHEN soma_uh =>
                    IF ((sempre = '1')) THEN
                        reg_fstate <= compara_uh_4;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= soma_uh;
                    END IF;

                    reg_state <= "01010";

                    reg_controle <= "001000010000000000100";
                WHEN espera_seg =>
                    IF ((um_seg = '1')) THEN
                        reg_fstate <= soma_us;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= espera_seg;
                    END IF;

                    reg_state <= "00001";
                WHEN isAjusta =>
                    IF (NOT((ajusta = '1'))) THEN
                        reg_fstate <= espera_seg;
                    ELSIF ((ajusta = '1')) THEN
                        reg_fstate <= ajusta_DH;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= isAjusta;
                    END IF;

                    um_ajusta <= '0';
                WHEN ajustaUM =>
                    IF (((((but_doneDM = '1') AND (but_doneUH = '1')) AND (but_doneDH = '1')) AND NOT((ajusta = '1')))) THEN
                        reg_fstate <= isAjusta;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= ajustaUM;
                    END IF;

                    reg_state <= "10001";

                    reg_controle <= "000000000100100000000";
                WHEN ajusta_DM =>
                    IF (((NOT((but_doneDM = '1')) AND (but_doneUH = '1')) AND (but_doneDH = '1'))) THEN
                        reg_fstate <= ajustaUM;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= ajusta_DM;
                    END IF;

                    reg_state <= "10010";

                    reg_controle <= "000000001000100000000";
                WHEN ajusta_UH =>
                    IF ((((but_doneDM = '1') AND NOT((but_doneUH = '1'))) AND (but_doneDH = '1'))) THEN
                        reg_fstate <= ajusta_DM;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= ajusta_UH;
                    END IF;

                    reg_state <= "10011";

                    reg_controle <= "000000010000100000000";
                WHEN ajusta_DH =>
                    IF ((((but_doneDM = '1') AND (but_doneUH = '1')) AND NOT((but_doneDH = '1')))) THEN
                        reg_fstate <= ajusta_UH;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= ajusta_DH;
                    END IF;

                    reg_state <= "10100";

                    reg_controle <= "000000100000100000000";
                WHEN OTHERS => 
                    reg_controle <= "XXXXXXXXXXXXXXXXXXXXX";
                    reg_state <= "XXXXX";
                    um_ajusta <= 'X';
                    report "Reach undefined state";
            END CASE;
            controle <= reg_controle;
            state <= reg_state;
        END IF;
    END PROCESS;
END BEHAVIOR;
