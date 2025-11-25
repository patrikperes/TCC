---------------------------------------
-- file .vhd
-- Propose: writes the entire memory and checks if it was read successfully 
-- Observation: check the lenght of the variables
-- Designer: Patrik Loff Peres
-- Date: 11/03/2025
---------------------------------------

Library ieee;
use ieee.std_logic_1164.all;	   
use ieee.numeric_std.all;
use std.textio.all;

entity gerador_do_teste is	-- entity declaration
--	port(clk,en: out std_logic;
--		 addr_w, addr_r: out std_logic_vector(1 downto 0);
--		 datain: out std_logic_vector(2 downto 0);
--		 dataout: in std_logic_vector(2 downto 0)
--		);
		port(clk,en: out std_logic;
		 bit_0_addr_w, bit_1_addr_w: out std_logic;
		 bit_0_datain, bit_1_datain, bit_2_datain: out std_logic--;
		 --bit_0_dataout, bit_1_dataout, bit_2_dataout: in std_logic
		);
end gerador_do_teste;

---------------------------------------

architecture arq_tb of gerador_do_teste is

type memtype is array (0 to 3) of std_logic_vector(2 downto 0);

signal T_clk: std_logic:= '1'; -- global signal, don't need to pass into the procedure (question mark)
signal addr_w, addr_r: std_logic_vector(1 downto 0);
signal datain: std_logic_vector(2 downto 0);
signal dataout: std_logic_vector(2 downto 0);
--signal end : boolean :=false;

--matrix of constants to write on memory
constant test1: memtype:= ("000", "001", "010","011");
constant test2: memtype:= ("000", "011", "110","111");


-- procedure to write a matrix of data on memory
	procedure Write_on_mem(signal T_en: out std_logic;
				--signal T_clk: in std_logic;
				signal T_addr_w: out std_logic_vector(1 downto 0);
				signal T_in: out std_logic_vector(2 downto 0);
				constant Input_Mem : in memtype) is 
	begin
		T_en <= '1';
		for i in 0 to 3 loop
			T_addr_w <= std_logic_vector(to_unsigned(i, 2));
			T_in <= Input_Mem(i);
			wait for 14 ns;
			wait until rising_edge(T_clk);
		end loop;
		T_en <= 	'0';
	end procedure;

-- procedure to check if what's read from memory is the same as matriz Input_Mem
	procedure Check_Mem(signal T_en: out std_logic;
			    --signal T_clk: in std_logic;
			    signal T_addr_r: out std_logic_vector(1 downto 0);
			    signal T_out: in std_logic_vector(2 downto 0);
			    constant Input_Mem: in memtype) is
	variable error_count: integer := 0;

begin
    T_en <= '0';
    
    for i in 0 to 3 loop
        T_addr_r <= 	std_logic_vector(to_unsigned(i, 2));
        wait for 14 ns; 
        wait until rising_edge(T_clk);
        
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
        report "Total de erros encontrados: " severity warning; -- & integer'image(error_count)
    end if;
end procedure;
	
begin
	--dataout <= bit_2_dataout & bit_1_dataout & bit_0_dataout;
	bit_1_addr_w <= addr_w(1);
	bit_0_addr_w <= addr_w(0);
--	bit_1_addr_r <= addr_r(1);
--	bit_0_addr_r <= addr_r(0);
	bit_2_datain <= datain(2);
	bit_1_datain <= datain(1);
	bit_0_datain <= datain(0);
	
	T_clk <= not T_clk after 5 ns;		-- clock signal
	clk <= T_clk;
	--T_rst <= '1','0' after 17 ns;		-- reset signal

	process
	begin
		Write_on_mem(en, addr_w, datain, test1);
		--Check_Mem(en , addr_r, dataout, test1);   
	assert false report "Geracao Finalizada" severity warning;   
	wait;  -- Mantm o processo ativo
	end process;

end arq_tb;