LIBRARY	IEEE,work;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mouseint is
generic(
	SYSFREQ	:integer	:=20000
);
port(
	cs		:in std_logic;
	wr		:in std_logic;
	wrdat	:in std_logic_vector(7 downto 0);
	
	int		:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end mouseint;

architecture rtl of mouseint is
component sftgen
generic(
	maxlen	:integer	:=100
);
port(
	len		:in integer range 0 to maxlen;
	sft		:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end component;

signal	sft	:std_logic;
signal	count	:integer range 0 to 7;
constant sftlen	:integer	:=(SYSFREQ*1000/150)-1;
signal	cval	:integer range 0 to 7;
begin
	psft	:sftgen generic map(sftlen)port map(sftlen,sft,clk,rstn);
	
	process(clk,rstn)begin
		if(rstn='0')then
			int<='0';
			count<=0;
		elsif(clk' event and clk='1')then
			int<='0';
			if(sft='1')then
				if(count>0)then
					count<=count-1;
				else
					int<='1';
					count<=cval;
				end if;
			end if;
		end if;
	end process;
	
	process(clk,rstn)begin
		if(rstn='0')then
			cval<=0;
		elsif(clk' event and clk='1')then
			if(cs='1' and wr='1')then
				case wrdat is
				when x"00" =>
					cval<=0;
				when x"01" =>
					cval<=1;
				when x"02" =>
					cval<=3;
				when x"03" =>
					cval<=7;
				when others =>
				end case;
			end if;
		end if;
	end process;

end rtl;
