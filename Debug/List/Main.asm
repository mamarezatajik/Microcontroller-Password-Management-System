
;CodeVisionAVR C Compiler V3.14 Advanced
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
	.DEF _time=R4
	.DEF _time_msb=R5
	.DEF _delay=R6
	.DEF _delay_msb=R7
	.DEF _password_count=R8
	.DEF _password_count_msb=R9
	.DEF _save_count=R10
	.DEF _save_count_msb=R11
	.DEF _mode=R13

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
	JMP  _timer1_compa_isr
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
	.DB  0x0,0x0,0x0,0x0
	.DB  0x6,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x30,0x30,0x30,0x30,0x0,0x31,0x32,0x33
	.DB  0x34,0x0,0x34,0x33,0x32,0x31,0x0,0x31
	.DB  0x31,0x31,0x31,0x0,0x31,0x33,0x38,0x30
	.DB  0x0,0x31,0x33,0x38,0x32

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x1D
	.DW  _passwords
	.DW  _0x3*2

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
;#include <delay.h>
;#include <string.h>
;
;#define C1 PIND.2
;#define C2 PIND.1
;#define C3 PIND.0
;
;#define A PORTD.3
;#define B PORTD.4
;#define C PORTD.5
;#define D PORTD.6
;
;#define correct_pass PORTD.7
;#define MAX_PASSWORDS 20
;#define MAX_SAVE  50
;#define PASSWORD_LENGTH 5
;
;int time = 0, delay = 0, password_count = 6, save_count = 0;
;char passwords[MAX_PASSWORDS][PASSWORD_LENGTH] =
;    {"0000", "1234", "4321", "1111", "1380", "1382"};

	.DSEG
;char Seconds[MAX_SAVE], Minutes[MAX_SAVE], Hours[MAX_SAVE],
;    one[MAX_SAVE], two[MAX_SAVE], three[MAX_SAVE], four[MAX_SAVE],
;    mode = 0, entered_password[PASSWORD_LENGTH] = "";
;
;
;unsigned char ReadKeypad(void) {
; 0000 001B unsigned char ReadKeypad(void) {

	.CSEG
_ReadKeypad:
; .FSTART _ReadKeypad
; 0000 001C     unsigned char result = 10;
; 0000 001D     PORTD = 0x7F;
	ST   -Y,R17
;	result -> R17
	LDI  R17,10
	LDI  R30,LOW(127)
	OUT  0x12,R30
; 0000 001E 
; 0000 001F     A = 0;
	CBI  0x12,3
; 0000 0020     delay_ms(3);
	CALL SUBOPT_0x0
; 0000 0021     if (C1 == 0) {
	SBIC 0x10,2
	RJMP _0x6
; 0000 0022         result = '1';
	LDI  R17,LOW(49)
; 0000 0023         while (C1 == 0);
_0x7:
	SBIS 0x10,2
	RJMP _0x7
; 0000 0024     }
; 0000 0025     if (C2 == 0) {
_0x6:
	SBIC 0x10,1
	RJMP _0xA
; 0000 0026         result = '2';
	LDI  R17,LOW(50)
; 0000 0027         while (C2 == 0);
_0xB:
	SBIS 0x10,1
	RJMP _0xB
; 0000 0028     }
; 0000 0029     if (C3 == 0) {
_0xA:
	SBIC 0x10,0
	RJMP _0xE
; 0000 002A         result = '3';
	LDI  R17,LOW(51)
; 0000 002B         while (C3 == 0);
_0xF:
	SBIS 0x10,0
	RJMP _0xF
; 0000 002C     }
; 0000 002D     A = 1;
_0xE:
	SBI  0x12,3
; 0000 002E 
; 0000 002F     B = 0;
	CBI  0x12,4
; 0000 0030     delay_ms(3);
	CALL SUBOPT_0x0
; 0000 0031     if (C1 == 0){
	SBIC 0x10,2
	RJMP _0x16
; 0000 0032         result = '4';
	LDI  R17,LOW(52)
; 0000 0033         while (C1 == 0);
_0x17:
	SBIS 0x10,2
	RJMP _0x17
; 0000 0034     }
; 0000 0035     if (C2 == 0) {
_0x16:
	SBIC 0x10,1
	RJMP _0x1A
; 0000 0036         result = '5';
	LDI  R17,LOW(53)
; 0000 0037         while (C2 == 0);
_0x1B:
	SBIS 0x10,1
	RJMP _0x1B
; 0000 0038     }
; 0000 0039     if (C3 == 0) {
_0x1A:
	SBIC 0x10,0
	RJMP _0x1E
; 0000 003A         result = '6';
	LDI  R17,LOW(54)
; 0000 003B         while (C3 == 0) ;
_0x1F:
	SBIS 0x10,0
	RJMP _0x1F
; 0000 003C     }
; 0000 003D     B = 1;
_0x1E:
	SBI  0x12,4
; 0000 003E 
; 0000 003F     C = 0;
	CBI  0x12,5
; 0000 0040     delay_ms(3);
	CALL SUBOPT_0x0
; 0000 0041     if (C1 == 0) {
	SBIC 0x10,2
	RJMP _0x26
; 0000 0042         result = '7';
	LDI  R17,LOW(55)
; 0000 0043         while (C1 == 0);
_0x27:
	SBIS 0x10,2
	RJMP _0x27
; 0000 0044     }
; 0000 0045     if (C2 == 0) {
_0x26:
	SBIC 0x10,1
	RJMP _0x2A
; 0000 0046         result = '8';
	LDI  R17,LOW(56)
; 0000 0047         while (C2 == 0);
_0x2B:
	SBIS 0x10,1
	RJMP _0x2B
; 0000 0048     }
; 0000 0049     if (C3 == 0) {
_0x2A:
	SBIC 0x10,0
	RJMP _0x2E
; 0000 004A         result = '9';
	LDI  R17,LOW(57)
; 0000 004B         while (C3 == 0);
_0x2F:
	SBIS 0x10,0
	RJMP _0x2F
; 0000 004C     }
; 0000 004D     C = 1;
_0x2E:
	SBI  0x12,5
; 0000 004E 
; 0000 004F     D = 0;
	CBI  0x12,6
; 0000 0050     delay_ms(3);
	CALL SUBOPT_0x0
; 0000 0051     if (C1 == 0) {
	SBIC 0x10,2
	RJMP _0x36
; 0000 0052         result = '*';
	LDI  R17,LOW(42)
; 0000 0053         while (C1 == 0);
_0x37:
	SBIS 0x10,2
	RJMP _0x37
; 0000 0054     }
; 0000 0055     if (C2 == 0) {
_0x36:
	SBIC 0x10,1
	RJMP _0x3A
; 0000 0056         result = '0';
	LDI  R17,LOW(48)
; 0000 0057         while (C2 == 0);
_0x3B:
	SBIS 0x10,1
	RJMP _0x3B
; 0000 0058     }
; 0000 0059     if (C3 == 0) {
_0x3A:
	SBIC 0x10,0
	RJMP _0x3E
; 0000 005A         result = '#';
	LDI  R17,LOW(35)
; 0000 005B         while (C3 == 0);
_0x3F:
	SBIS 0x10,0
	RJMP _0x3F
; 0000 005C     }
; 0000 005D     D = 1;
_0x3E:
	SBI  0x12,6
; 0000 005E 
; 0000 005F     return result;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0060 }
; .FEND
;
;void display_time(char second, char minute, char hour, char ok) {
; 0000 0062 void display_time(char second, char minute, char hour, char ok) {
_display_time:
; .FSTART _display_time
; 0000 0063     unsigned char second_ones = second % 10;
; 0000 0064     unsigned char second_tens = second / 10;
; 0000 0065 
; 0000 0066     unsigned char minute_ones = minute % 10;
; 0000 0067     unsigned char minute_tens = minute / 10;
; 0000 0068 
; 0000 0069     unsigned char hour_ones = hour % 10;
; 0000 006A     unsigned char hour_tens = hour / 10;
; 0000 006B 
; 0000 006C     if (!delay || ok) {
	ST   -Y,R26
	CALL __SAVELOCR6
;	second -> Y+9
;	minute -> Y+8
;	hour -> Y+7
;	ok -> Y+6
;	second_ones -> R17
;	second_tens -> R16
;	minute_ones -> R19
;	minute_tens -> R18
;	hour_ones -> R21
;	hour_tens -> R20
	LDD  R26,Y+9
	CALL SUBOPT_0x1
	MOV  R17,R30
	LDD  R26,Y+9
	CALL SUBOPT_0x2
	MOV  R16,R30
	LDD  R26,Y+8
	CALL SUBOPT_0x1
	MOV  R19,R30
	LDD  R26,Y+8
	CALL SUBOPT_0x2
	MOV  R18,R30
	LDD  R26,Y+7
	CALL SUBOPT_0x1
	MOV  R21,R30
	LDD  R26,Y+7
	CALL SUBOPT_0x2
	MOV  R20,R30
	MOV  R0,R6
	OR   R0,R7
	BREQ _0x45
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x44
_0x45:
; 0000 006D         PORTC = (second_ones << 4) | second_tens;
	MOV  R30,R17
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R16
	OUT  0x15,R30
; 0000 006E         PORTA = (minute_tens << 4) | minute_ones;
	MOV  R30,R18
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R19
	OUT  0x1B,R30
; 0000 006F         PORTB = (hour_tens << 4) | hour_ones;
	MOV  R30,R20
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R21
	OUT  0x18,R30
; 0000 0070     }
; 0000 0071 }
_0x44:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
;
;void save_progress(void) {
; 0000 0073 void save_progress(void) {
_save_progress:
; .FSTART _save_progress
; 0000 0074     Seconds[save_count] = time % 60;
	MOVW R30,R10
	SUBI R30,LOW(-_Seconds)
	SBCI R31,HIGH(-_Seconds)
	MOVW R22,R30
	MOVW R26,R4
	CALL SUBOPT_0x3
; 0000 0075     Minutes[save_count] = (time / 60) % 60;
	SUBI R30,LOW(-_Minutes)
	SBCI R31,HIGH(-_Minutes)
	MOVW R22,R30
	CALL SUBOPT_0x4
	CALL SUBOPT_0x3
; 0000 0076     Hours[save_count] = (time / 3600) % 24;
	SUBI R30,LOW(-_Hours)
	SBCI R31,HIGH(-_Hours)
	MOVW R22,R30
	CALL SUBOPT_0x5
	MOVW R26,R22
	ST   X,R30
; 0000 0077     four[save_count] = entered_password[0] - '0';
	MOVW R26,R10
	SUBI R26,LOW(-_four)
	SBCI R27,HIGH(-_four)
	LDS  R30,_entered_password
	SUBI R30,LOW(48)
	ST   X,R30
; 0000 0078     three[save_count] = entered_password[1] - '0';
	MOVW R26,R10
	SUBI R26,LOW(-_three)
	SBCI R27,HIGH(-_three)
	__GETB1MN _entered_password,1
	SUBI R30,LOW(48)
	ST   X,R30
; 0000 0079     two[save_count] = entered_password[2] - '0';
	MOVW R26,R10
	SUBI R26,LOW(-_two)
	SBCI R27,HIGH(-_two)
	__GETB1MN _entered_password,2
	SUBI R30,LOW(48)
	ST   X,R30
; 0000 007A     one[save_count] = entered_password[3] - '0';
	MOVW R26,R10
	SUBI R26,LOW(-_one)
	SBCI R27,HIGH(-_one)
	__GETB1MN _entered_password,3
	SUBI R30,LOW(48)
	ST   X,R30
; 0000 007B     save_count++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 007C }
	RET
; .FEND
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
; 0000 007E interrupt [8] void timer1_compa_isr(void) {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007F     time++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0080     if (time == 86400)
	MOVW R26,R4
	CALL __CWD2
	__CPD2N 0x15180
	BRNE _0x47
; 0000 0081         PORTA = PORTB = PORTC = time = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	MOVW R4,R30
	OUT  0x15,R30
	OUT  0x18,R30
	OUT  0x1B,R30
; 0000 0082     else
	RJMP _0x48
_0x47:
; 0000 0083         display_time(time % 60, (time / 60) % 60, (time / 3600) % 24, 0);
	MOVW R26,R4
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	ST   -Y,R30
	CALL SUBOPT_0x4
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	ST   -Y,R30
	CALL SUBOPT_0x5
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _display_time
; 0000 0084 }
_0x48:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void) {
; 0000 0086 void main(void) {
_main:
; .FSTART _main
; 0000 0087     unsigned char keypad, entered, i, j = 0;
; 0000 0088 
; 0000 0089     DDRA = DDRB = DDRC = 0xFF;
;	keypad -> R17
;	entered -> R16
;	i -> R19
;	j -> R18
	LDI  R18,0
	LDI  R30,LOW(255)
	OUT  0x14,R30
	OUT  0x17,R30
	OUT  0x1A,R30
; 0000 008A     DDRD = 0xF8;
	LDI  R30,LOW(248)
	OUT  0x11,R30
; 0000 008B 
; 0000 008C     TCCR1A = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 008D     TCCR1B = 0x0C;
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 008E     OCR1AH = 0x7A;
	LDI  R30,LOW(122)
	OUT  0x2B,R30
; 0000 008F     OCR1AL = 0x12;
	LDI  R30,LOW(18)
	OUT  0x2A,R30
; 0000 0090 
; 0000 0091     TIMSK = 0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 0092 
; 0000 0093     #asm("sei")
	sei
; 0000 0094 
; 0000 0095     PORTA = PORTB = PORTC = time;
	MOV  R30,R4
	OUT  0x15,R30
	OUT  0x18,R30
	OUT  0x1B,R30
; 0000 0096     PORTD = 0X7F;
	LDI  R30,LOW(127)
	OUT  0x12,R30
; 0000 0097 
; 0000 0098     while (1) {
_0x49:
; 0000 0099         keypad = ReadKeypad();
	RCALL _ReadKeypad
	MOV  R17,R30
; 0000 009A 
; 0000 009B         if (keypad == '*') {
	CPI  R17,42
	BRNE _0x4C
; 0000 009C             delay = mode = 1;
	LDI  R30,LOW(1)
	MOV  R13,R30
	MOV  R6,R30
	CLR  R7
; 0000 009D             PORTA = PORTB = PORTC = 0xAA;
	LDI  R30,LOW(170)
	OUT  0x15,R30
	OUT  0x18,R30
	OUT  0x1B,R30
; 0000 009E             j = 0;
	LDI  R18,LOW(0)
; 0000 009F             entered_password[0] = '\0';
	LDI  R30,LOW(0)
	STS  _entered_password,R30
; 0000 00A0             continue;
	RJMP _0x49
; 0000 00A1         }
; 0000 00A2 
; 0000 00A3         else if (keypad == '#') {
_0x4C:
	CPI  R17,35
	BREQ PC+2
	RJMP _0x4E
; 0000 00A4             delay = 1; mode = 2;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
	LDI  R30,LOW(2)
	MOV  R13,R30
; 0000 00A5             for (i = 0; i < save_count; i++) {
	LDI  R19,LOW(0)
_0x50:
	MOVW R30,R10
	MOV  R26,R19
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x51
; 0000 00A6                 PORTA = PORTB = PORTC = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
	OUT  0x18,R30
	OUT  0x1B,R30
; 0000 00A7                 delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 00A8                 PORTA = (two[i] << 4) | one[i];
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_two)
	SBCI R31,HIGH(-_two)
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_one)
	SBCI R31,HIGH(-_one)
	LD   R30,Z
	OR   R30,R26
	OUT  0x1B,R30
; 0000 00A9                 PORTB = (four[i] << 4) | three[i];
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_four)
	SBCI R31,HIGH(-_four)
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_three)
	SBCI R31,HIGH(-_three)
	LD   R30,Z
	OR   R30,R26
	OUT  0x18,R30
; 0000 00AA                 PORTC = 0xAA;
	LDI  R30,LOW(170)
	OUT  0x15,R30
; 0000 00AB                 delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00AC                 display_time(Seconds[i], Minutes[i], Hours[i], 1);
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_Seconds)
	SBCI R31,HIGH(-_Seconds)
	LD   R30,Z
	ST   -Y,R30
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_Minutes)
	SBCI R31,HIGH(-_Minutes)
	LD   R30,Z
	ST   -Y,R30
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_Hours)
	SBCI R31,HIGH(-_Hours)
	LD   R30,Z
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _display_time
; 0000 00AD                 delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00AE             }
	SUBI R19,-1
	RJMP _0x50
_0x51:
; 0000 00AF             delay = mode = 0;
	LDI  R30,LOW(0)
	MOV  R13,R30
	MOV  R6,R30
	CLR  R7
; 0000 00B0         }
; 0000 00B1 
; 0000 00B2         else if (keypad != 10) {
	RJMP _0x52
_0x4E:
	CPI  R17,10
	BRNE PC+2
	RJMP _0x53
; 0000 00B3             if (j < (PASSWORD_LENGTH - 1)) {
	CPI  R18,4
	BRSH _0x54
; 0000 00B4                 entered_password[j] = keypad;
	MOV  R30,R18
	LDI  R31,0
	SUBI R30,LOW(-_entered_password)
	SBCI R31,HIGH(-_entered_password)
	ST   Z,R17
; 0000 00B5                 j++;
	SUBI R18,-1
; 0000 00B6             }
; 0000 00B7             if (j == 4) {
_0x54:
	CPI  R18,4
	BREQ PC+2
	RJMP _0x55
; 0000 00B8                 entered_password[j] = '\0';
	MOV  R30,R18
	LDI  R31,0
	SUBI R30,LOW(-_entered_password)
	SBCI R31,HIGH(-_entered_password)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00B9                 j = 0;
	LDI  R18,LOW(0)
; 0000 00BA                 if (mode == 1) {
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x56
; 0000 00BB                     if (password_count < MAX_PASSWORDS) {
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x57
; 0000 00BC                         strcpy(passwords[password_count], entered_password);
	MOVW R30,R8
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	CALL __MULW12U
	SUBI R30,LOW(-_passwords)
	SBCI R31,HIGH(-_passwords)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_entered_password)
	LDI  R27,HIGH(_entered_password)
	CALL _strcpy
; 0000 00BD                         password_count++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 00BE                         delay = mode = 0;
	LDI  R30,LOW(0)
	MOV  R13,R30
	MOV  R6,R30
	CLR  R7
; 0000 00BF                     }
; 0000 00C0                     entered_password[0] = '\0';
_0x57:
	LDI  R30,LOW(0)
	STS  _entered_password,R30
; 0000 00C1                     continue;
	RJMP _0x49
; 0000 00C2                 }
; 0000 00C3                 entered = 0;
_0x56:
	LDI  R16,LOW(0)
; 0000 00C4                 for (i = 0; i < password_count; i++)
	LDI  R19,LOW(0)
_0x59:
	MOVW R30,R8
	MOV  R26,R19
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x5A
; 0000 00C5                     if (strcmp(entered_password, passwords[i]) == 0)
	LDI  R30,LOW(_entered_password)
	LDI  R31,HIGH(_entered_password)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	MUL  R19,R26
	MOVW R30,R0
	SUBI R30,LOW(-_passwords)
	SBCI R31,HIGH(-_passwords)
	MOVW R26,R30
	CALL _strcmp
	CPI  R30,0
	BRNE _0x5B
; 0000 00C6                         entered = 1;
	LDI  R16,LOW(1)
; 0000 00C7 
; 0000 00C8                 if (entered) {
_0x5B:
	SUBI R19,-1
	RJMP _0x59
_0x5A:
	CPI  R16,0
	BREQ _0x5C
; 0000 00C9                     save_progress();
	RCALL _save_progress
; 0000 00CA                     correct_pass = 1;
	SBI  0x12,7
; 0000 00CB                     delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
; 0000 00CC                     correct_pass = 0;
	CBI  0x12,7
; 0000 00CD                 } else {
	RJMP _0x61
_0x5C:
; 0000 00CE                     PORTA = PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
	OUT  0x1B,R30
; 0000 00CF                     PORTB = 0xDD;
	LDI  R30,LOW(221)
	OUT  0x18,R30
; 0000 00D0                     delay = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 00D1                     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 00D2                 }
_0x61:
; 0000 00D3                 delay = 0;
	CLR  R6
	CLR  R7
; 0000 00D4                 entered_password[0] = '\0';
	LDI  R30,LOW(0)
	STS  _entered_password,R30
; 0000 00D5             }
; 0000 00D6         }
_0x55:
; 0000 00D7     }
_0x53:
_0x52:
	RJMP _0x49
; 0000 00D8 }
_0x62:
	RJMP _0x62
; .FEND

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND

	.DSEG
_passwords:
	.BYTE 0x64
_Seconds:
	.BYTE 0x32
_Minutes:
	.BYTE 0x32
_Hours:
	.BYTE 0x32
_one:
	.BYTE 0x32
_two:
	.BYTE 0x32
_three:
	.BYTE 0x32
_four:
	.BYTE 0x32
_entered_password:
	.BYTE 0x5

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	MOVW R26,R22
	ST   X,R30
	MOVW R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	MOVW R26,R4
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __DIVW21
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	MOVW R26,R4
	LDI  R30,LOW(3600)
	LDI  R31,HIGH(3600)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LD   R30,Z
	SWAP R30
	ANDI R30,0xF0
	MOV  R26,R30
	MOV  R30,R19
	LDI  R31,0
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
