LIBRARY	IEEE;
USE	IEEE.STD_LOGIC_1164.ALL;
USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity div is
generic(
	bitwidth	:integer	:=16
);
port(
	A		:in std_logic_vector(bitwidth-1 downto 0);
	D		:in std_logic_vector(bitwidth-1 downto 0);
	
	Q		:out std_logic_vector(bitwidth-1 downto 0);
	R		:out std_logic_vector(bitwidth-1 downto 0);
	
	start	:in std_logic;
	busy	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end div;

architecture rtl of div is
signal	bcount :integer range 0 to bitwidth;
signal	Qb	:std_logic_vector(bitwidth-1 downto 0);
signal	Rb	:std_logic_vector(bitwidth-1 downto 0);

begin

	process(clk,rstn)
	variable	Rv	:std_logic_vector(bitwidth-1 downto 0);
	begin
		if(rstn='0')then
			bcount<=0;
			Qb<=(others=>'0');
			Rb<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(start='1')then
				bcount<=bitwidth;
				Qb<=(others=>'0');
				Rb<=(others=>'0');
			elsif(bcount>0)then
				Rv(bitwidth-1 downto 1):=Rb(bitwidth-2 downto 0);
				Rv(0):=A(bcount-1);
				if(Rv>=D)then
					Rv:=Rv-D;
					Qb(bcount-1)<='1';
				else
					Qb(bcount-1)<='0';
				end if;
				Rb<=Rv;
				bcount<=bcount-1;
			end if;
		end if;
	end process;
	
	Q<=Qb;
	R<=Rb;
	
	busy<=	'1' when start='1' else
			'1' when bcount>0 else
			'0';
			
end rtl;
		
	