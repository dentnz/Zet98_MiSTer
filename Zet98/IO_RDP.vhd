LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IO_RDP is
port(
	CS		:in std_logic;
	RD		:in std_logic;
	DATOUT:out std_logic_vector(7 downto 0);
	DATOE	:out std_logic;
	
	bit7	:in std_logic;
	bit6	:in std_logic;
	bit5	:in std_logic;
	bit4	:in std_logic;
	bit3	:in std_logic;
	bit2	:in std_logic;
	bit1	:in std_logic;
	bit0	:in std_logic;

	clk		:in std_logic;
	rstn	:in std_logic
);
end IO_RDP;

architecture MAIN of IO_RDP is
begin

	process(clk,rstn)begin
		if(rstn='0')then
			DATOUT<=(others=>'0');
		elsif(clk' event and clk='1')then
			DATOUT<=bit7 & bit6 & bit5 & bit4 & bit3 & bit2 & bit1 & bit0;
		end if;
	end process;

	DATOE<='1' when CS='1' and RD='1' else '0';
	
end MAIN;
