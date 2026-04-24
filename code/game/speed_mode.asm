Game.Main.SpeedMode:
	lda #<Game.NMI.SpeedMode
	sta Game.NMIL
	lda #>Game.NMI.SpeedMode
	sta Game.NMIH

	jsr Game.Main.SpeedMode.ChangeSpeed

	lda #80
	sta $303
	lda #231
	sta $300
	lda #$02
	sta $301
	lda #$20
	sta $302

	jsr Game.Main.ChooseMode.CreatePayInformation
	jmp LoopReturn


Game.Main.SpeedMode.ChangeSpeed:
	System.Main.Read.Controller()

	lda System.Hardware.ControlTrigger
	and #$20
	beq +

	lda #<Game.Main.ChooseMode
	sta Game.MainL
	lda #>Game.Main.ChooseMode
	sta Game.MainH

+

	lda System.Hardware.ControlTrigger
	and #$44
	beq ++
	sec
	lda Game.Main.SpeedMode.Speed
	cmp #1
	bne +
	rts
+
	sbc #1
	sta Game.Main.SpeedMode.Speed
++


	lda System.Hardware.ControlTrigger
	and #$88
	beq ++

	clc
	lda Game.Main.SpeedMode.Speed
	cmp #3
	bne +
	rts
+
	adc #1
	sta Game.Main.SpeedMode.Speed
++

	lda System.Hardware.ControlTrigger
	and #$01
	beq ++

	lda #10
	sta Game.Main.BetMode.Increment
	lda #<Game.Main.BetMode
	sta Game.MainL
	lda #>Game.Main.BetMode
	sta Game.MainH
++
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
;********************************************************
;********************************************************
;********************************************************

Game.NMI.SpeedMode:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.SpeedMode.PPUUpdates
	jsr Game.NMI.SpeedMode.APUUpdates

	inc Game.VBLCount

	pla
	tay
	pla
	tax
	pla
	rti

Game.NMI.SpeedMode.PPUUpdates:
	lda #$23
	sta $2006
	lda #$89
	sta $2006

	ldx Game.Main.SpeedMode.Speed
	sec
	lda #3
	sbc Game.Main.SpeedMode.Speed
	tay
-
	lda #$E1
	sta $2007
	dex
	bne -

	cpy #0
	beq +
-
	lda #$E0
	sta $2007
	dey
	bne -
+

	jsr Game.NMI.ChooseMode.DisplayPayInformation

	lda #3
	sta $4014

	lda #$00
	sta $2005
	sta $2005
	rts
Game.NMI.SpeedMode.APUUpdates:
	rts