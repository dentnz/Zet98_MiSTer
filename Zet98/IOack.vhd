LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IOack is
port(
	tga		:in std_logic;
	stb		:in std_logic;
	addr	:in std_logic_vector(15 downto 1);
	sel		:in std_logic_vector(1 downto 0);
	dir		:in std_logic;
	DMAen		:in std_logic;
	iord	:out std_logic;
	iowr	:out std_logic;
	waitn	:in std_logic;
	ack		:out std_logic;
	clk		:in std_logic;
	rstn	:in std_logic
);
end IOack;

architecture rtl of IOack is
signal	laddr	:std_logic_vector(15 downto 1);
signal	lsel	:std_logic_vector(1 downto 0);
signal	ie		:std_logic;
type state_t is(
	st_IDLE,
	st_BUSY,
	st_ACK
);

signal	state	:state_t;
begin
	ie<=(not DMAen) and stb and tga;
	iord<='0' when DMAEN='1' else '1' when dir='0' and ie='1' else '0';
	iowr<='0' when DMAEN='1' else '1' when dir='1' and ie='1' else '0';
	
	process(clk,rstn)
	variable nwait	:integer range 0 to 3;
	begin
		if(rstn='0')then
			state<=st_IDLE;
			ack<='0';
		elsif(clk' event and clk='1')then
--			ack<='0';
			if(nwait>0)then
				nwait:=nwait-1;
			else
				case state is
				when st_IDLE =>
					if(ie='1')then
						state<=st_BUSY;
						laddr<=addr;
						lsel<=sel;
						nwait:=1;
					end if;
				when st_BUSY =>
					if(waitn='1')then
						state<=st_ACK;
						ack<='1';
					end if;
				when st_ACK =>
	--				ack<='1';
					if(ie='0' or laddr/=addr or lsel/=sel)then
						ack<='0';
						state<=st_IDLE;
					end if;
				when others =>
					state<=st_IDLE;
				end case;
			end if;
		end if;
	end process;
	
end rtl;