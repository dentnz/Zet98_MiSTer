`define MICRO_DATA_WIDTH 50
`define MICRO_ADDR_WIDTH 10

`define MOVRRB	10'b0000000000
`define MOVRRW	10'b0000000001
`define MOVRMB	10'b0000000010
`define MOVRMW	10'b0000000011
`define MOVAMB	10'b0000000100
`define MOVAMW	10'b0000000101
`define MOVMRB	10'b0000000110
`define MOVMRW	10'b0000000111
`define MOVMAB	10'b0000001000
`define MOVMAW	10'b0000001001
`define MOVIRB	10'b0000001010
`define MOVIRW	10'b0000001011
`define MOVIMB	10'b0000001100
`define MOVIMW	10'b0000001110
`define PUSHR	10'b0000010000
`define PUSHM	10'b0000010011
`define PUSHI	10'b0000010110
`define LEAVE	10'b0000011001
`define ENTER	10'b0000011100
//`define ENTER	10'b1000001111
`define POPR	10'b0000100000
`define POPM	10'b0000100011
`define INIB	10'b0000100110
`define INIW	10'b0000100111
`define INRB	10'b0000101000
`define INRW	10'b0000101001
`define OUTIB	10'b0000101010
`define OUTIW	10'b0000101011
`define OUTRB	10'b0000101100
`define OUTRW	10'b0000101101
`define LAHF	10'b0000101110
`define SAHF	10'b0000101111
`define LDS	10'b0000110000
`define LEA	10'b0000110011
`define LES	10'b0000110100
`define PUSHF	10'b0000110111
`define POPF	10'b0000111010
`define XCHRRB	10'b0000111101
`define XCHRRW	10'b0001000000
`define XCHRMB	10'b0001000011
`define XCHRMW	10'b0001000110
`define XLAT	10'b0001001001
`define AAA	10'b0001001011
`define AAS	10'b0001001100
`define AAM	10'b0001001101
`define AAD	10'b0001010000
`define DAA	10'b0001010101
`define DAS	10'b0001010110
`define CBW	10'b0001010111
`define CWD	10'b0001011000
`define INCRB	10'b0001011001
`define INCRW	10'b0001011010
`define INCMB	10'b0001011011
`define INCMW	10'b0001011110
`define DECRB	10'b0001100001
`define DECRW	10'b0001100010
`define DECMB	10'b0001100011
`define DECMW	10'b0001100110
`define MULRB	10'b0001101001
`define MULRW	10'b0001101100
`define MULMB	10'b0001101111
`define MULMW	10'b0001110011
`define IMULRB	10'b0001110111
`define IMULRW	10'b0001111010
`define IMULMB	10'b0001111101
`define IMULMW	10'b0010000001
`define IMULIR	10'b0010000101
`define IMULIM	10'b0010001000
`define DIVRB	10'b0010001100
`define DIVRW	10'b0010001111
`define DIVMB	10'b0010010010
`define DIVMW	10'b0010010110
`define IDIVRB	10'b0010011010
`define IDIVRW	10'b0010011101
`define IDIVMB	10'b0010100000
`define IDIVMW	10'b0010100100
`define NEGRB	10'b0010101000
`define NEGRW	10'b0010101001
`define NEGMB	10'b0010101010
`define NEGMW	10'b0010101101
`define LOGRRB	10'b0010110000
`define LOGRRW	10'b0010110001
`define LOGRMB	10'b0010110010
`define LOGRMW	10'b0010110101
`define LOGMRB	10'b0010111000
`define LOGMRW	10'b0010111010
`define LOGIRB	10'b0010111100
`define LOGIRW	10'b0010111101
`define LOGIMB	10'b0010111110
`define LOGIMW	10'b0011000001
`define NOTRB	10'b0011000100
`define NOTRW	10'b0011000101
`define NOTMB	10'b0011000110
`define NOTMW	10'b0011001001
`define RSH1RB	10'b0011001100
`define RSH1RW	10'b0011001101
`define RSHCRB	10'b0011001110
`define RSHCRW	10'b0011001111
`define RSH1MB	10'b0011010000
`define RSH1MW	10'b0011010011
`define RSHCMB	10'b0011010110
`define RSHCMW	10'b0011011001
`define RSHIRB	10'b0011011100
`define RSHIRW	10'b0011011101
`define RSHIMB	10'b0011011110
`define RSHIMW	10'b0011100001
`define TSTRRB	10'b0011100100
`define TSTRRW	10'b0011100101
`define TSTMRB	10'b0011100110
`define TSTMRW	10'b0011101000
`define TSTIRB	10'b0011101010
`define TSTIRW	10'b0011101011
`define TSTIMB	10'b0011101100
`define TSTIMW	10'b0011101110
`define CALLN	10'b0011110000
`define CALLNR	10'b0011110011
`define CALLNM	10'b0011110111
`define CALLF	10'b0011111011
`define CALLFM	10'b0100000000
`define JCC	10'b0100000110
`define JCXZ	10'b0100000111
`define JMPI	10'b0100001000
`define JMPR	10'b0100001001
`define JMPM	10'b0100001010
`define LJMPI	10'b0100001011
`define LJMPM	10'b0100001101
`define LOOP	10'b0100001111
`define LOOPE	10'b0100010001
`define LOOPNE	10'b0100010011
`define RETN0	10'b0100010101
`define RETNV	10'b0100010111
`define RETF0	10'b0100011010
`define RETFV	10'b0100011110
`define CMPSB	10'b0100100011
`define CMPSW	10'b0100101001
`define CMPSBR	10'b0100101111
`define CMPSWR	10'b0100110110
`define LODSB	10'b0100111101
`define LODSW	10'b0100111111
`define LODSBR	10'b0101000001
`define LODSWR	10'b0101000100
`define MOVSB	10'b0101000111
`define MOVSW	10'b0101001011
`define MOVSBR	10'b0101001111
`define MOVSWR	10'b0101010100
`define SCASB	10'b0101011001
`define SCASW	10'b0101011100
`define SCASBR	10'b0101011111
`define SCASWR	10'b0101100011
`define STOSB	10'b0101100111
`define STOSW	10'b0101101001
`define STOSBR	10'b0101101011
`define STOSWR	10'b0101101110
`define INT3	10'b0101110001
`define INT	10'b0101111100
`define INTD	10'b0110000111
`define INTT	10'b0110010000
`define EINT	10'b0110011010
`define EINTP	10'b0110100101
`define INTO	10'b0110110000
`define IRET	10'b0110111100
`define NOP	10'b0111000011
`define CLC	10'b0111000100
`define CLD	10'b0111000101
`define CLI	10'b0111000110
`define CMC	10'b0111000111
`define STC	10'b0111001000
`define STD	10'b0111001001
`define STI	10'b0111001010
`define ESCRW	10'b0111001011
`define ESCMW	10'b0111001100
`define PUSHA	10'b0111001110
`define POPA	10'b0111011011
`define INVOP	10'b0111100110
`define INSB	10'b0111110011
`define INSW	10'b0111110110
`define INSBR	10'b0111111001
`define INSWR	10'b0111111101
`define OUTSB	10'b1000000001
`define OUTSW	10'b1000000100
`define OUTSBR	10'b1000000111
`define OUTSWR	10'b1000001011
