LIBRARY	IEEE;
	USE	IEEE.STD_LOGIC_1164.ALL;
	USE	IEEE.STD_LOGIC_UNSIGNED.ALL;

package MEM_ADDR_pkg is
	-- phisical address(unit:word)
	-- ROM area
	constant	RAM_BIOS	:std_logic_vector(27 downto 0)		:=x"0000000";
	constant	RAM_ITF	:std_logic_vector(27 downto 0)		:=x"000c000";
	constant	RAM_SOUND:std_logic_vector(27 downto 0)		:=x"0010000";
	constant	RAM_SASI	:std_logic_vector(27 downto 0)		:=x"0012000";
	constant RAM_FONT	:std_logic_vector(27 downto 0)		:=x"0020000";
	
	-- RAM area
	constant	RAM_MAIN	:std_logic_vector(27 downto 0)		:=x"0100000";
	constant	RAM_VRAMF	:std_logic_vector(27 downto 0)	:=x"0040000";
	constant	RAM_VRAMB	:std_logic_vector(27 downto 0)	:=x"0050000";
	constant	RAM_EMS		:std_logic_vector(27 downto 0)	:=x"0180000";
	constant RAM_FDEMU0	:std_logic_vector(27 downto 0)	:=x"0800000";
	constant RAM_FDEMU1	:std_logic_vector(27 downto 0)	:=x"0c00000";
	
	-- CPU address mapping(unit:segment)
	constant	ADDR_BIOS	:std_logic_vector(15 downto 0)	:=x"e800";
	constant	WIDTH_BIOS	:std_logic_vector(15 downto 0)	:=x"1800";
	constant	ADDR_ITF	:std_logic_vector(15 downto 0)		:=x"f800";
	constant	WIDTH_ITF	:std_logic_vector(15 downto 0)	:=x"0800";
	constant	ADDR_SOUND	:std_logic_vector(15 downto 0)	:=x"cc00";
	constant	WIDTH_SOUND	:std_logic_vector(15 downto 0)	:=x"0400";
	constant	ADDR_SASI	:std_logic_vector(15 downto 0)	:=x"d000";
	constant	WIDTH_SASI	:std_logic_vector(15 downto 0)	:=x"0200";
	constant	ADDR_VRAM0	:std_logic_vector(15 downto 0)	:=x"a800";
	constant	WIDTH_VRAM0	:std_logic_vector(15 downto 0)	:=x"0800";
	constant	ADDR_VRAM1	:std_logic_vector(15 downto 0)	:=x"b000";
	constant	WIDTH_VRAM1	:std_logic_vector(15 downto 0)	:=x"0800";
	constant	ADDR_VRAM2	:std_logic_vector(15 downto 0)	:=x"b800";
	constant	WIDTH_VRAM2	:std_logic_vector(15 downto 0)	:=x"0800";
	constant	ADDR_VRAM3	:std_logic_vector(15 downto 0)	:=x"e000";
	constant	WIDTH_VRAM3	:std_logic_vector(15 downto 0)	:=x"0800";
	constant	ADDR_TRAM	:std_logic_vector(15 downto 0)	:=x"a000";
	constant	WIDTH_TRAM	:std_logic_vector(15 downto 0)	:=x"0200";
	constant	ADDR_ARAM	:std_logic_vector(15 downto 0)	:=x"a200";
	constant	WIDTH_ARAM	:std_logic_vector(15 downto 0)	:=x"0200";
	constant	ADDR_NVRAM	:std_logic_vector(15 downto 0)	:=x"a3fe";
	constant	WIDTH_NVRAM	:std_logic_vector(15 downto 0)	:=x"0002";
	constant	ADDR_RWIN8	:std_logic_vector(15 downto 0)	:=x"8000";
	constant	WIDTH_RWIN8	:std_logic_vector(15 downto 0)	:=x"2000";
	constant	ADDR_RWINA	:std_logic_vector(15 downto 0)	:=x"a000";
	constant	WIDTH_RWINA	:std_logic_vector(15 downto 0)	:=x"2000";
	constant	ADDR_EMS0	:std_logic_vector(15 downto 0)	:=x"c000";
	constant	WIDTH_EMS0	:std_logic_vector(15 downto 0)	:=x"0400";
	constant	ADDR_EMS1	:std_logic_vector(15 downto 0)	:=x"c400";
	constant	WIDTH_EMS1	:std_logic_vector(15 downto 0)	:=x"0400";
	constant	ADDR_EMS2	:std_logic_vector(15 downto 0)	:=x"c800";
	constant	WIDTH_EMS2	:std_logic_vector(15 downto 0)	:=x"0400";
	constant	ADDR_EMS3	:std_logic_vector(15 downto 0)	:=x"cc00";
	constant	WIDTH_EMS3	:std_logic_vector(15 downto 0)	:=x"0400";
	constant	ADDR_NECEMS0	:std_logic_vector(15 downto 0)	:=x"b000";
	constant	WIDTH_NECEMS0	:std_logic_vector(15 downto 0)	:=x"0400";
	constant	ADDR_NECEMS1	:std_logic_vector(15 downto 0)	:=x"b400";
	constant	WIDTH_NECEMS1	:std_logic_vector(15 downto 0)	:=x"0400";
	constant	ADDR_NECEMS2	:std_logic_vector(15 downto 0)	:=x"b800";
	constant	WIDTH_NECEMS2	:std_logic_vector(15 downto 0)	:=x"0400";
	constant	ADDR_NECEMS3	:std_logic_vector(15 downto 0)	:=x"bc00";
	constant	WIDTH_NECEMS3	:std_logic_vector(15 downto 0)	:=x"0400";

end package;
