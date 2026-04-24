;All of the following are members of the "System" class.
;Macro names follow the following format:
;System.CodeArea.Category.SubCategory.Subcategory2... .RegistersDestroyed.I or R
;RegistersDestroyed are listed in order of A X Y. If A and Y are destroyed, it will say AY. If X and A, it will say AX, etc.
;I stands for Immediate, R stands for Routine. I is used to save 12 cycles from a JSR/RTS, R reuses the routine at the cost
;of 12 cycles for JSR/RTS.
;Constant names may not have a code area defined.

.DEFINE System.NMI.ZTempVar0 $30
.DEFINE System.NMI.ZTempVar1 $31
.DEFINE System.NMI.ZTempVar2 $32
.DEFINE System.NMI.ZTempVar3 $33
.DEFINE System.NMI.ZTempVar4 $34
.DEFINE System.NMI.ZTempVar5 $35
.DEFINE System.NMI.ZTempVar6 $36
.DEFINE System.NMI.ZTempVar7 $37
.DEFINE System.NMI.ZTempVar8 $38
.DEFINE System.NMI.ZTempVar9 $39
.DEFINE System.NMI.ZTempVarA $3A
.DEFINE System.NMI.ZTempVarB $3B
.DEFINE System.NMI.ZTempVarC $3C
.DEFINE System.NMI.ZTempVarD $3D
.DEFINE System.NMI.ZTempVarE $3E
.DEFINE Sytsem.NMI.ZTempVarF $3F

.DEFINE System.Main.ZTempVar0 $40
.DEFINE System.Main.ZTempVar1 $41
.DEFINE System.Main.ZTempVar2 $42
.DEFINE System.Main.ZTempVar3 $43
.DEFINE System.Main.ZTempVar4 $44
.DEFINE System.Main.ZTempVar5 $45
.DEFINE System.Main.ZTempVar6 $46
.DEFINE System.Main.ZTempVar7 $47
.DEFINE System.Main.ZTempVar8 $48
.DEFINE System.Main.ZTempVar9 $49
.DEFINE System.Main.ZTempVarA $4A
.DEFINE System.Main.ZTempVarB $4B
.DEFINE System.Main.ZTempVarC $4C
.DEFINE System.Main.ZTempVarD $4D
.DEFINE System.Main.ZTempVarE $4E
.DEFINE Sytsem.Main.ZTempVarF $4F

.DEFINE System.Main.Bank0 $50
.DEFINE System.Main.Bank1 $51
.DEFINE System.Main.BankMode $52

.DEFINE System.BankMode.8A $00	;Constant
.DEFINE System.BankMode.AC $40	;Constant
.DEFINE System.Mirroring.V $00	;Constant
.DEFINE System.Mirroring.H $01	;Constant
.DEFINE System.WRAM.NotPresent $00	;Constant
.DEFINE System.WRAM.Writable $80	;Constant
.DEFINE System.WRAM.Readable $84	;Constant

.DEFINE System.NMI.AHolder $53
.DEFINE System.NMI.XHolder $54
.DEFINE System.NMI.YHolder $55

.DEFINE System.Hardware.ControlCurrent $56
.DEFINE System.Hardware.ControlPrevious $57

.DEFINE System.NMI.Math.A0 $58
.DEFINE System.NMI.Math.A1 $59
.DEFINE System.NMI.Math.A2 $5A
.DEFINE System.NMI.Math.A3 $5B
.DEFINE System.NMI.Math.B0 $5C
.DEFINE System.NMI.Math.B1 $5D
.DEFINE System.NMI.Math.B2 $5E
.DEFINE System.NMI.Math.B3 $5F
.DEFINE System.NMI.Math.Answer0 $60
.DEFINE System.NMI.Math.Answer1 $61
.DEFINE System.NMI.Math.Answer2 $62
.DEFINE System.NMI.Math.Answer3 $63
.DEFINE System.NMI.Math.Answer4 $64
.DEFINE System.NMI.Math.Answer5 $65
.DEFINE System.NMI.Math.Remainder0 System.NMI.Math.Answer4
.DEFINE System.NMI.Math.Remainder1 System.NMI.Math.Answer5
.DEFINE System.NMI.Math.Remainder2 $66
.DEFINE System.NMI.Math.Remainder3 $67

.DEFINE System.Main.Math.A0 $64
.DEFINE System.Main.Math.A1 $65
.DEFINE System.Main.Math.A2 $66
.DEFINE System.Main.Math.A3 $67
.DEFINE System.Main.Math.B0 $68
.DEFINE System.Main.Math.B1 $69
.DEFINE System.Main.Math.B2 $6A
.DEFINE System.Main.Math.B3 $6B
.DEFINE System.Main.Math.Answer0 $6C
.DEFINE System.Main.Math.Answer1 $6D
.DEFINE System.Main.Math.Answer2 $6E
.DEFINE System.Main.Math.Answer3 $6F
.DEFINE System.Main.Math.Answer4 $70
.DEFINE System.Main.Math.Answer5 $71
.DEFINE System.Main.Math.Remainder0 System.Main.Math.Answer4
.DEFINE System.Main.Math.Remainder1 System.Main.Math.Answer5
.DEFINE System.Main.Math.Remainder2 $72
.DEFINE System.Main.Math.Remainder3 $73

.DEFINE System.Main.Random.Index0 $77
.DEFINE System.Main.Random.Index1 $78
.DEFINE System.Main.Random.Random0 $79
.DEFINE System.Main.Random.Random1 $7A

.DEFINE System.Main.Convert.Hex0 $7B
.DEFINE System.Main.Convert.Hex1 $7C
.DEFINE System.Main.Convert.Hex2 $7D
.DEFINE System.Main.Convert.Hex3 $7E

.DEFINE System.Main.Convert.DecOnes $7F
.DEFINE System.Main.Convert.DecTens $80
.DEFINE System.Main.Convert.DecHundreds $81
.DEFINE System.Main.Convert.DecThousands $82
.DEFINE System.Main.Convert.DecTenThousands $83
.DEFINE System.Main.Convert.DecHundredThousands $84
.DEFINE System.Main.Convert.DecMillions $85
.DEFINE System.Main.Convert.DecTenMillions $86

.DEFINE System.NMI.VBLCount Game.VBLCount


.DEFINE System.Hardware.ControlTrigger $87

.DEFINE System.Main.TempAdd0L $88
.DEFINE System.Main.TempAdd0H $89
.DEFINE System.Main.TempAdd1L $8A
.DEFINE System.Main.TempAdd1H $8B
.DEFINE System.Main.TempAdd2L $8C
.DEFINE System.Main.TempAdd2H $8D
.DEFINE System.Main.TempAdd3L $8E
.DEFINE System.Main.TempAdd3H $8F
.DEFINE System.Main.TempAdd4L $90
.DEFINE System.Main.TempAdd4H $91
.DEFINE System.Main.TempAdd5L $92
.DEFINE System.Main.TempAdd5H $93
.DEFINE System.Main.TempAdd6L $94
.DEFINE System.Main.TempAdd6H $95
.DEFINE System.Main.TempAdd7L $96
.DEFINE System.Main.TempAdd7H $97


;***************** Bank Switching ******************
;All of the following take 18 cycles to execute

.MACRO System.Main.BankSwitch.C000.A.I() ARGS Bank
	lda #$46
	sta System.Main.BankMode
	sta $8000
	lda #Bank
	sta System.Main.Bank0
	sta $8001
.ENDM

.MACRO System.Main.BankSwitch.C000.X.I() ARGS Bank
	ldx #$46
	stx System.Main.BankMode
	stx $8000.w
	ldx #Bank
	stx System.Main.Bank0
	stx $8001.w
.ENDM

.MACRO System.Main.BankSwitch.C000.Y.I() ARGS Bank
	ldy #$46
	sty System.Main.BankMode
	sty $8000.w
	ldy #Bank
	sty System.Main.Bank0
	sty $8001.w
.ENDM

.MACRO System.Main.BankSwitch.A000.A.I() ARGS Bank, Mode
	lda #Mode+7
	sta System.Main.BankMode
	sta $8000
	lda #Bank
	sta System.Main.Bank1
	sta $8001
.ENDM

.MACRO System.Main.BankSwitch.A000.X.I() ARGS Bank, Mode
	ldx #Mode+7
	stx System.Main.BankMode
	stx $8000.w
	ldx #Bank
	stx System.Main.Bank1
	stx $8001.w
.ENDM

.MACRO System.Main.BankSwitch.A000.Y.I() ARGS Bank, Mode
	ldy #Mode+7
	sty System.Main.BankMode
	sty $8000.w
	ldy #Bank
	sty System.Main.Bank1
	sty $8001.w
.ENDM

.MACRO System.Main.BankSwitch.8000.A.I() ARGS Bank
	lda #6
	sta System.Main.BankMode
	sta $8000
	lda #Bank
	sta System.Main.Bank0
	sta $8001
.ENDM

.MACRO System.Main.BankSwitch.8000.X.I() ARGS Bank
	ldx #6
	stx System.Main.BankMode
	stx $8000.w
	ldx #Bank
	stx System.Main.Bank0
	stx $8001.w
.ENDM

.MACRO System.Main.BankSwitch.8000.Y.I() ARGS Bank
	ldy #6
	sty System.Main.BankMode
	sty $8000.w
	ldy #Bank
	sty System.Main.Bank0
	sty $8001.w
.ENDM

.MACRO System.Reset.Set.Mirroring() ARGS Mirroring
	lda #Mirroring
	sta $A000
.ENDM

.MACRO System.Reset.Set.WRAM() ARGS Settings
	lda #Settings
	sta $A001
.ENDM
;***********************************************
.MACRO System.NMI.Save.AXY()
	sta System.NMI.AHolder
	stx System.NMI.XHolder
	sty System.NMI.YHolder
.ENDM

.MACRO System.NMI.Restore.AXY()
	lda System.NMI.AHolder
	ldx System.NMI.XHolder
	ldy System.NMI.YHolder
.ENDM

.MACRO System.NMI.Restore.Banks()
	lda #6
	sta $8000
	lda System.Main.Bank0
	sta $8001
	lda #7
	sta $8000
	lda System.Main.Bank1
	sta $8001

	lda System.Main.BankMode
	sta $8000
.ENDM

.MACRO System.NMI.Restore.Main()
	System.NMI.Restore.Banks()
	System.NMI.Restore.AXY()
.ENDM
;***********************************************
.MACRO System.Clear.RAM.All()
;Clears all of 2k RAM

	ldx #0
	lda #0
-
	sta $0,x
	sta $100,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	dex
	bne -
.ENDM

.MACRO System.Clear.RAM() ARGS Start, Length
;Clears up to 256 bytes of RAM given a starting position
	ldx #Length
	lda #$00
-
	sta Start,x
	dex
	bne -
.ENDM
;*********************************************
.MACRO System.Main.Read.Controller()
	lda System.Hardware.ControlCurrent
	sta System.Hardware.ControlPrevious

	ldx #1
	stx $4016.w
	dex
	stx $4016.w

	ldy #8
-
	lda $4016
	lsr a
	rol System.Hardware.ControlCurrent
	dey
	bne -

	
	lda System.Hardware.ControlCurrent
	and System.Hardware.ControlPrevious
	eor System.Hardware.ControlCurrent
	sta System.Hardware.ControlTrigger			;Gives us a 1 for each button that is NEWLY pressed.
								;And wasn't pressed last frame.
.ENDM

.MACRO System.RetrieveReciprocal.X()
	lda System.Main.QuickDivide.LowBytes.w,x
	ldy System.Main.QuickDivide.HighBytes.w,x

.ENDM

.MACRO System.RetrieveReciprocal.Y()
	lda System.Main.QuickDivide.LowBytes.w,y
	ldx System.Main.QuickDivide.HighBytes.w,y
.ENDM