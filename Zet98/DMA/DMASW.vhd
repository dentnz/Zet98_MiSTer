LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;

entity DMASW is
port(
	cpustb	:in std_logic;
	
	dmabreq	:in std_logic;
	
	dmaen	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end DMASW;

architecture rtl of DMASW is
signal	dmaenb	:std_logic;

begin
	process(clk,rstn)
	variable lstb	:std_logic;
	begin
		if(rstn='0')then
			dmaenb<='0';
			lstb:='0';
		elsif(clk' event and clk='1')then
			if(dmabreq='1')then
				if(cpustb='0' and lstb='1')then
					dmaenb<='1';
				end if;
			elsif(dmabreq='0')then
				dmaenb<='0';
			end if;
			lstb:=cpustb;
		end if;
	end process;
	
	dmaen<=dmaenb;
	
end rtl;