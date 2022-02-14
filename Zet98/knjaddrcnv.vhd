LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity knjaddrcnv is
port(
	kcode	:in std_logic_vector(15 downto 0);
	cline	:in std_logic_vector(3 downto 0);

	mon		:out std_logic_vector(15 downto 0);
	romsel	:out std_logic_vector(1 downto 0);
	romaddr	:out std_logic_vector(16 downto 0)
);
end knjaddrcnv;

architecture rtl of knjaddrcnv is
signal	mcode	:std_logic_vector(15 downto 0);
signal	iskanji	:std_logic;
signal	l_rn	:std_logic;
signal	addr	:std_logic_vector(15 downto 0);
begin
	
	iskanji<='0' when kcode(15 downto 8)=x"00" else '1';
	l_rn<=kcode(15);
	
	mcode<=kcode(7 downto 0) & '0' & kcode(14 downto 8);
	
	process(mcode)
	variable tmpl	:std_logic_vector(15 downto 0);
	variable tmph	:std_logic_vector(7 downto 0);
	variable tmpa	:std_logic_vector(15 downto 0);
	begin
		if(mcode<x"0900")then
			tmpl:=x"00" &  mcode(7 downto 0)-x"20";
			tmpl:=tmpl-((mcode(14 downto 8)-1)& "00000");
			tmpa(6 downto 0):=tmpl(6 downto 0);
			tmph:=('0' & (mcode(14 downto 8)-1))+tmpl(14 downto 7);
			tmpa(15 downto 7):='0' & tmph;
			addr<=x"00c0"+tmpa;
		elsif(mcode<x"0c00")then
			addr<=x"03a0" + (mcode-x"0c00");
		else
			tmpl:=x"00" & mcode(7 downto 0)-x"20";
			tmpl:=tmpl-((mcode(14 downto 8)-x"c") & "00000");
			tmpa(6 downto 0):=tmpl(6 downto 0);
			tmph:=('0' & (mcode(14 downto 8)-x"c"))+tmpl(14 downto 7);
			tmpa(15 downto 7):='0' & tmph;
			addr<=x"04e0"+tmpa;
		end if;
	end process;
		
	mon<=addr;
	
	romaddr<=
		('0' & x"0800") + ("00000" & kcode(7 downto 0) & cline)		when iskanji='0' else
		addr(11 downto 0)  & l_rn & cline;
	romsel<="00" when iskanji='0' else addr(13 downto 12);
	
end rtl;