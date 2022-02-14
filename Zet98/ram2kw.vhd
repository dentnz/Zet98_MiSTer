LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram2kw is
port(
	cs		:in std_logic;
	addr	:in std_logic_vector(10 downto 0);
	sel		:in std_logic_vector(1 downto 0);
	we		:in std_logic;
	wdat	:in std_logic_vector(15 downto 0);
	odat	:out std_logic_vector(15 downto 0);
	oe		:out std_logic_vector(1 downto 0);
	ack		:out std_logic;
	clk		:in std_logic;
	rstn	:in std_logic
);
end ram2kw;

architecture rtl of ram2kw is
signal	wrdat	:std_logic_vector(15 downto 0);
signal	rddat	:std_logic_vector(15 downto 0);
signal	wes		:std_logic;
signal	laddr	:std_logic_vector(10 downto 0);

type state_t is(
	st_IDLE,
	st_BUSY,
	st_ACK
);

signal	state	:state_t;

component ram2kw_alt
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END component;
begin

	wrdat(7 downto 0)<=wdat(7 downto 0) when sel(0)='1' else rddat(7 downto 0);
	wrdat(15 downto 8)<=wdat(15 downto 8) when sel(1)='1' else rddat(15 downto 8);
	wes<=cs and we;
	
	ram	:ram2kw_alt port map(addr,clk,wrdat,wes,rddat);
	oe<=sel when cs='1' and we='0' else "00";
	odat<=rddat;
	
	process(clk,rstn)begin
		if(rstn='0')then
			state<=st_IDLE;
			ack<='0';
		elsif(clk' event and clk='1')then
			ack<='0';
			case state is
			when st_IDLE =>
				if(cs='1')then
					state<=st_BUSY;
					laddr<=addr;
				end if;
			when st_BUSY =>
				state<=st_ACK;
				ack<='1';
			when st_ACK =>
--				ack<='1';
				if(cs='0' or laddr/=addr)then
					state<=st_IDLE;
				end if;
			when others =>
				state<=st_IDLE;
			end case;
		end if;
	end process;
	
end rtl;