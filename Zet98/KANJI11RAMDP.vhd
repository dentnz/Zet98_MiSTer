LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KANJI11RAMDP is
PORT
(
	address_a		: IN STD_LOGIC_VECTOR (16 DOWNTO 0);
	address_b		: IN STD_LOGIC_VECTOR (16 DOWNTO 0);
	clock_a		: IN STD_LOGIC  := '1';
	clock_b		: IN STD_LOGIC ;
	data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
	wren_a		: IN STD_LOGIC  := '0';
	wren_b		: IN STD_LOGIC  := '0';
	q_a		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
	q_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end KANJI11RAMDP;

architecture rtl of KANJI11RAMDP is

subtype datbuf is std_logic_vector(7 downto 0); 
type datbuf_array is array (natural range <>) of datbuf; 
signal	qabuf	:datbuf_array(0 to 8);
signal	qbbuf	:datbuf_array(0 to 8);

signal	wea		:std_logic_vector(8 downto 0);
signal	web		:std_logic_vector(8 downto 0);
signal	cena	:std_logic_vector(8 downto 0);
signal	cenb	:std_logic_vector(8 downto 0);

component DPSRAM11x8
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		clock_a		: IN STD_LOGIC  := '1';
		clock_b		: IN STD_LOGIC ;
		data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END component;
begin

	cena<=	"000000001" when address_a<('0' & x"0800") else
			"000000010" when address_a<('0' & x"1000") else
			"000000100" when address_a<('0' & x"1800") else
			"000001000" when address_a<('0' & x"2000") else
			"000010000" when address_a<('0' & x"2800") else
			"000100000" when address_a<('0' & x"3000") else
			"001000000" when address_a<('0' & x"3800") else
			"010000000" when address_a<('0' & x"4000") else
			"100000000" when address_a<('0' & x"4800") else
			(others=>'0');
			
	cenb<=	"000000001" when address_b<('0' & x"0800") else
			"000000010" when address_b<('0' & x"1000") else
			"000000100" when address_b<('0' & x"1800") else
			"000001000" when address_b<('0' & x"2000") else
			"000010000" when address_b<('0' & x"2800") else
			"000100000" when address_b<('0' & x"3000") else
			"001000000" when address_b<('0' & x"3800") else
			"010000000" when address_b<('0' & x"4000") else
			"100000000" when address_b<('0' & x"4800") else
			(others=>'0');

	wea<=cena when wren_a='1' else (others=>'0');
	web<=cenb when wren_b='1' else (others=>'0');
	
	ramb	:for i in 0 to 8 generate
		ram0	:DPSRAM11x8 port map(
			address_a		=>address_a(10 downto 0),
			address_b		=>address_b(10 downto 0),
			clock_a			=>clock_a,
			clock_b			=>clock_b,
			data_a			=>data_a,
			data_b			=>data_b,
			wren_a			=>wea(i),
			wren_b			=>web(i),
			q_a				=>qabuf(i),
			q_b				=>qbbuf(i)
		);
	end generate;
	
	process(cena,qabuf)
	variable tmp	:std_logic_vector(7 downto 0);
	begin
		tmp:=(others=>'0');
		for i in 0 to 8 loop
			if(cena(i)='1')then
				tmp:=qabuf(i);
			end if;
		end loop;
		q_a<=tmp;
	end process;

	process(cenb,qbbuf)
	variable tmp	:std_logic_vector(7 downto 0);
	begin
		tmp:=(others=>'0');
		for i in 0 to 8 loop
			if(cenb(i)='1')then
				tmp:=qbbuf(i);
			end if;
		end loop;
		q_b<=tmp;
	end process;
	
	
end rtl;
