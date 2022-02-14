library IEEE;
use IEEE.std_logic_1164.all;

entity DIGIFILTER is
	generic(
		TIME	:integer	:=2;
		DEF		:std_logic	:='0'
	);
	port(
		D	:in std_logic;
		Q	:out std_logic;

		clk	:in std_logic;
		rstn :in std_logic
	);
end DIGIFILTER;

architecture MAIN of DIGIFILTER is
signal	LAST	:std_logic_vector(TIME-1 downto 0);
begin
	process(clk,rstn)
	variable TMPA,TMPO	:std_logic;
	begin
		if(rstn='0')then
			LAST<=(others=>DEF);
			Q<=DEF;
		elsif(clk='1' and clk' event)then
			TMPA:=LAST(0);
			TMPO:=LAST(0);
			for i in 0 to TIME-1 loop
				TMPA:=TMPA and LAST(i);
				TMPO:=TMPO or LAST(i);
			end loop;		
			if(TMPA=TMPO)then
				Q<=LAST(0);
			end if;
            if(TIME>2)then
			    LAST(TIME-2 downto 0)<=LAST(TIME-1 downto 1);
            elsif(TIME=2)then
                LAST(0)<=LAST(1);
            end if;
			LAST(TIME-1)<=D;
		end if;
	end process;
end MAIN;
