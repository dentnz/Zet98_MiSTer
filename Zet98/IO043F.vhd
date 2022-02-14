LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IO043F is
port(
	CS		:in std_logic;
	WR		:in std_logic;
	WDAT	:in std_logic_vector(7 downto 0);
	
	NECEMSSEL	:out std_logic;
	BNK89SEL	:out std_logic;
	SASIRAMEN	:out std_logic;
	SCSIRAMEN	:out std_logic;
	CACHEFLASH	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end IO043F;

architecture rtl of IO043F is
begin
	process(clk,rstn)begin
		if(rstn='0')then
			NECEMSSEL<='0';
			BNK89SEL<='0';
			SASIRAMEN<='0';
			SCSIRAMEN<='0';
			CACHEFLASH<='0';
		elsif(clk' event and clk='1')then
			CACHEFLASH<='0';
			if(CS='1' and WR='1')then
				case WDAT is
				when x"20" =>
					NECEMSSEL<='0';
				when x"22" =>
					NECEMSSEL<='1';
				when x"80" =>
					BNK89SEL<='0';
				when x"82" =>
					BNK89SEL<='1';
				when x"c0" =>
					SASIRAMEN<='0';
					SCSIRAMEN<='0';
				when x"c2" =>
					SASIRAMEN<='1';
				when x"c4" =>
					SCSIRAMEN<='1';
				when x"a0" =>
					CACHEFLASH<='1';
				when others =>
				end case;
			end if;
		end if;
	end process;
	
end rtl;
