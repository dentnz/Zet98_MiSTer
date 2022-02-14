LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fixtimer is
generic(
	timerlen	:integer	:=200;
	pulsewidth	:integer	:=2
);
port(
	start	:in std_logic;
	sft		:in std_logic;
	
	pulse	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end fixtimer;

architecture rtl of fixtimer is
type state_t is(
	st_idle,
	st_timer,
	st_pulse
);
signal state	:state_t;
signal	count	:integer range 0 to timerlen-1;
signal	lstart	:std_logic;
begin

	process(clk,rstn)begin
		if(rstn='0')then
			state<=st_idle;
			count<=0;
			pulse<='0';
			lstart<='0';
		elsif(clk' event and clk='1')then
			case state is
			when st_idle =>
				if(start='1' and lstart='0')then
					count<=timerlen-1;
					state<=st_timer;
				end if;
			when st_timer =>
				if(sft='1')then
					if(count>0)then
						count<=count-1;
					else
						pulse<='1';
						count<=pulsewidth-1;
						state<=st_pulse;
					end if;
				end if;
			when st_pulse =>
				if(count>0)then
					count<=count-1;
				else
					pulse<='0';
					state<=st_idle;
				end if;
			when others =>
				state<=st_idle;
			end case;
			lstart<=start;
		end if;
	end process;
end rtl;
