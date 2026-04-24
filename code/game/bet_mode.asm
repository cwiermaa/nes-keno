Game.Main.BetMode:
	lda #<Game.NMI.BetMode
	sta Game.NMIL
	lda #>Game.NMI.BetMode
	sta Game.NMIH

	lda Game.Main.BetMode.Bet
	sta System.Main.Convert.Hex0
	jsr System.Main.HexToDecimal.8
	lda System.Main.Convert.DecTens
	sta Game.NMI.BetMode.Bet1
	lda System.Main.Convert.DecOnes
	sta Game.NMI.BetMode.Bet2

	jsr Game.Main.BetMode.ChangeBet

	jsr Game.Main.BetMode.Cursor

	jsr Game.Main.ChooseMode.CreatePayInformation
	jmp LoopReturn


;************************************************************
Game.Main.BetMode.ChangeBet:
	System.Main.Read.Controller()

	lda System.Hardware.ControlTrigger
	and #$44
	beq ++

	sec
	lda Game.Main.BetMode.Bet			;Subtract bet increment from the bet if B is pressed.
	sbc Game.Main.BetMode.Increment
	bpl +						;If the value is positive, great.
	lda #$00					;Otherwise, set the Bet to 0.
+
	sta Game.Main.BetMode.Bet	
++

	lda System.Hardware.ControlTrigger
	and #$88
	beq ++

	clc
	lda Game.Main.BetMode.Bet			;Add bet increment to the bet if A is pressed.
	adc Game.Main.BetMode.Increment
	cmp #51						;Dirty trick, rather than seeing if it's <= 50, just see if < 51.
	bcc +						;If the value is 50 or less, great
	lda #50						;Otherwise, set the Bet to 50
+
	sta Game.Main.BetMode.Bet	
++

;*********

	lda System.Hardware.ControlTrigger
	and #$01
	beq ++
	lda Game.Main.BetMode.Increment
	cmp #1
	bne +

	lda #0
	sta Game.Main.CreditsMode.IncrementIndex
	lda #<Game.Main.CreditsMode
	sta Game.MainL
	lda #>Game.Main.CreditsMode
	sta Game.MainH
+
	lda #1
	sta Game.Main.BetMode.Increment
++

	lda System.Hardware.ControlTrigger
	and #$02
	beq ++
	lda Game.Main.BetMode.Increment
	cmp #10
	bne +
	
	lda #<Game.Main.SpeedMode
	sta Game.MainL
	lda #>Game.Main.SpeedMode
	sta Game.MainH
+
	lda #10
	sta Game.Main.BetMode.Increment
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

	lda #<Game.Main.SpinMode
	sta Game.MainL
	lda #>Game.Main.SpinMode
	sta Game.MainH

	jsr Game.Main.CreditsMode.AlterCredits
+
	rts


;*******************************************
Game.Main.BetMode.Cursor:
	lda Game.Main.BetMode.Increment
	cmp #1
	bne +
	lda #144
	sta $303
	lda #223
	sta $300
	lda #$01
	sta $301
	lda #$20
	sta $302
	rts
+
	lda #136
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

Game.NMI.BetMode:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.BetMode.PPUUpdates
	jsr Game.NMI.BetMode.APUUpdates

	inc Game.VBLCount

	pla
	tay
	pla
	tax
	pla
	rti

Game.NMI.BetMode.PPUUpdates:
	lda #$23
	sta $2006
	lda #$91
	sta $2006

	lda Game.NMI.BetMode.Bet1		;If zero, store tile #$00 onto name table
	beq +
	ora #$30				;Dirty shortcut.
+
	sta $2007
	lda Game.NMI.BetMode.Bet2
	ora #$30
	sta $2007

	jsr Game.NMI.ChooseMode.DisplayPayInformation

	lda #$00
	sta $2005
	sta $2005

	lda #3
	sta $4014
	rts

Game.NMI.BetMode.APUUpdates:
	rts
