---------------------------------------
-- file .vhd
-- Propose: receive signal from memory block and checks if it was read successfully 
-- Observation: check the lenght of the variables
-- Designer: Patrik Loff Peres
-- Date: 15/04/2025
---------------------------------------

Library ieee;
use ieee.std_logic_1164.all;	   
use ieee.numeric_std.all;
use std.textio.all;

entity recebedor_do_teste is	-- entity declaration
		port(en: out std_logic;
		 bit_0_addr_r, bit_1_addr_r: out std_logic;
		 bit_0_dataout, bit_1_dataout, bit_2_dataout: in std_logic
		);
end recebedor_do_teste;

---------------------------------------

architecture arq_tb of recebedor_do_teste is

type memtype is array (0 to 3) of std_logic_vector(2 downto 0);

signal addr_r: std_logic_vector(1 downto 0);
signal dataout: std_logic_vector(2 downto 0);

--matrix of constants to write on memory
constant test1: memtype:= ("000", "001", "010","011");
constant test2: memtype:= ("000", "011", "110","111");


-- procedure to check if what's read from memory is the same as matriz Input_Mem
	procedure Check_Mem(
			    signal T_addr_r: out std_logic_vector(1 downto 0);
			    signal T_out: in std_logic_vector(2 downto 0);
			    constant Input_Mem: in memtype) is
	variable error_count: integer := 0;

		begin
    
    for i in 0 to 3 loop
        T_addr_r <= 	std_logic_vector(to_unsigned(i, 2));
        wait for 14 ns; 
        --wait until rising_edge(T_clk);
        
        if T_out /= Input_Mem(i) then
            error_count := error_count + 1;
            report "Erro na posicao " & integer'image(i) 
                & ". Esperado: " & integer'image(to_integer(unsigned(Input_Mem(i))))--, Input_Mem(i)'length)));
                & ", Obtido: " & integer'image(to_integer(unsigned(T_out)))--, T_out'length)));
               severity warning;
        end if;
    end loop;

    if error_count = 0 then
        report "Nenhum erro encontrado! Memoria validada com sucesso." severity warning;
    else
        report "Total de erros encontrados: " & integer'image(error_count) severity warning; --
    end if;
	end procedure;
	
begin
	dataout <= bit_2_dataout & bit_1_dataout & bit_0_dataout;
	bit_1_addr_r <= addr_r(1);
	bit_0_addr_r <= addr_r(0);
	en <= '0';
	process
	begin
	--wait for 100 ns;
	assert false report "Recebedor Iniciado" severity warning;
		Check_Mem( addr_r, dataout, test1);   
		assert false report "Recebedor Finalizado" severity warning;   
	end process;

end arq_tb;