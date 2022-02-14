LIBRARY	IEEE,work;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;
	USE work.mem_addr_pkg.all;

entity GDC_MMAP is
generic(
	SDAWIDTH	:integer	:=23
);
port(
	GDC_ADDR	:in std_logic_vector(17 downto 0);
	
	GRAMSEL		:in std_logic;
	
	RAMBANK		:out std_logic_vector(1 downto 0);
	RAMADDR		:out std_logic_vector(SDAWIDTH-1 downto 0)
);
end GDC_MMAP;

architecture rtl of GDC_MMAP is
begin
	RAMBANK<=	RAM_VRAMF(SDAWIDTH+1 downto SDAWIDTH) when GRAMSEL='0' else
					RAM_VRAMB(SDAWIDTH+1 downto SDAWIDTH);
	
	RAMADDR<=	RAM_VRAMF(SDAWIDTH-1 downto 16) & GDC_ADDR(13 downto 0) & (GDC_ADDR(15 downto 14)-1)when GRAMSEL='0' else
					RAM_VRAMB(SDAWIDTH-1 downto 16) & GDC_ADDR(13 downto 0) & (GDC_ADDR(15 downto 14)-1);
end rtl;