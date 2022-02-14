LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DMAUADDR	is
port(
	CS		:in std_logic;
	ADDR	:in std_logic_vector(1 downto 0);
	CSMODE:in std_logic;
	WR		:in std_logic;
	WDATA	:in std_logic_vector(7 downto 0);
	
	CURCH	:in integer range 0 to 4;
	CARRY	:in std_logic_vector(3 downto 0);
	ADDRU	:out std_logic_vector(7 downto 0);
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end DMAUADDR;

architecture rtl of DMAUADDR is
signal	UADDR0	:std_logic_vector(7 downto 0);
signal	UADDR1	:std_logic_vector(7 downto 0);
signal	UADDR2	:std_logic_vector(7 downto 0);
signal	UADDR3	:std_logic_vector(7 downto 0);
signal	INCEN		:std_logic_vector(3 downto 0);
begin
	process(clk,rstn)begin
		if(rstn='0')then
			UADDR0<=(others=>'0');
			UADDR1<=(others=>'0');
			UADDR2<=(others=>'0');
			UADDR3<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(CS='1' and WR='1')then
				case ADDR is
				when "00" =>
					UADDR1<=WDATA;
				when "01" =>
					UADDR2<=WDATA;
				when "10" =>
					UADDR3<=WDATA;
				when "11" =>
					UADDR0<=WDATA;
				when others =>
				end case;
			else
				for i in 0 to 3 loop
					if(CARRY(i)='1' and INCEN(i)='1')then
						case i is
						when 0 =>
							UADDR0<=UADDR0+"0001";
						when 1 =>
							UADDR1<=UADDR1+"0001";
						when 2 =>
							UADDR2<=UADDR2+"0001";
						when 3 =>
							UADDR3<=UADDR3+"0001";
						when others =>
						end case;
					end if;
				end loop;
			end if;
		end if;
	end process;
	
	process(clk,rstn)begin
		if(rstn='0')then
			INCEN<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(CSMODE='1' and WR='1')then
				case WDATA(1 downto 0) is
				when "00" =>
					INCEN(0)<=WDATA(2);
				when "01" =>
					INCEN(1)<=WDATA(2);
				when "10" =>
					INCEN(2)<=WDATA(2);
				when "11" =>
					INCEN(3)<=WDATA(2);
				when others =>
				end case;
			end if;
		end if;
	end process;
				
	ADDRU<=	UADDR0	when CURCH=0 else
				UADDR1	when CURCH=1 else
				UADDR2	when CURCH=2 else
				UADDR3	when CURCH=3 else
				(others=>'1');
	
end rtl;
						