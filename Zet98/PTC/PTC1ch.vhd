LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PTC1ch is
port(
	RD		:in std_logic;
	WR		:in std_logic;
	RDAT	:out std_logic_vector(7 downto 0);
	WDAT	:in std_logic_vector(7 downto 0);
	OE		:out std_logic;
	
	RWMODE	:in std_logic_vector(1 downto 0);
	CNTLAT	:in std_logic;
	OPMODE	:in std_logic_vector(2 downto 0);
	OPBCD	:in std_logic;
	
	CNTIN	:in std_logic;
	TRIG	:in std_logic;
	CNTOUT	:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end PTC1ch;

architecture rtl of PTC1ch is
signal	CURCOUNT	:std_logic_vector(15 downto 0);
signal	RETCOUNT	:std_logic_vector(15 downto 0);
signal	LATCOUNT	:std_logic_vector(15 downto 0);
signal	DATH_Ln		:std_logic;
signal	DECVAL		:std_logic_vector(15 downto 0);
signal	HALFVAL		:std_logic_vector(15 downto 0);
signal	CNTBGN		:std_logic;
begin

	process(clk,rstn)
	variable lTRIG	:std_logic;
	begin
		if(rstn='0')then
			CNTBGN<='0';
			lTRIG:='0';
		elsif(clk' event and clk='1')then
			CNTBGN<='0';
			if(lTRIG='0' and TRIG='1')then
				CNTBGN<='1';
			end if;
			lTRIG:=TRIG;
		end if;
	end process;

	process(clk,rstn)
	variable lRD,lWR	:std_logic;
	begin
		if(rstn='0')then
			DATH_Ln<='0';
			lRD:='0';
			lWR:='0';
		elsif(clk' event and clk='1')then
			case RWMODE is
			when "11" =>
				if((lRD='1' and RD='0') or (lWR='1' and WR='0'))then
					DATH_Ln<=not DATH_Ln;
				end if;
			when "10" =>
				DATH_Ln<='1';
			when "01" =>
				DATH_Ln<='0';
			when others =>
			end case;
			lRD:=RD;
			lWR:=WR;
		end if;
	end process;

	process(clk,rstn)begin
		if(rstn='0')then
			LATCOUNT<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(CNTLAT='1')then
				LATCOUNT<=CURCOUNT;
			end if;
		end if;
	end process;

	process(clk,rstn)begin
		if(rstn='0')then
			CURCOUNT<=(others=>'0');
			RETCOUNT<=(others=>'0');
			CNTOUT<='0';
		elsif(clk' event and clk='1')then
			case OPMODE is
			when "000" =>
				if(WR='1')then
					if(DATH_Ln='0')then
						CURCOUNT(7 downto 0)<=WDAT;
						RETCOUNT(7 downto 0)<=WDAT;
					else
						CURCOUNT(15 downto 8)<=WDAT;
						RETCOUNT(15 downto 8)<=WDAT;
					end if;
					CNTOUT<='0';
				elsif(CNTIN='1')then
					if(CURCOUNT=x"0001")then
						CNTOUT<='1';
					else
						CURCOUNT<=DECVAL;
					end if;
				end if;
			when "100" =>
				if(WR='1')then
					if(DATH_Ln='0')then
						CURCOUNT(7 downto 0)<=WDAT;
						RETCOUNT(7 downto 0)<=WDAT;
					else
						CURCOUNT(15 downto 8)<=WDAT;
						RETCOUNT(15 downto 8)<=WDAT;
					end if;
					CNTOUT<='0';
				elsif(CNTIN='1')then
					if(CURCOUNT>x"0000")then
						if(CURCOUNT=x"0001")then
							CNTOUT<='1';
						end if;
						CURCOUNT<=DECVAL;
					else
						CNTOUT<='0';
					end if;
				end if;
			when "001" | "101" =>
				if(WR='1')then
					if(DATH_Ln='0')then
						RETCOUNT(7 downto 0)<=WDAT;
					else
						RETCOUNT(15 downto 8)<=WDAT;
					end if;
				elsif(CNTBGN='1')then
					CURCOUNT<=RETCOUNT;
					CNTOUT<='0';
				elsif(CNTIN='1')then
					if(CURCOUNT>x"0000")then
						if(CURCOUNT=x"0001")then
							CNTOUT<='1';
						end if;
						CURCOUNT<=DECVAL;
					elsif(OPMODE="101")then
						CNTOUT<='0';
					end if;
				end if;
			when "010" | "110" =>
				if(WR='1')then
					if(DATH_Ln='0')then
						CURCOUNT(7 downto 0)<=WDAT;
						RETCOUNT(7 downto 0)<=WDAT;
					else
						CURCOUNT(15 downto 8)<=WDAT;
						RETCOUNT(15 downto 8)<=WDAT;
					end if;
					CNTOUT<='0';
				elsif(CNTIN='1')then
					if(CURCOUNT=x"0001")then
						CNTOUT<='1';
						CURCOUNT<=RETCOUNT;
					else
						CNTOUT<='0';
						CURCOUNT<=DECVAL;
					end if;
				end if;
			when "011" | "111" =>
				if(WR='1')then
					if(DATH_Ln='0')then
						CURCOUNT(7 downto 0)<=WDAT;
						RETCOUNT(7 downto 0)<=WDAT;
					else
						CURCOUNT(15 downto 8)<=WDAT;
						RETCOUNT(15 downto 8)<=WDAT;
					end if;
				elsif(CNTIN='1')then
					if(CURCOUNT=x"0001")then
						CURCOUNT<=RETCOUNT;
					else
						CURCOUNT<=DECVAL;
					end if;
				end if;
				if(CURCOUNT<HALFVAL)then
					CNTOUT<='1';
				else
					CNTOUT<='0';
				end if;
			when others =>
			end case;
		end if;
	end process;
					
	process(CURCOUNT,OPBCD)begin
		if(OPBCD='1')then
			if(CURCOUNT(3 downto 0)/=x"0")then
				DECVAL<=CURCOUNT-x"0001";
			else
				if(CURCOUNT(7 downto 4)/="0")then
					DECVAL<=CURCOUNT(15 downto 8) & (CURCOUNT(7 downto 4)-x"1") & x"0";
				else
					if(CURCOUNT(11 downto 8)/=x"0")then	
						DECVAL<=CURCOUNT(15 downto 12) & (CURCOUNT(11 downto 8)-x"1") & x"00";
					else
						DECVAL<=(CURCOUNT(15 downto 12) - x"1") & x"000";
					end if;
				end if;
			end if;
		else
			DECVAL<=CURCOUNT-x"0001";
		end if;
	end process;
	
	process(RETCOUNT,OPBCD)
	variable	tmp100,tmp10,tmp1	:std_logic_vector(4 downto 0);
	begin
		if(OPBCD='1')then
			HALFVAL(15 downto 12)<='0' & RETCOUNT(15 downto 13);
			if(RETCOUNT(12)='1')then
				tmp100:=('0' & RETCOUNT(11 downto 8))+"01010";
			else
				tmp100:='0' & RETCOUNT(11 downto 8);
			end if;
			HALFVAL(11 downto 8)<=tmp100(4 downto 1);
			if(tmp100(0)='1')then
				tmp10:=('0' & RETCOUNT(7 downto 4))+"01010";
			else
				tmp10:='0' & RETCOUNT(7 downto 4);
			end if;
			HALFVAL(7 downto 4)<=tmp10(4 downto 1);
			if(tmp10(0)='1')then
				tmp1:=('0' & RETCOUNT(3 downto 0))+"01010";
			else
				tmp1:='0' & RETCOUNT(3 downto 0);
			end if;
			HALFVAL(3 downto 0)<=tmp1(4 downto 1);
		else
			HALFVAL<='0' & RETCOUNT(15 downto 1);
		end if;
	end process;
	
	RDAT<=	LATCOUNT(7 downto 0) when DATH_Ln='0' else
			LATCOUNT(15 downto 8);
	OE<=RD;

end rtl;
