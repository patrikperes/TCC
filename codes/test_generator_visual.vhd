---------------------------------------
-- file test_generator_visual.vhd
-- Propose: writes the entire memory with array data from csv file
-- with less data to view the result in waveform
-- Designer: Patrik Loff Peres
-- Date: 19/08/2025
---------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all; -- Para usar a leitura de std_logic
use std.textio.all;

entity test_generator_visual is -- entity declaration
    port(
        clk: out std_logic;
        en: out std_logic;
        addr_w: out std_logic_vector(5 downto 0);
        datain: out std_logic_vector(7 downto 0)
    );
end test_generator_visual;

architecture arq_tb of test_generator_visual is

signal T_clk: std_logic:= '1';

-- procedure para escrever na memria, lendo do arquivo CSV
procedure Write_on_mem(signal T_en: out std_logic;
             signal T_clk: in std_logic;
             signal T_addr_w: out std_logic_vector(5 downto 0);
             signal T_in: out std_logic_vector(7 downto 0)) is
    --file arquivo_entrada: text open READ_MODE is "/home/100000001026208/Downloads/work_after_liberate/work/64bits.csv";
    --variable ler_linha: line;
    --variable ler_v: std_logic;
    --variable ler_char: character;
    variable v_temp_data_row : std_logic_vector(7 downto 0);
	variable i: integer;
    --variable v_address_read: integer;
begin
	T_en <= '0';
	wait for 14 ns;
	wait until rising_edge(T_clk);
	report "Iniciando gerador." severity note;
	i := 0;
	v_temp_data_row := "11001100";
	report "Escrevendo " & integer'image(to_integer(unsigned(v_temp_data_row))) &
                       " no endereco " & integer'image(to_integer(to_unsigned(i, 6)))
                severity warning;
        T_addr_w <= std_logic_vector(to_unsigned(i, 6));
        T_in <= v_temp_data_row;
		wait until rising_edge(T_clk);
		T_en <= '1';
		wait for 14 ns;
        wait until rising_edge(T_clk);
		T_en <= '0';
		wait until rising_edge(T_clk);

	i := 1;
	v_temp_data_row := "01010101";
	report "Escrevendo " & integer'image(to_integer(unsigned(v_temp_data_row))) &
                       " no endereco " & integer'image(to_integer(to_unsigned(i, 6)))
                severity warning;
        T_addr_w <= std_logic_vector(to_unsigned(i, 6));
        T_in <= v_temp_data_row;
		wait until rising_edge(T_clk);
		T_en <= '1';
		wait for 14 ns;
        wait until rising_edge(T_clk);
		T_en <= '0';
		wait until rising_edge(T_clk);

end procedure;
    
begin
    -- Gera o sinal de clock
    T_clk <= not T_clk after 5 ns;
    clk <= T_clk;
    
    process
    begin
        -- FASE 1: Escreve os dados lidos do CSV na memria
        --report "Iniciando escrita na memoria a partir do arquivo CSV..." severity note;
        Write_on_mem(en, T_clk, addr_w, datain);
        
        report "Geracao de sinais de escrita finalizada." severity note;
        wait; -- Mantm o processo ativo
    end process;

end arq_tb;
