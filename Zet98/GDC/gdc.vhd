LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GDC is
port(
	CS		:in std_logic;
	ADDR	:in std_logic;
	RD		:in std_logic;
	WR		:in std_logic;
	DIN		:in std_logic_vector(7 downto 0);
	DOUT	:out std_logic_vector(7 downto 0);
	DOE		:out std_logic;
	
	LPEND	:in std_logic;
	VRTC	:in std_logic;
	HRTC	:in std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end GDC;

architecture rtl of GDC is

component gdcfifo
	PORT
	(
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
	);
END component;

signal	RFIFOADDR	:std_logic_vector(3 downto 0);
signal	WNFIFOADDR	:std_logic_vector(3 downto 0);
signal	WFIFOADDR	:std_logic_vector(3 downto 0);
signal	STATUS		:std_logic_vector(7 downto 0);
signal	RDATA		:std_logic_vector(7 downto 0);
signal	sDMAEXEC	:std_logic;
signal	sDRAWING	:std_logic;
signal	sFIFOE		:std_logic;
signal	sFIFOF		:std_logic;
signal	sDREADY		:std_logic;

signal	mWR,lWR			:std_logic;
signal	FIFOWDAT,FIFORDAT	:std_logic_vector(8 downto 0);
signal	FIFOWR		:std_logic;
signal	FIFORD		:std_logic;
begin

	STATUS<=LPEND & HRTC & VRTC & sDMAEXEC & sDRAWING & sFIFOE & sFIFOF & sDREADY;
	sDMAEXEC<='0';
	sDRAWING<='0';
	sFIFOE<=	'1' when RFIFOADDR=WFIFOADDR else '0';
	sFIFOF<=	'1' when (WFIFOADDR+"0001")=RFIFOADDR else '0';
	sDREADY<='1';
	RDATA<=(others=>'0');

	mWR<='1' when WR='1' and CS='1' else '0';
	
	process(clk,rstn)begin
		if(rstn='0')then
			lWR<='0';
			WFIFOADDR<=(others=>'1');
			WNFIFOADDR<=(others=>'0');
			FIFOWR<='0';
			FIFOWDAT<=(others=>'0');
		elsif(clk' event and clk='1')then
			FIFOWR<='0';
			if(mWR='1' and (WFIFOADDR+x"1"/=RFIFOADDR))then
				WFIFOADDR<=WNFIFOADDR;
				FIFOWR<='1';
				FIFOWDAT<=ADDR & DIN;
			elsif(lWR='1' and mWR='0' and (WFIFOADDR+"0001")/=RFIFOADDR)then
				WNFIFOADDR<=WNFIFOADDR+1;
			end if;
			lWR<=mWR;
		end if;
	end process;
	
	
	
	DOUT<=	STATUS when ADDR='0' else
			RDATA;
	
	DOE<=	'1' when CS='1' and RD='1' else
			'0';
		
	process(clk,rstn)begin
		if(rstn='0')then
			RFIFOADDR<=(others=>'1');
		elsif(clk' event and clk='1')then
			if(FIFORD='1')then
				RFIFOADDR<=RFIFOADDR+"0001";
			end if;
		end if;
	end process;
	
	FIFO	:gdcfifo port map(clk,FIFOWDAT,RFIFOADDR,WFIFOADDR,FIFOWR,FIFORDAT);
	
	--dummy GDC processor
	process(clk,rstn)
	variable step	:integer range 0 to 5;
	begin
		if(rstn='0')then
			step:=0;
			FIFORD<='0';
		elsif(clk' event and clk='1')then
			if(step=5)then
				step:=0;
				FIFORD<=not sFIFOE;
			else
				step:=step+1;
				FIFORD<='0';
			end if;
		end if;
	end process;
--	FIFORD<=sFIFOE;
--	process(clk,rstn)begin
--		if(rstn='0')then
--			FIFORD<='0';
--		elsif(clk' event and clk='1')then
--			FIFORD<='0';
--			if(sFIFOE='0')then
--				FIFORD<='1';
--			end if;
--		end if;
--	end process;
	
end rtl;
