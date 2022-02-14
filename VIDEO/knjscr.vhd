library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.VIDEO_TIMING_pkg.all;

entity KNJSCR is
generic(
	BLINKINT :integer	:=40
);
port(
	TRAMADR	:out std_logic_vector(12 downto 0);
	TRAMDAT	:in std_logic_vector(15 downto 0);
	TRAMATR	:in std_logic_vector(7 downto 0);
	
	FROMSEL	:out std_logic_vector(1 downto 0);
	FROMADR:out std_logic_vector(16 downto 0);
	FROMDAT:in std_logic_vector(7 downto 0)	:=x"00";
	
	BITOUT	:out std_logic;
	COLOR	:out std_logic_vector(2 downto 0);
	
	CURADDR	:in std_logic_vector(12 downto 0);
	CURE	:in std_logic;
	CURUPPER:in integer range 0 to 19;
	CURLOWER:in integer range 0 to 19;
	CBLINK	:in std_logic;
	BLINKRATE:in std_logic_vector(4 downto 0);
	
	BASEADDR:in std_logic_vector(12 downto 0);
	HMODE	:in std_logic;
	VLINES	:in std_logic_vector(4 downto 0);
	PITCH	:in std_logic_vector(7 downto 0);
	
	UCOUNT	:in integer range 0 to DOTPU-1;
	HUCOUNT	:in integer range 0 to (HWIDTH/DOTPU)-1;
	VCOUNT	:in integer range 0 to VWIDTH-1;
	HCOMP	:in std_logic;
	VCOMP	:in std_logic;

	clk		:in std_logic;
	rstn	:in std_logic
);
end KNJSCR;

architecture MAIN of KNJSCR is
signal	CURDOT	:std_logic_vector(7 downto 0);
signal	NXTDOT	:std_logic_vector(7 downto 0);
signal	NXTCLR :std_logic_vector(2 downto 0);
signal	CHAR	:std_logic_vector(7 downto 0);
signal	TRAMADRb	:std_logic_vector(12 downto 0);
signal	DHCOMP	:std_logic;
signal	DVCOMP	:std_logic;
signal	C_LOW	:integer range 0 to 31;
signal	C_LIN	:integer range 0 to 31;
signal	C_COL	:integer range 0 to 127;
signal	CURV	:std_logic;
signal	CURF	:std_logic;
signal	CICOUNT	:integer range 0 to 31;
signal	BLKF	:std_logic;
signal	BICOUNT	:integer range 0 to BLINKINT-1;
signal	CHRLINES	:integer range 1 to 32;
signal	VLINESC	:std_logic_vector(4 downto 0);
signal	HMODEC	:std_logic;
signal	FONTBYTE:std_logic_vector(7 downto 0);
signal	FROMh_ln:std_logic;
signal	CBLINKINT	:integer range 0 to 31;
signal	C0ADDR	:std_logic_vector(12 downto 0);
signal	wPITCH	:std_logic_vector(12 downto 0);
signal	TRAMADRx	:std_logic_vector(12 downto 0);
signal	iskanji	:std_logic;

component knjaddrcnv
port(
	kcode	:in std_logic_vector(15 downto 0);
	cline	:in std_logic_vector(3 downto 0);
	
	romsel	:out std_logic_vector(1 downto 0);
	romaddr	:out std_logic_vector(16 downto 0)
);
end component;

component delayer
generic(
	counts	:integer	:=5
);
port(
	a		:in std_logic;
	q		:out std_logic;
	
	clk		:in std_logic;
	rstn	:in std_logic
);
end component;

constant bit_ST	:integer	:=0;
constant bit_BL	:integer	:=1;
constant bit_RV	:integer	:=2;
constant bit_UL	:integer	:=3;
constant bit_VL	:integer	:=4;
constant bit_CLR0:integer	:=5;
constant bit_CLR1:integer	:=6;
constant bit_CLR2:integer	:=7;

signal	tramdatm	:std_logic_vector(15 downto 0);
signal	tramdatl	:std_logic_vector(15 downto 0);

begin

	Hdelay	:delayer generic map(1) port map(HCOMP,DHCOMP,clk,rstn);
	Vdelay	:delayer generic map(2) port map(VCOMP,DVCOMP,clk,rstn);
	wPITCH(7 downto 0)<=PITCH;
	wPITCH(12 downto 8)<=(others=>'0');
	
	iskanji<=	'0' when TRAMDAT(15 downto 8)=x"00" else
				'1' when TRAMDAT(7 downto 0)=x"01" else
				'1' when TRAMDAT(7 downto 0)=x"02" else
				'1' when TRAMDAT(7 downto 0)=x"03" else
				'1' when TRAMDAT(7 downto 0)=x"04" else
				'1' when TRAMDAT(7 downto 0)=x"05" else
				'1' when TRAMDAT(7 downto 0)=x"06" else
				'1' when TRAMDAT(7 downto 0)=x"07" else
				'1' when TRAMDAT(7 downto 0)=x"0d" else
				'1' when TRAMDAT(7 downto 4)=x"1" else
				'1' when TRAMDAT(7 downto 4)=x"2" else
				'1' when TRAMDAT(7 downto 4)=x"3" else
				'1' when TRAMDAT(7 downto 4)=x"4" else
				'1' when TRAMDAT(7 downto 0)=x"50" else
				'1' when TRAMDAT(7 downto 0)=x"51" else
				'1' when TRAMDAT(7 downto 0)=x"52" else
				'1' when TRAMDAT(7 downto 0)=x"53" else
				'1' when TRAMDAT(7 downto 0)=x"54" else
				'1' when TRAMDAT(7 downto 0)=x"55" else
				'0';
	
	process(clk,rstn)begin
		if(rstn='0')then
			tramdatl<=(others=>'0');
			TRAMADRx<=(others=>'1');
		elsif(clk' event and clk='1')then
			if(HCOMP='1')then
					TRAMADRx<=(others=>'1');
					tramdatl<=(others=>'0');
			elsif(TRAMADRb/=TRAMADRx)then
				if(iskanji='1' and TRAMDAT(15)='0')then
					tramdatl<=TRAMDAT;
					tramdatl(15)<='1';
					TRAMADRx<=TRAMADRb+1;
				else
					TRAMADRx<=(others=>'1');
					tramdatl<=(others=>'0');
				end if;
			end if;
		end if;
	end process;
	
	tramdatm<=tramdatl when TRAMADRb=TRAMADRx else TRAMDAT;
	
	acnv	:knjaddrcnv port map(
		kcode	=>tramdatm,
		cline	=>conv_std_logic_vector(C_LIN,4),
		
		romsel	=>FROMSEL,
		romaddr	=>FROMADR
	);
	
	
	FONTBYTE<=	FROMDAT;

	C_LIN<=0 when VCOUNT<VIV else (VCOUNT-VIV)mod CHRLINES;
	C_COL<=0 when HUCOUNT<HIV else HUCOUNT-HIV;

	CBLINKINT<=conv_integer(BLINKRATE);
	
	process(clk,rstn)begin
		if(rstn='0')then
			CURF<='1';
			CICOUNT<=1;
		elsif(clk' event and clk='1')then
			if(VCOMP='1')then
				if(CICOUNT=0)then
					CURF<=not CURF;
					CICOUNT<=CBLINKINT-1;
				else
					CICOUNT<=CICOUNT-1;
				end if;
			end if;
		end if;
	end process;

	process(clk,rstn)begin
		if(rstn='0')then
			BLKF<='0';
			BICOUNT<=BLINKINT-1;
		elsif(clk' event and clk='1')then
			if(VCOMP='1')then
				if(BICOUNT=0)then
					BLKF<=not BLKF;
					BICOUNT<=BLINKINT-1;
				else
					BICOUNT<=BICOUNT-1;
				end if;
			end if;
		end if;
	end process;

	CURV<=CURE when CBLINK='0' else (CURE and CURF);

	process(clk,rstn)begin
		if(rstn='0')then
			HMODEC<='0';
			VLINESC<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(VCOMP='1')then
				HMODEC<=HMODE;
				VLINESC<=VLINES;
			end if;
		end if;
	end process;

	CHRLINES<=1+conv_integer(VLINESC);

	process (clk,rstn)
	variable BNXTDOT	:std_logic_vector(7 downto 0);
	begin
		if(rstn='0')then
			NXTDOT<=(others=>'0');
			NXTCLR<=(others=>'0');
			TRAMADRb<=(others=>'0');
			C_LOW<=0;
			C0ADDR<=(others=>'0');
		elsif(clk' event and clk='1')then

-- Data	section
			if(DHCOMP='1')then
				if(VCOUNT>VIV)then
					if(C_LIN/=0)then
						TRAMADRb<=C0ADDR;
					else
						C_LOW<=C_LOW+1;
						TRAMADRb<=C0ADDR+wPITCH;
						C0ADDR<=C0ADDR+wPITCH;
					end if;
				end if;
			end if;
			if(DVCOMP='1')then
				TRAMADRb<=BASEADDR;
				C0ADDR<=BASEADDR;
				C_LOW<=0;
			end if;
			
			if(UCOUNT=6)then
				if(VCOUNT>=VIV and HUCOUNT>=HIV)then
					if((TRAMATR(bit_BL)='1' and BLKF='1') or TRAMATR(bit_ST)='0')then
						BNXTDOT:=(others=>'0');
					else
						if(C_LIN<16)then
							BNXTDOT:=FONTBYTE;
						else
							BNXTDOT:=(others=>'0');
						end if;
					end if;
					if(C_LIN=15 and TRAMATR(bit_UL)='1')then
						BNXTDOT:=(others=>'1');
					end if;
					if(TRAMATR(bit_VL)='1')then
						BNXTDOT:=BNXTDOT;
						BNXTDOT(3):='1';
					end if;
					if(TRAMATR(bit_RV)='1')then
						BNXTDOT:=not BNXTDOT;
					end if;
					if(CURV='1' and TRAMADRb=CURADDR and (C_LIN>CURUPPER and C_LIN<CURLOWER))then
						NXTDOT<=not BNXTDOT;
					else
						NXTDOT<=BNXTDOT;
					end if;
					NXTCLR<=TRAMATR(bit_CLR2 downto bit_CLR0);
					TRAMADRb<=TRAMADRb+1;
				else
					NXTDOT<=(others=>'0');
					NXTCLR<=(others=>'0');
				end if;
			end if;
		end if;
	end process;

	TRAMADR<=TRAMADRb;

-- Display driver section
	process(clk,rstn)begin
		if(rstn='0')then
			BITOUT<='0';
			COLOR<=(others=>'0');
			CURDOT<=(others=>'0');
		elsif(clk' event and clk='1')then
			if(HMODEC='1')then
				if(UCOUNT=0)then
					BITOUT<=NXTDOT(7);
					CURDOT<=NXTDOT;
					COLOR<=NXTCLR;
				else
					BITOUT<=CURDOT(6);
					CURDOT<=CURDOT(6 downto 0) & '0';
				end if;
			else
				if(UCOUNT=0 and (HUCOUNT mod 2)=1)then
					BITOUT<=NXTDOT(7);
					CURDOT<=NXTDOT;
					COLOR<=NXTCLR;
				elsif((UCOUNT mod 2)=0)then
					BITOUT<=CURDOT(6);
					CURDOT<=CURDOT(6 downto 0) & '0';
				end if;
			end if;
		end if;
	end process;


end MAIN;
					
