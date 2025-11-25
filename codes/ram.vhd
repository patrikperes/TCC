library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
port( 	
	clk,en:			in	std_logic;
	addr_r,addr_w:	in	std_logic_vector(1 downto 0);
	datain:			in	std_logic_vector(2 downto 0);
	dataout:		out	std_logic_vector(2 downto 0)	
	);
end ram;

architecture arch1 of ram is

type memtype is array (0 to 3) of std_logic_vector(2 downto 0);
signal memoria:	memtype;

begin

	process(clk,en,addr_w,datain)
        begin
        	if clk'event and clk='1' then
                	if en='1' then
				memoria(to_integer(unsigned(addr_w))) <= datain;
			end if;
		end if;
        end process;

dataout <= memoria(to_integer(unsigned(addr_r)));

end arch1;      




















































