library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sqrt is
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
end sqrt;

architecture rtl of sqrt is
signal	res	:std_logic_vector(qwidth*2-1 downto 0);
signal	numx:std_logic_vector(qwidth*2-1 downto 0);
signal	nbit:std_logic_vector(qwidth*2-1 downto 0);
constant allzero	:std_logic_vector(qwidth*2-1 downto 0):=(others=>'0');
signal	flag	:std_logic;
begin
	process(clk,rstn)begin
		if(rstn='0')then
			res<=(others=>'0');
			numx<=(others=>'0');
			nbit<=(others=>'0');
			flag<='0';
		elsif(clk' event and clk='1')then
			if(calc='1')then
				numx<=num;
				res<=(others=>'0');
				nbit<=(others=>'0');
				nbit(qwidth*2-2)<='1';
				flag<='1';
			elsif(nbit/=allzero)then
				if(flag='1')then
					if(nbit>numx)then
						nbit(qwidth*2-1 downto 0)<="00" & nbit(qwidth*2-1 downto 2);
					else
						flag<='0';
					end if;
				else
					if(numx>=(res+nbit))then
						numx<=numx-(res+nbit);
						res<=('0' & res(qwidth*2-1 downto 1))+nbit;
					else
						res<=('0' & res(qwidth*2-1 downto 1));
					end if;
					nbit<="00" &nbit(qwidth*2-1 downto 2);
				end if;
			end if;
		end if;
	end process;
	
	q<=res(qwidth-1 downto 0);
	busy<=	'1' when calc='1' else
			'1' when nbit/=allzero else
			'0';
	
end rtl;
