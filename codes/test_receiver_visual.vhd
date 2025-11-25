---------------------------------------
-- file test_receiver_visual.vhd
-- Propose: receive array data from memory and checks if works
-- with less data to view the result in waveform
-- Designer: Patrik Loff Peres
-- Date: 19/08/2025
---------------------------------------

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity test_receiver_visual is
    port(
        clk: in std_logic;
        addr_r: out std_logic_vector(5 downto 0);
        dataout: in std_logic_vector(7 downto 0)
    );
end test_receiver_visual;

architecture arq_tb of test_receiver_visual is

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
        variable v_temp_data_row : std_logic_vector(7 downto 0);
        variable v_address_read: integer;
	    variable i: integer;
        variable error_count: integer := 0;

    begin
		wait for 100 ns;
		i := 0;
		v_temp_data_row := "11001100";
        input_mem_data(i) <= v_temp_data_row;

            addr_r <= std_logic_vector(to_unsigned(i, 6));
		   wait for 14 ns;
            wait until rising_edge(clk);

            if dataout /= input_mem_data(i) then
                error_count := error_count + 1;
                report "Erro na posicao " & integer'image(i) &
                       ". Esperado: " & integer'image(to_integer(unsigned(input_mem_data(i)))) &
                       ", Obtido: " & integer'image(to_integer(unsigned(dataout)))
                severity warning;
            end if;

		i := 1;
		v_temp_data_row := "01010101";
        input_mem_data(i) <= v_temp_data_row;

            addr_r <= std_logic_vector(to_unsigned(i, 6));
		   wait for 14 ns;
            wait until rising_edge(clk);

            if dataout /= input_mem_data(i) then
                error_count := error_count + 1;
                report "Erro na posicao " & integer'image(i) &
                       ". Esperado: " & integer'image(to_integer(unsigned(input_mem_data(i)))) &
                       ", Obtido: " & integer'image(to_integer(unsigned(dataout)))
                severity warning;
            end if;


        if error_count = 0 then
            report "Nenhum erro encontrado! Memria validada com sucesso." severity note;
        else
            report "Total de erros encontrados: " & integer'image(error_count) severity error;
        end if;

        wait;
    end process;
    
end arq_tb;
