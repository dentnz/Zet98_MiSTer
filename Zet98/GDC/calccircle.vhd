LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity calccircle is
generic(
	dwidth	:integer	:=8
);
port(
	r		:in std_logic_vector(dwidth-1 downto 0);
	x		:in std_logic_vector(dwidth-1 downto 0);
	calc	:in std_logic;
	
	y		:out std_logic_vector(dwidth-1 downto 0);
	busy	:out std_logic;
	done	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end calccircle;

architecture rtl of calccircle is
signal	sqr		:std_logic_vector((dwidth*2)-1 downto 0);
signal	sqx		:std_logic_vector((dwidth*2)-1 downto 0);
signal	sqy		:std_logic_vector((dwidth*2)-1 downto 0);
signal	mulbusyr	:std_logic;
signal	mulbusyx	:std_logic;
signal	sqrtcalc	:std_logic;
signal	sqrtbusy	:std_logic;


type state_t is(
	st_idle,
	st_sq,
	st_sqrt
);
signal	state	:state_t;

component MULTI
	generic(
		Awidth	:integer	:=8;
		Bwidth	:integer	:=8
	);
	port(
		A		:in std_logic_vector(Awidth-1 downto 0);
		B		:in std_logic_vector(Bwidth-1 downto 0);
		write	:in std_logic;
		
		Q		:out std_logic_vector(Awidth+Bwidth-1 downto 0);
		busy	:out std_logic;
		done	:out std_logic;
		
		clk		:in std_logic;
		rstn	:in std_logic
	);
end component;

component sqrt
generic(
	qwidth	:integer	:=16
);
port(
	num		:in std_logic_vector(qwidth*2-1 downto 0);
	calc	:in std_logic;
	
	q		:out std_logic_vector(qwidth-1 downto 0);
	busy	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end component;

begin

	r2	:multi generic map(dwidth,dwidth) port map(
		A		=>r,
		B		=>r,
		write	=>calc,
		
		Q		=>sqr,
		busy	=>mulbusyr,
		
		clk		=>clk,
		rstn	=>rstn
	);
	
	x2	:multi generic map(dwidth,dwidth) port map(
		A		=>x,
		B		=>x,
		write	=>calc,
		
		Q		=>sqx,
		busy	=>mulbusyx,
		
		clk		=>clk,
		rstn	=>rstn
	);
	
	sqy<=sqr-sqx;
	
	yc	:sqrt generic map(dwidth) port map(
		num		=>sqy,
		calc	=>sqrtcalc,
		
		q		=>y,
		busy	=>sqrtbusy,
		
		clk		=>clk,
		rstn	=>rstn
	);


	process(clk,rstn)begin
		if(rstn='0')then
			state<=st_idle;
			sqrtcalc<='0';
			done<='0';
		elsif(clk' event and clk='1')then
			sqrtcalc<='0';
			done<='0';
			if(calc='1')then
				state<=st_sq;
			else
				case state is
				when st_sq =>
					if(mulbusyx='0' and mulbusyr='0')then
						sqrtcalc<='1';
						state<=st_sqrt;
					end if;
				when st_sqrt =>
					if(sqrtbusy='0')then
						done<='1';
						state<=st_idle;
					end if;
				when others =>
					state<=st_idle;
				end case;
			end if;
		end if;
	end process;
	
	busy<=	'1' when calc='1' else
			'0' when state=st_idle else
			'1';

end rtl;
