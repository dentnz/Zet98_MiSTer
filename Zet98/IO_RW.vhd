LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IO_RW is
generic(
	IOADR	:std_logic_vector(15 downto 0)	:=x"0000";
	RSTVAL	:std_logic_vector(7 downto 0)	:=x"00"
);
port(
	ADR		:in std_logic_vector(15 downto 0);
	RD		:in std_logic;
	WR		:in std_logic;
	DATIN	:in std_logic_vector(7 downto 0);
	DATOUT	:out std_logic_vector(7 downto 0);
	DATOE	:out std_logic;
	
	bit7	:out std_logic;
	bit6	:out std_logic;
	bit5	:out std_logic;
	bit4	:out std_logic;
	bit3	:out std_logic;
	bit2	:out std_logic;
	bit1	:out std_logic;
	bit0	:out std_logic;

	clk		:in std_logic;
	rstn	:in std_logic
);
end IO_RW;

architecture MAIN of IO_RW is
signal	lWR		:std_logic;
signal	DATb	:std_logic_vector(7 downto 0);
begin

	process(clk,rstn)begin
		if(rstn='0')then
			bit7<=RSTVAL(7);
			bit6<=RSTVAL(6);
			bit5<=RSTVAL(5);
			bit4<=RSTVAL(4);
			bit3<=RSTVAL(3);
			bit2<=RSTVAL(2);
			bit1<=RSTVAL(1);
			bit0<=RSTVAL(0);
			DATOUT<=RSTVAL;
		elsif(clk' event and clk='1')then
			if(ADR=IOADR and WR='1' and lWR='0')then
				bit7<=DATIN(7);
				bit6<=DATIN(6);
				bit5<=DATIN(5);
				bit4<=DATIN(4);
				bit3<=DATIN(3);
				bit2<=DATIN(2);
				bit1<=DATIN(1);
				bit0<=DATIN(0);
				DATOUT<=DATIN;
			end if;
		lWR<=WR;
		end if;
	end process;

	DATOE<='1' when ADR=IOADR and RD='1' else '0';
	
end MAIN;
