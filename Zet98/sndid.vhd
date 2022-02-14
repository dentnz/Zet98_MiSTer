LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;
	use ieee.std_logic_arith.all;

entity sndid is
generic(
	ID		:std_logic_vector(3 downto 0)	:=x"f"
);

port(
	CS		:in std_logic;
	RD		:in std_logic;
	WR		:in std_logic;
	
	RDDAT	:out std_logic_vector(7 downto 0);
	DOE	:out std_logic;
	WRDAT	:in std_logic_vector(7 downto 0);
	
	OPNAMSK	:out std_logic;
	OPNAEXT	:out std_logic;
	
	clk	:in std_logic;
	rstn	:in std_logic
);
end sndid;

architecture rtl of sndid is
signal	conf	:std_logic_vector(3 downto 0);
begin

	process(clk,rstn)begin
		if(rstn='0')then
			conf<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(CS='1' and WR='1')then
				conf<=WRDAT(3 downto 0);
			end if;
		end if;
	end process;
	
	RDDAT<=ID & conf;
	DOE<='1' when CS='1' and RD='1' else '0';
	
	OPNAMSK<=conf(1);
	OPNAEXT<=conf(0);

end rtl;

	