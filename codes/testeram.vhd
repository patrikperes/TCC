library ieee;
use ieee.std_logic_1164.all;

entity testeram is
port( 	ck,en:			in	std_logic;
	add:			in	std_logic_vector(5 downto 0);
	a:			in	std_logic_vector(7 downto 0);
	y:			out	std_logic_vector(7 downto 0)
	);
end testeram;

architecture arch1 of testeram is

component rf2p64x8mux4co is
port( 	ckw,enw:		in	std_logic;
	addw,addr:		in	std_logic_vector(5 downto 0);
	inw:			in	std_logic_vector(7 downto 0);
	outr:			out	std_logic_vector(7 downto 0)
	);
end component;

signal addx:		std_logic_vector(5 downto 0);
signal inw,outr:	std_logic_vector(7 downto 0);
begin

	process(ck,add,a)
	begin
	if (ck'event and ck='1') then 
		addx <= add;
		inw <= a;
		y <= outr;
	end if;
	end process;

u1: rf2p64x8mux4co port map(ck,en,addx,addx,inw,outr);

end arch1;



