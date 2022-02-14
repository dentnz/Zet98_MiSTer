LIBRARY	IEEE,work;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FDDIBM is
port(
	CS	:in std_logic;
	RD	:in std_logic;
	WR	:in std_logic;
	
	WRDAT	:in std_logic_vector(7 downto 0);
	RDDAT	:out std_logic_vector(7 downto 0);
	DOE		:out std_logic;
	
	DSn		:in std_logic_vector(1 downto 0);
	DENn	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end FDDIBM;

architecture rtl of FDDIBM is
signal	IBMSEL	:std_logic_vector(3 downto 0);
signal	DRIVESEL	:std_logic_vector(1 downto 0);
constant IBMOK	:std_logic_vector(3 downto 0)	:="0011";
signal	iSEL	:integer range 0 to 3;
signal	iDS		:integer range 0 to 3;
begin

	process(clk,rstn)begin
		if(rstn='0')then
			IBMSEL<="1000";
			DRIVESEL<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(CS='1' and WR='1')then
				DRIVESEL<=WRDAT(6 downto 5);
				if(WRDAT(4)='1')then
					case  WRDAT(6 downto 5) is
					when "00" =>
						IBMSEL(0)<=WRDAT(0);
					when "01" =>
						IBMSEL(1)<=WRDAT(0);
					when "10" =>
						IBMSEL(2)<=WRDAT(0);
					when others =>
					end case;
				end if;
			end if;
		end if;
	end process;
	
	iSEL<=conv_integer(DRIVESEL);
	
	RDDAT<="111" & IBMOK(iSEL) & "111" & IBMSEL(iSEL);
	DOE<='1' when CS='1' and RD='1' else '0';
	
	iDS<=	0	when DSn="10" else
			1	when DSn="01" else
			3;
	
	DENn<=IBMSEL(iDS);
end rtl;
