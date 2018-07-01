
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _index=R4
	.DEF _index_msb=R5
	.DEF _c=R6
	.DEF _c_msb=R7
	.DEF _value=R9
	.DEF __lcd_x=R8
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x1,0x0

_0x3:
	.DB  0x37,0x38,0x39,0x23
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x3A,0x20
	.DB  0x0,0x31,0x0,0x32,0x0,0x33,0x0,0x34
	.DB  0x0,0x35,0x0,0x36,0x0,0x37,0x0,0x38
	.DB  0x0,0x39,0x0,0x2A,0x0,0x30,0x0,0x23
	.DB  0x0,0x64,0x6F,0x6F,0x72,0x20,0x69,0x73
	.DB  0x20,0x6F,0x70,0x65,0x6E,0x65,0x64,0x0
	.DB  0x77,0x72,0x6F,0x6E,0x67,0x20,0x70,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x21,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x61,0x6E
	.DB  0x6F,0x74,0x68,0x65,0x72,0x3A,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x50,0x61,0x73
	.DB  0x73,0x77,0x6F,0x72,0x64,0x3A,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _pass
	.DW  _0x3*2

	.DW  0x11
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x02
	.DW  _0xB
	.DW  _0x0*2+17

	.DW  0x02
	.DW  _0xB+2
	.DW  _0x0*2+19

	.DW  0x02
	.DW  _0xB+4
	.DW  _0x0*2+21

	.DW  0x02
	.DW  _0xF
	.DW  _0x0*2+23

	.DW  0x02
	.DW  _0xF+2
	.DW  _0x0*2+25

	.DW  0x02
	.DW  _0xF+4
	.DW  _0x0*2+27

	.DW  0x02
	.DW  _0x13
	.DW  _0x0*2+29

	.DW  0x02
	.DW  _0x13+2
	.DW  _0x0*2+31

	.DW  0x02
	.DW  _0x13+4
	.DW  _0x0*2+33

	.DW  0x02
	.DW  _0x17
	.DW  _0x0*2+35

	.DW  0x02
	.DW  _0x17+2
	.DW  _0x0*2+37

	.DW  0x02
	.DW  _0x17+4
	.DW  _0x0*2+39

	.DW  0x0F
	.DW  _0x21
	.DW  _0x0*2+41

	.DW  0x10
	.DW  _0x21+15
	.DW  _0x0*2+56

	.DW  0x0F
	.DW  _0x21+31
	.DW  _0x0*2+72

	.DW  0x10
	.DW  _0x21+46
	.DW  _0x0*2+87

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <io.h>
;#include <delay.h>
;#include <alcd.h>
;
;#define pad PORTD
;#define r1 PORTD.0
;#define r2 PORTD.1
;#define r3 PORTD.2
;#define r4 PORTD.3
;
;#define c1 PORTD.4
;#define c2 PORTD.5
;#define c3 PORTD.7
;
;
;void check1(void);
;void check2(void);
;void check3(void);
;void check4(void);
;void chpass();
;void beepbeep();
;void notbeep();
;
;   int index=0;
;      unsigned short c=1;
;      unsigned char value;
;      unsigned char input[4];
;      unsigned char pass[4]={'7','8','9','#'};

	.DSEG
;
;void main(void)
; 0000 0021 {

	.CSEG
_main:
; .FSTART _main
; 0000 0022 
; 0000 0023 
; 0000 0024 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0025 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0026 // Port B initialization
; 0000 0027 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0028 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0029 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 002A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 002B // Port C initialization
; 0000 002C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 002D DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 002E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 002F PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0030 
; 0000 0031 // Port D initialization
; 0000 0032 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0033 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0034 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0035 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0036 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0037 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0038 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0039 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 003A TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 003B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 003C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 003D ICR1H=0x00;
	OUT  0x27,R30
; 0000 003E ICR1L=0x00;
	OUT  0x26,R30
; 0000 003F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0040 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0041 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0042 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0043 
; 0000 0044 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0045 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0046 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0047 OCR2=0x00;
	OUT  0x23,R30
; 0000 0048 
; 0000 0049 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 004A TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 004B 
; 0000 004C MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 004D MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 004E 
; 0000 004F // USART initialization
; 0000 0050 // USART disabled
; 0000 0051 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0052 
; 0000 0053 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0054 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0055 
; 0000 0056 // ADC initialization
; 0000 0057 // ADC disabled
; 0000 0058 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0059 
; 0000 005A // SPI initialization
; 0000 005B // SPI disabled
; 0000 005C SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 005D 
; 0000 005E // TWI initialization
; 0000 005F // TWI disabled
; 0000 0060 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0061 /****************************************************************
; 0000 0062 *****************************************************************
; 0000 0063 *****************************************************************
; 0000 0064 ****************************************************************/
; 0000 0065 
; 0000 0066 
; 0000 0067 	DDRA=0xff; //LCD_DATA port as output port
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0068 	DDRB=0xff; //signal as out put
	OUT  0x17,R30
; 0000 0069     DDRC=0xff;
	OUT  0x14,R30
; 0000 006A 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 006B 	DDRD=0x0f;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 006C 	pad=0xf0;
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 006D 	lcd_init(16); //initialization of LCD
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 006E 	lcd_puts("Enter Password: ");
	__POINTW2MN _0x4,0
	RCALL _lcd_puts
; 0000 006F 	while(1)
_0x5:
; 0000 0070 	{
; 0000 0071 		PORTD=0xF0; //set all the input to one
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 0072 		value=PIND; //get the PORTD value in variable “value”
	IN   R9,16
; 0000 0073 		if(value!=0xf0) //if any key is pressed value changed
	CP   R30,R9
	BREQ _0x8
; 0000 0074 		{
; 0000 0075 
; 0000 0076 			check1();
	RCALL _check1
; 0000 0077 			check2();
	RCALL _check2
; 0000 0078 			check3();
	RCALL _check3
; 0000 0079 			check4();
	RCALL _check4
; 0000 007A 
; 0000 007B            chpass();
	RCALL _chpass
; 0000 007C 	    }
; 0000 007D     }
_0x8:
	RJMP _0x5
; 0000 007E 
; 0000 007F 
; 0000 0080 }
_0x9:
	RJMP _0x9
; .FEND

	.DSEG
_0x4:
	.BYTE 0x11
;
;
;
;void check1(void)
; 0000 0085 {

	.CSEG
_check1:
; .FSTART _check1
; 0000 0086     //DDRD = 0xf0;
; 0000 0087     pad =0b11111110;
	LDI  R30,LOW(254)
	RCALL SUBOPT_0x0
; 0000 0088     //pad &= (0<<r1);
; 0000 0089     delay_us(10);
; 0000 008A     if(PIND.4==0)
	SBIC 0x10,4
	RJMP _0xA
; 0000 008B     {
; 0000 008C         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 008D         lcd_puts("1");
	__POINTW2MN _0xB,0
	RCALL _lcd_puts
; 0000 008E         PORTB =0b00000001;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2
; 0000 008F         input[index]='1';
	LDI  R30,LOW(49)
	RCALL SUBOPT_0x3
; 0000 0090         index++;
; 0000 0091         delay_ms(70);
; 0000 0092 
; 0000 0093     }
; 0000 0094     if(PIND.5==0)
_0xA:
	SBIC 0x10,5
	RJMP _0xC
; 0000 0095         {
; 0000 0096 
; 0000 0097         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 0098                     lcd_puts("2");
	__POINTW2MN _0xB,2
	RCALL SUBOPT_0x4
; 0000 0099                     input[index]='2';
	LDI  R30,LOW(50)
	ST   X,R30
; 0000 009A             PORTB =0b00000010;
	LDI  R30,LOW(2)
	OUT  0x18,R30
; 0000 009B             index++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 009C         delay_ms(70);
	LDI  R26,LOW(70)
	LDI  R27,0
	CALL _delay_ms
; 0000 009D         }
; 0000 009E     if(PIND.6==0)
_0xC:
	SBIC 0x10,6
	RJMP _0xD
; 0000 009F         {
; 0000 00A0         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 00A1             lcd_puts("3");
	__POINTW2MN _0xB,4
	RCALL _lcd_puts
; 0000 00A2             PORTB =0b00000100;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2
; 0000 00A3              input[index]='3';
	LDI  R30,LOW(51)
	RCALL SUBOPT_0x3
; 0000 00A4             index++;
; 0000 00A5         delay_ms(70);
; 0000 00A6         }
; 0000 00A7         value=0xF0;
_0xD:
	RJMP _0x2020003
; 0000 00A8 }
; .FEND

	.DSEG
_0xB:
	.BYTE 0x6
;
;
;void check2(void)
; 0000 00AC {

	.CSEG
_check2:
; .FSTART _check2
; 0000 00AD     pad=0b11111101;
	LDI  R30,LOW(253)
	RCALL SUBOPT_0x0
; 0000 00AE     //pad &= (0<<r2);
; 0000 00AF     delay_us(10);
; 0000 00B0     if(PIND.4==0)
	SBIC 0x10,4
	RJMP _0xE
; 0000 00B1         {
; 0000 00B2         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 00B3             lcd_puts("4");
	__POINTW2MN _0xF,0
	RCALL _lcd_puts
; 0000 00B4             PORTB =0b00001000;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x2
; 0000 00B5             input[index]='4';
	LDI  R30,LOW(52)
	RCALL SUBOPT_0x3
; 0000 00B6             index++;
; 0000 00B7         delay_ms(70);
; 0000 00B8         }
; 0000 00B9      if(PIND.5==0)
_0xE:
	SBIC 0x10,5
	RJMP _0x10
; 0000 00BA         {
; 0000 00BB         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 00BC             lcd_puts("5");
	__POINTW2MN _0xF,2
	RCALL _lcd_puts
; 0000 00BD             PORTB =0b00010000;
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x2
; 0000 00BE             input[index]='5';
	LDI  R30,LOW(53)
	RCALL SUBOPT_0x3
; 0000 00BF             index++;
; 0000 00C0         delay_ms(70);
; 0000 00C1         }
; 0000 00C2      if(PIND.6==0)
_0x10:
	SBIC 0x10,6
	RJMP _0x11
; 0000 00C3         {
; 0000 00C4         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 00C5             lcd_puts("6");
	__POINTW2MN _0xF,4
	RCALL _lcd_puts
; 0000 00C6             PORTB =0b00100000;
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x2
; 0000 00C7             input[index]='6';
	LDI  R30,LOW(54)
	RCALL SUBOPT_0x3
; 0000 00C8             index++;
; 0000 00C9         delay_ms(70);
; 0000 00CA         }
; 0000 00CB                 value=0xF0;
_0x11:
	RJMP _0x2020003
; 0000 00CC 
; 0000 00CD }
; .FEND

	.DSEG
_0xF:
	.BYTE 0x6
;
;void check3(void)
; 0000 00D0 {

	.CSEG
_check3:
; .FSTART _check3
; 0000 00D1     pad=0b11111011;
	LDI  R30,LOW(251)
	RCALL SUBOPT_0x0
; 0000 00D2     //pad &= (0<<r3);
; 0000 00D3     delay_us(10);
; 0000 00D4     if(PIND.4==0)
	SBIC 0x10,4
	RJMP _0x12
; 0000 00D5         {
; 0000 00D6         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 00D7             lcd_puts("7");
	__POINTW2MN _0x13,0
	RCALL _lcd_puts
; 0000 00D8             PORTB =0b01000000;
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x2
; 0000 00D9             input[index]='7';
	LDI  R30,LOW(55)
	RCALL SUBOPT_0x3
; 0000 00DA             index++;
; 0000 00DB         delay_ms(70);
; 0000 00DC         }
; 0000 00DD      if(PIND.5==0)
_0x12:
	SBIC 0x10,5
	RJMP _0x14
; 0000 00DE         {
; 0000 00DF         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 00E0             lcd_puts("8");
	__POINTW2MN _0x13,2
	RCALL _lcd_puts
; 0000 00E1             PORTB =0b10000000;
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x2
; 0000 00E2             input[index]='8';
	LDI  R30,LOW(56)
	RCALL SUBOPT_0x3
; 0000 00E3             index++;
; 0000 00E4         delay_ms(70);
; 0000 00E5         }
; 0000 00E6      if(PIND.6==0)
_0x14:
	SBIC 0x10,6
	RJMP _0x15
; 0000 00E7         {
; 0000 00E8 
; 0000 00E9         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 00EA             lcd_puts("9");
	__POINTW2MN _0x13,4
	RCALL SUBOPT_0x4
; 0000 00EB             input[index]='9';
	LDI  R30,LOW(57)
	RCALL SUBOPT_0x3
; 0000 00EC             index++;
; 0000 00ED         delay_ms(70);
; 0000 00EE 
; 0000 00EF         }
; 0000 00F0                 value=0xF0;
_0x15:
	RJMP _0x2020003
; 0000 00F1 
; 0000 00F2 }
; .FEND

	.DSEG
_0x13:
	.BYTE 0x6
;
;void check4(void)
; 0000 00F5 {

	.CSEG
_check4:
; .FSTART _check4
; 0000 00F6     pad =0b11110111;
	LDI  R30,LOW(247)
	RCALL SUBOPT_0x0
; 0000 00F7     //pad &= (0<<r4);
; 0000 00F8     delay_us(10);
; 0000 00F9     if(PIND.4==0)
	SBIC 0x10,4
	RJMP _0x16
; 0000 00FA         {
; 0000 00FB         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 00FC             lcd_puts("*");
	__POINTW2MN _0x17,0
	RCALL SUBOPT_0x4
; 0000 00FD             input[index]='*';
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x3
; 0000 00FE             index++;
; 0000 00FF         delay_ms(70);
; 0000 0100         }
; 0000 0101    if(PIND.5==0)
_0x16:
	SBIC 0x10,5
	RJMP _0x18
; 0000 0102             {
; 0000 0103         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 0104                 lcd_puts("0");
	__POINTW2MN _0x17,2
	RCALL _lcd_puts
; 0000 0105                 PORTB =0b00000000;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x2
; 0000 0106                 input[index]='0';
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x3
; 0000 0107             index++;
; 0000 0108         delay_ms(70);
; 0000 0109             }
; 0000 010A    if(PIND.6==0)
_0x18:
	SBIC 0x10,6
	RJMP _0x19
; 0000 010B     {
; 0000 010C         lcd_gotoxy(index,2);
	RCALL SUBOPT_0x1
; 0000 010D         lcd_puts("#");
	__POINTW2MN _0x17,4
	RCALL SUBOPT_0x4
; 0000 010E         input[index]='#';
	LDI  R30,LOW(35)
	RCALL SUBOPT_0x3
; 0000 010F             index++;
; 0000 0110         delay_ms(70);
; 0000 0111 
; 0000 0112     }
; 0000 0113             value=0xF0;
_0x19:
_0x2020003:
	LDI  R30,LOW(240)
	MOV  R9,R30
; 0000 0114 
; 0000 0115 }
	RET
; .FEND

	.DSEG
_0x17:
	.BYTE 0x6
;
;void chpass()
; 0000 0118 {

	.CSEG
_chpass:
; .FSTART _chpass
; 0000 0119     if(index<4){
; 0000 011A 
; 0000 011B        // lcd_puts("fuuuk");
; 0000 011C 
; 0000 011D 	}
; 0000 011E 
; 0000 011F     if(index>3){
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	BRLT PC+2
	RJMP _0x1B
; 0000 0120 
; 0000 0121        int i;
; 0000 0122        for(i=0;i<4;i++){
	SBIW R28,2
;	i -> Y+0
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x1D:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRGE _0x1E
; 0000 0123              if(input[i]==pass[i]) {
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-_input)
	SBCI R31,HIGH(-_input)
	LD   R26,Z
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-_pass)
	SBCI R31,HIGH(-_pass)
	LD   R30,Z
	CP   R30,R26
	BRNE _0x1F
; 0000 0124                 c=c<<1;
	LSL  R6
	ROL  R7
; 0000 0125             }
; 0000 0126        }
_0x1F:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x1D
_0x1E:
; 0000 0127 
; 0000 0128        if(c==16)
	RCALL SUBOPT_0x5
	BRNE _0x20
; 0000 0129        {
; 0000 012A        lcd_clear();
	RCALL _lcd_clear
; 0000 012B        lcd_puts("door is opened");
	__POINTW2MN _0x21,0
	RCALL _lcd_puts
; 0000 012C         beepbeep();
	RCALL _beepbeep
; 0000 012D        }
; 0000 012E 
; 0000 012F       else if(c!=16 && index==4)
	RJMP _0x22
_0x20:
	RCALL SUBOPT_0x5
	BREQ _0x24
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x25
_0x24:
	RJMP _0x23
_0x25:
; 0000 0130        {
; 0000 0131         lcd_clear();
	RCALL _lcd_clear
; 0000 0132        lcd_puts("wrong password!");
	__POINTW2MN _0x21,15
	RCALL _lcd_puts
; 0000 0133        notbeep();
	RCALL _notbeep
; 0000 0134        //delay_ms(500);
; 0000 0135        lcd_clear();
	RCALL _lcd_clear
; 0000 0136        lcd_puts("Enter another:");
	__POINTW2MN _0x21,31
	RCALL _lcd_puts
; 0000 0137        index=0;
	CLR  R4
	CLR  R5
; 0000 0138        c=1;
	RJMP _0x32
; 0000 0139        }
; 0000 013A 
; 0000 013B        else if (c!=16)
_0x23:
	RCALL SUBOPT_0x5
	BREQ _0x27
; 0000 013C        {
; 0000 013D           lcd_clear();
	RCALL _lcd_clear
; 0000 013E                   index=0;
	CLR  R4
	CLR  R5
; 0000 013F          lcd_puts("Enter Password:");
	__POINTW2MN _0x21,46
	RCALL _lcd_puts
; 0000 0140          c=1;
_0x32:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 0141 
; 0000 0142        }
; 0000 0143 
; 0000 0144     }
_0x27:
_0x22:
	ADIW R28,2
; 0000 0145 
; 0000 0146 
; 0000 0147 
; 0000 0148 
; 0000 0149 
; 0000 014A 
; 0000 014B 
; 0000 014C }
_0x1B:
	RET
; .FEND

	.DSEG
_0x21:
	.BYTE 0x3E
;
;
;
;
;void beepbeep() {
; 0000 0151 void beepbeep() {

	.CSEG
_beepbeep:
; .FSTART _beepbeep
; 0000 0152 int i;
; 0000 0153          for(i=0;i<10;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x29:
	__CPWRN 16,17,10
	BRGE _0x2A
; 0000 0154              PORTB=0b10101010;
	LDI  R30,LOW(170)
	OUT  0x18,R30
; 0000 0155              delay_ms(20);
	RCALL SUBOPT_0x6
; 0000 0156              PORTB=0b01010101;
	LDI  R30,LOW(85)
	OUT  0x18,R30
; 0000 0157              delay_ms(20);
	RCALL SUBOPT_0x6
; 0000 0158 
; 0000 0159          }
	__ADDWRN 16,17,1
	RJMP _0x29
_0x2A:
; 0000 015A 
; 0000 015B }
	RJMP _0x2020002
; .FEND
;
;void notbeep(){
; 0000 015D void notbeep(){
_notbeep:
; .FSTART _notbeep
; 0000 015E          int i;
; 0000 015F        for(i=0;i<10;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x2C:
	__CPWRN 16,17,10
	BRGE _0x2D
; 0000 0160              PORTC.0=1;
	SBI  0x15,0
; 0000 0161              delay_ms(20);
	RCALL SUBOPT_0x6
; 0000 0162              PORTC.0=0;
	CBI  0x15,0
; 0000 0163              delay_ms(20);
	RCALL SUBOPT_0x6
; 0000 0164 
; 0000 0165          }
	__ADDWRN 16,17,1
	RJMP _0x2C
_0x2D:
; 0000 0166 
; 0000 0167 }
_0x2020002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,6
	__DELAY_USB 13
	CBI  0x1B,6
	__DELAY_USB 13
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R8,Y+1
	LDD  R11,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x7
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x7
	LDI  R30,LOW(0)
	MOV  R11,R30
	MOV  R8,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R8,R10
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R11
	MOV  R26,R11
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020001
_0x2000004:
	INC  R8
	SBI  0x1B,4
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,4
	RJMP _0x2020001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF)
	OUT  0x1A,R30
	SBI  0x1A,6
	SBI  0x1A,4
	SBI  0x1A,5
	CBI  0x1B,6
	CBI  0x1B,4
	CBI  0x1B,5
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x8
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_input:
	.BYTE 0x4
_pass:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	OUT  0x12,R30
	__DELAY_USB 27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1:
	ST   -Y,R4
	LDI  R26,LOW(2)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2:
	OUT  0x18,R30
	LDI  R26,LOW(_input)
	LDI  R27,HIGH(_input)
	ADD  R26,R4
	ADC  R27,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x3:
	ST   X,R30
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	LDI  R26,LOW(70)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	RCALL _lcd_puts
	LDI  R26,LOW(_input)
	LDI  R27,HIGH(_input)
	ADD  R26,R4
	ADC  R27,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R30,R6
	CPC  R31,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
