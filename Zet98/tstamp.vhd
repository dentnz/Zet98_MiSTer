LIBRARY	IEEE,work;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tstamp is
generic(
	sysclk	:integer 	:=20000;	--kHz
	unit	:integer	:=3260		--nsec
);
port(
	addr	:in std_logic;
	ce		:in std_logic;
	rd		:in std_logic;
	wr		:in std_logic;
	rddat	:out std_logic_vector(15 downto 0);
	doe		:out std_logic;
	waitn	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end tstamp;

architecture rtl of tstamp is
signal	counter	:std_logic_vector(23 downto 0);
constant pcmax	:integer	:=unit*sysclk/1000000;
signal	pcount	:integer range 0 to pcmax-1;
signal	ps		:std_logic;
signal	wcount	:integer range 0 to 3;

begin
	process(clk,rstn)begin
		if(rstn='0')then
			pcount<=pcmax-1;
			ps<='0';
		elsif(clk' event and clk='1')then
			ps<='0';
			if(pcount>0)then
				pcount<=pcount-1;
			else
				ps<='1';
				pcount<=pcmax-1;
			end if;
		end if;
	end process;
	
	process(clk,rstn)begin
		if(rstn='0')then
			counter<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(ps='1')then
				counter<=counter+1;
			end if;
		end if;
	end process;
	
	rddat<=	counter(15 downto 0) when addr='0' else
			counter(23 downto 8) when addr='1' else
			(others=>'0');
	
	process(clk,rstn)begin
		if(rstn='0')then
			wcount<=3;
		elsif(clk' event and clk='1')then
			if(ce='1' and wr='1')then
				if(ps='1' and wcount>0)then
					wcount<=wcount-1;
				end if;
			else
				wcount<=3;
			end if;
		end if;
	end process;
	
--	waitn<='0' when ce='1' and wr='1' and addr='1' and wcount>0 else '1';
	waitn<='1';
	doe<='1' when ce='1' and rd='1' else '0';
end rtl;
