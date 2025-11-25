---------------------------------------
-- file test_receiver_visual.vhd
-- Propose: receive array data from memory and checks (with csv file) if works
-- Designer: Patrik Loff Peres
-- Date: 19/08/2025
---------------------------------------


Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity test_receiver is
    port(
        clk: in std_logic;
        addr_r: out std_logic_vector(5 downto 0);
        dataout: in std_logic_vector(7 downto 0)
    );
end test_receiver;

architecture arq_tb of test_receiver is

    -- Para armazenar os dados de referncia do arquivo CSV, criamos
    -- um tipo de dado array. Isso permite guardar todos os 64 valores de 8 bits
    -- para que possamos comparar com a sada da sua memria.
    type t_mem_data is array (0 to 63) of std_logic_vector(7 downto 0);
    signal input_mem_data: t_mem_data;
    signal clock_internal : std_logic := '0';

begin
    
    -- Este processo  a lgica principal do testbench.
    -- Ele  responsvel por ler os dados do arquivo CSV e
    -- em seguida, fazer a verificao sincronizada com o clock.
    main_test_process : process
        file arquivo_entrada: text open READ_MODE is "/home/100000001026208/Desktop/TCC/work/64bitsa.csv";
        variable ler_linha: line;
        
        variable ler_v: std_logic;
        variable ler_char: character;
        variable v_temp_data_row : std_logic_vector(7 downto 0);
        variable v_address_read: integer;
        variable error_count: integer := 0;

    begin
		wait for 671 ns;
        report "Iniciando testbench: Lendo dados de referncia do arquivo..." severity note;

        -- FASE 1: Leitura e armazenamento dos dados de referncia --
        -- Este loop l todas as 64 linhas do arquivo CSV e armazena os dados
        -- no nosso array 'input_mem_data'.
        for i in 0 to 63 loop
            if (not endfile(arquivo_entrada)) then
                readline(arquivo_entrada, ler_linha);
            else
                report "Fim do arquivo CSV. Leitura de dados de referncia terminada prematuramente." severity error;
            end if;
            
            read(ler_linha, v_address_read);
            read(ler_linha, ler_char);
            
            for j in 7 downto 0 loop
                read(ler_linha, ler_v);
                v_temp_data_row(j) := ler_v;
                if j > 0 then
                    read(ler_linha, ler_char);
                end if;
            end loop;

            input_mem_data(i) <= v_temp_data_row;
        end loop;

        report "Fim da leitura. Dados de referncia preenchidos." severity note;
        
        -- FASE 2: Verificao da memria --
        report "Iniciando verificao da memria, sincronizada com o clock..." severity note;

        for i in 0 to 63 loop
            addr_r <= std_logic_vector(to_unsigned(i, 6));
		   --wait for 14 ns;
            wait until rising_edge(clk);

            if dataout /= input_mem_data(i) then
                error_count := error_count + 1;
                report "Erro na posicao " & integer'image(i) &
                       ". Esperado: " & integer'image(to_integer(unsigned(input_mem_data(i)))) &
                       ", Obtido: " & integer'image(to_integer(unsigned(dataout)))
                severity warning;
            end if;
        end loop;

        if error_count = 0 then
            report "Nenhum erro encontrado! Memria validada com sucesso." severity note;
        else
            report "Total de erros encontrados: " & integer'image(error_count) severity error;
        end if;

        wait;
    end process;
    
end arq_tb;
