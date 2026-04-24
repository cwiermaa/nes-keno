Game.Main.CreditsMode:
	lda #<Game.NMI.CreditsMode
	sta Game.NMIL
	lda #>Game.NMI.CreditsMode
	sta Game.NMIH

	lda Game.Main.CreditsMode.Credits0
	sta System.Main.Convert.Hex0
	lda Game.Main.CreditsMode.Credits1
	sta System.Main.Convert.Hex1
	lda Game.Main.CreditsMode.Credits2
	sta System.Main.Convert.Hex2
	jsr System.Main.HexToDecimal.24
	lda System.Main.Convert.DecTenMillions
	sta Game.NMI.CreditMode.Credit1
	lda System.Main.Convert.DecMillions
	sta Game.NMI.CreditMode.Credit2
	lda System.Main.Convert.DecHundredThousands
	sta Game.NMI.CreditMode.Credit3
	lda System.Main.Convert.DecTenThousands
	sta Game.NMI.CreditMode.Credit4
	lda System.Main.Convert.DecThousands
	sta Game.NMI.CreditMode.Credit5
	lda System.Main.Convert.DecHundreds
	sta Game.NMI.CreditMode.Credit6
	lda System.Main.Convert.DecTens
	sta Game.NMI.CreditMode.Credit7
	lda System.Main.Convert.DecOnes
	sta Game.NMI.CreditMode.Credit8

	jsr Game.Main.CreditsMode.ChangeCredits
	jsr Game.Main.CreditsMode.Cursor
	jsr Game.Main.ChooseMode.CreatePayInformation
	jmp LoopReturn

Game.Main.CreditsMode.ChangeCredits:
	System.Main.Read.Controller()

	lda System.Hardware.ControlTrigger
	and #$01
	beq ++
	lda Game.Main.CreditsMode.IncrementIndex
	cmp #7
	bne +
	rts
+
	inc Game.Main.CreditsMode.IncrementIndex
++

	lda System.Hardware.ControlTrigger
	and #$02
	beq ++
	lda Game.Main.CreditsMode.IncrementIndex
	cmp #0
	bne +
	lda #<Game.Main.BetMode
	sta Game.MainL
	lda #>Game.Main.BetMode
	sta Game.MainH
	rts
+
	dec Game.Main.CreditsMode.IncrementIndex
++

	ldx Game.Main.CreditsMode.IncrementIndex
	lda Game.Main.CreditsMode.CreditsIncrement0.w,x
	sta Game.Main.CreditsMode.Increment0
	lda Game.Main.CreditsMode.CreditsIncrement1.w,x
	sta Game.Main.CreditsMode.Increment1
	lda Game.Main.CreditsMode.CreditsIncrement2.w,x
	sta Game.Main.CreditsMode.Increment2


	lda System.Hardware.ControlTrigger
	and #$88
	beq ++
	clc
	lda Game.Main.CreditsMode.Credits0
	adc Game.Main.CreditsMode.Increment0
	sta Game.Main.CreditsMode.Credits0
	lda Game.Main.CreditsMode.Credits1
	adc Game.Main.CreditsMode.Increment1
	sta Game.Main.CreditsMode.Credits1
	lda Game.Main.CreditsMode.Credits2
	adc Game.Main.CreditsMode.Increment2
	sta Game.Main.CreditsMode.Credits2
++
	lda System.Hardware.ControlTrigger
	and #$44
	beq ++
	sec
	lda Game.Main.CreditsMode.Credits0
	sbc Game.Main.CreditsMode.Increment0
	sta Game.Main.CreditsMode.Credits0
	lda Game.Main.CreditsMode.Credits1
	sbc Game.Main.CreditsMode.Increment1
	sta Game.Main.CreditsMode.Credits1
	lda Game.Main.CreditsMode.Credits2
	sbc Game.Main.CreditsMode.Increment2
	sta Game.Main.CreditsMode.Credits2
++

	lda System.Hardware.ControlTrigger
	and #$20
	beq +

	lda #<Game.Main.ChooseMode
	sta Game.MainL
	lda #>Game.Main.ChooseMode
	sta Game.MainH

+
	lda System.Hardware.ControlTrigger
	and #$10
	beq +
	lda Game.Main.ChooseMode.NumberPicked
	beq +

	jsr Game.Main.CreditsMode.AlterCredits
	lda #<Game.Main.SpinMode
	sta Game.MainL
	lda #>Game.Main.SpinMode
	sta Game.MainH

+
	rts

Game.Main.CreditsMode.CreditsIncrement0:
	.db $80,$40,$A0,$10,$E8,$64,$0A,$01
Game.Main.CreditsMode.CreditsIncrement1:
	.db $96,$43,$86,$27,$03,$00,$00,$00
Game.Main.CreditsMode.CreditsIncrement2:
	.db $98,$0F,$01,$00,$00,$00,$00,$00


Game.Main.CreditsMode.Cursor:
	clc
	lda Game.Main.CreditsMode.IncrementIndex
	asl a
	asl a
	asl a
	adc #160
	sta $303
	lda #223
	sta $300
	lda #$01
	sta $301
	lda #$20
	sta $302
	rts
;************************************************************
;************************************************************
;************************************************************

Game.NMI.CreditsMode:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.CreditsMode.PPUUpdates
	jsr Game.NMI.CreditsMode.APUUpdates

	inc Game.VBLCount

	pla
	tay
	pla
	tax
	pla
	rti

Game.NMI.CreditsMode.PPUUpdates:
	jsr Game.NMI.CreditsMode.DisplayCredits
	jsr Game.NMI.ChooseMode.DisplayPayInformation

	lda #$00
	sta $2005
	sta $2005

	lda #3
	sta $4014
	rts
Game.NMI.CreditsMode.APUUpdates:
	rts

Game.Main.CreditsMode.AlterCredits:
	sec
	lda Game.Main.CreditsMode.Credits0
	sbc Game.Main.BetMode.Bet
	sta Game.Main.CreditsMode.Credits0
	lda Game.Main.CreditsMode.Credits1
	sbc #0
	sta Game.Main.CreditsMode.Credits1
	lda Game.Main.CreditsMode.Credits2
	sbc #0
	sta Game.Main.CreditsMode.Credits2

	lda Game.Main.CreditsMode.Credits0
	sta System.Main.Convert.Hex0
	lda Game.Main.CreditsMode.Credits1
	sta System.Main.Convert.Hex1
	lda Game.Main.CreditsMode.Credits2
	sta System.Main.Convert.Hex2
	jsr System.Main.HexToDecimal.24
	lda System.Main.Convert.DecTenMillions
	sta Game.NMI.CreditMode.Credit1
	lda System.Main.Convert.DecMillions
	sta Game.NMI.CreditMode.Credit2
	lda System.Main.Convert.DecHundredThousands
	sta Game.NMI.CreditMode.Credit3
	lda System.Main.Convert.DecTenThousands
	sta Game.NMI.CreditMode.Credit4
	lda System.Main.Convert.DecThousands
	sta Game.NMI.CreditMode.Credit5
	lda System.Main.Convert.DecHundreds
	sta Game.NMI.CreditMode.Credit6
	lda System.Main.Convert.DecTens
	sta Game.NMI.CreditMode.Credit7
	lda System.Main.Convert.DecOnes
	sta Game.NMI.CreditMode.Credit8
	rts

Game.NMI.CreditsMode.DisplayCredits:
	lda #$23
	sta $2006
	lda #$94
	sta $2006

	lda Game.NMI.CreditMode.Credit1		;If zero, store tile #$00 onto name table
	beq +
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit2		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit3		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit4		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit5		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit6		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit7		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit8
	ora #$30
	sta $2007
	jmp +++

+
	sta $2007
	lda Game.NMI.CreditMode.Credit2		;If zero, store tile #$00 onto name table
	beq +
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit3		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit4		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit5		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit6		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit7		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit8
	ora #$30
	sta $2007
	jmp +++
+
	sta $2007
	lda Game.NMI.CreditMode.Credit3		;If zero, store tile #$00 onto name table
	beq +
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit4		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit5		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit6		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit7		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit8
	ora #$30
	sta $2007
	jmp +++
+
	sta $2007
	lda Game.NMI.CreditMode.Credit4		;If zero, store tile #$00 onto name table
	beq +
	ora #$30					;Dirty shortcut.
	sta $2007	
	lda Game.NMI.CreditMode.Credit5		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit6		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit7		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit8
	ora #$30
	sta $2007
	jmp +++
+
	sta $2007
	lda Game.NMI.CreditMode.Credit5		;If zero, store tile #$00 onto name table
	beq +
	ora #$30		
	sta $2007
	lda Game.NMI.CreditMode.Credit6		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit7		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit8
	ora #$30
	sta $2007				;Dirty shortcut.
	jmp +++
+
	sta $2007
	lda Game.NMI.CreditMode.Credit6		;If zero, store tile #$00 onto name table
	beq +
	ora #$30					;Dirty shortcut.
	sta $2007	
	lda Game.NMI.CreditMode.Credit7		;If zero, store tile #$00 onto name table
	ora #$30					;Dirty shortcut.
	sta $2007
	lda Game.NMI.CreditMode.Credit8
	ora #$30
	sta $2007
	jmp +++
+
	sta $2007
	lda Game.NMI.CreditMode.Credit7		;If zero, store tile #$00 onto name table
	beq +
	ora #$30					;Dirty shortcut.
+
	sta $2007

	lda Game.NMI.CreditMode.Credit8
	ora #$30
	sta $2007

+++
	rts