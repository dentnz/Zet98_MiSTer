LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity nvram98 is
port(
	addr	:in std_logic_vector(2 downto 0);
	cs		:in std_logic;
	wrdat	:in std_logic_vector(7 downto 0);
	wr		:in std_logic;
	rd		:in std_logic;
	wprot	:in std_logic;
	rddat	:out std_logic_vector(7 downto 0);
	ack		:out std_logic;
	
	clk		:in std_logic;
	mrstn	:in std_logic;
	rstn	:in std_logic
);
end nvram98;

architecture rtl of nvram98 is
subtype DAT_LAT_TYPE is std_logic_vector(7 downto 0); 
type DAT_LAT_ARRAY is array (natural range <>) of DAT_LAT_TYPE; 
signal	RAM	:DAT_LAT_ARRAY(0 to 7);
signal	iaddr	:integer range 0 to 7;
signal	laddr	:std_logic_vector(2 downto 0);

type state_t is(
	st_IDLE,
	st_BUSY,
	st_ACK
);
signal	state	:state_t;

begin
	iaddr<=conv_integer(addr);

	process(clk,mrstn)begin
		if(mrstn='0')then
			RAM(0)<="01001100";
			RAM(1)<="01101000";
			RAM(2)<="00000100";
			RAM(3)<="00000000";
			RAM(4)<="00000001";
			RAM(5)<="00001000";
		elsif(clk' event and clk='1')then
			rddat<=RAM(iaddr);
			if(cs='1' and wprot='1' and wr='1')then
				RAM(iaddr)<=wrdat;
			end if;
		end if;
	end process;
	
	process(clk,rstn)begin
		if(rstn='0')then
			state<=st_IDLE;
			ack<='0';
		elsif(clk' event and clk='1')then
			ack<='0';
			case state is
			when st_IDLE =>
				if(cs='1' and (rd='1' or wr='1'))then
					state<=st_BUSY;
					laddr<=addr;
				end if;
			when st_BUSY =>
				state<=st_ACK;
				ack<='1';
			when st_ACK =>
--				ack<='1';
				if((cs='0' or (rd='0' and wr='0')) or laddr/=addr)then
					state<=st_IDLE;
				end if;
			when others =>
				state<=st_IDLE;
			end case;
		end if;
	end process;

end rtl;
