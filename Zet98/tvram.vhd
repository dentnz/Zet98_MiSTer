LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tvram is
port(
	cs		:in std_logic;
	caddr	:in std_logic_vector(11 downto 0);
	sel		:in std_logic_vector(1 downto 0);
	rd		:in std_logic;
	wr		:in std_logic;
	wdat	:in std_logic_vector(15 downto 0);
	odat	:out std_logic_vector(15 downto 0);
	oe		:out std_logic_vector(1 downto 0);
	ack		:out std_logic;
	cclk	:in std_logic;
	
	vaddr	:in std_logic_vector(11 downto 0);
	vdat	:out std_logic_vector(15 downto 0);
	vclk	:in std_logic;
	
	rstn	:in std_logic
);
end tvram;

architecture rtl of tvram is
signal	wes		:std_logic;
signal	laddr	:std_logic_vector(11 downto 0);

type state_t is(
	st_IDLE,
	st_BUSY,
	st_ACK
);

signal	state	:state_t;

component dpram4kw
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		byteena_a		: IN STD_LOGIC_VECTOR (1 DOWNTO 0) :=  (OTHERS => '1');
		clock_a		: IN STD_LOGIC  := '1';
		clock_b		: IN STD_LOGIC ;
		data_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END component;
begin

	wes<=cs and wr;
	
	ram	:dpram4kw port map(caddr,vaddr,sel,cclk,vclk,wdat,x"0000",wes,'0',odat,vdat);
	oe<=sel when cs='1' and rd='1' else "00";
	
	process(cclk,rstn)begin
		if(rstn='0')then
			state<=st_IDLE;
			ack<='0';
		elsif(cclk' event and cclk='1')then
			ack<='0';
			case state is
			when st_IDLE =>
				if(cs='1' and (rd='1' or wr='1'))then
					state<=st_BUSY;
					laddr<=caddr;
				end if;
			when st_BUSY =>
				state<=st_ACK;
				ack<='1';
			when st_ACK =>
--				ack<='1';
				if((cs='0' or (rd='0' and wr='0')) or laddr/=caddr)then
					state<=st_IDLE;
				end if;
			when others =>
				state<=st_IDLE;
			end case;
		end if;
	end process;
	
end rtl;