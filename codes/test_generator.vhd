---------------------------------------
-- file test_generator.vhd
-- Propose: writes the entire memory with array data from csv file
-- Designer: Patrik Loff Peres
-- Date: 12/08/2025
---------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all; -- Para usar a leitura de std_logic
use std.textio.all;

entity test_generator is -- entity declaration
	port(
    	clk: out std_logic;
    	en: out std_logic;
    	addr_w: out std_logic_vector(5 downto 0);
    	datain: out std_logic_vector(7 downto 0)
	);
end test_generator;

architecture arq_tb of test_generator is

signal T_clk: std_logic:= '1';

-- procedure para escrever na memria, lendo do arquivo CSV
procedure Write_on_mem(signal T_en: out std_logic;
         	signal T_clk: in std_logic;
         	signal T_addr_w: out std_logic_vector(5 downto 0);
         	signal T_in: out std_logic_vector(7 downto 0)) is
	file arquivo_entrada: text open READ_MODE is "/home/100000001026208/Desktop/TCC/work/64bitsa.csv";
	variable ler_linha: line;
	variable ler_v: std_logic;
	variable ler_char: character;
	variable v_temp_data_row : std_logic_vector(7 downto 0);
	variable v_address_read: integer;
begin
    T_en <= '1';
    wait for 14 ns;
    wait until rising_edge(T_clk);
    report "Iniciando gerador." severity note;
	for i in 0 to 63 loop
    	-- L uma linha completa do arquivo.
    	if (not endfile(arquivo_entrada)) then
        	readline(arquivo_entrada, ler_linha);
    	else
        	report "Fim do arquivo CSV. Escrita terminada prematuramente." severity error;
        	return;
    	end if;
   	 
    	-- L o valor do endereo, que pode ter mais de um dgito
    	read(ler_linha, v_address_read);
    	-- L a vrgula que separa o endereo dos dados
    	read(ler_linha, ler_char);
   	 
    	for j in 7 downto 0 loop
        	-- L o bit de dado
        	read(ler_linha, ler_v);
        	v_temp_data_row(j) := ler_v;
       	 
        	-- L a vrgula, exceto no ltimo bit da linha
        	if j > 0 then
            	read(ler_linha, ler_char);
        	end if;
    	end loop;
    report "Escrevendo " & integer'image(to_integer(unsigned(v_temp_data_row))) &
                   	" no endereco " & integer'image(to_integer(to_unsigned(i, 6)))
            	severity warning;
   	 wait until falling_edge(T_clk);
    	T_addr_w <= std_logic_vector(to_unsigned(i, 6));
    	T_in <= v_temp_data_row;
   	 wait until rising_edge(T_clk);
   	 --T_en <= '1';
    --    wait for 14 ns;
   -- 	wait until rising_edge(T_clk);
    --    T_en <= '0';
   	 --wait until rising_edge(T_clk);
	end loop;
    wait until rising_edge(T_clk);
    T_en <= '0';
end procedure;
    
begin
	-- Gera o sinal de clock
	T_clk <= not T_clk after 5 ns;
    --T_clk <= not T_clk after 10 ns;
	clk <= T_clk;
    
	process
	begin
    	-- FASE 1: Escreve os dados lidos do CSV na memria
    	report "Iniciando escrita na memoria a partir do arquivo CSV..." severity note;
    	Write_on_mem(en, T_clk, addr_w, datain);
   	 
    	report "Geracao de sinais de escrita finalizada." severity note;
   	 --en <= '0';
    	wait; -- Mantm o processo ativo
	end process;

end arq_tb;