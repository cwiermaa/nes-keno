Game.Main.SpinMode:

	lda #<Game.Main.Spin1.5Mode
	sta Game.MainL
	lda #>Game.Main.Spin1.5Mode
	sta Game.MainH

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

	jsr Game.Main.SpinMode.DrawNumbers
	jsr Game.Main.SpinMode.AddWin
	jsr Game.Main.SpinMode.CreateBallInformation
	lda #21
	sta Game.NMI.Balls.DrawBallNumber
Game.Main.Spin1.5Mode:
	lda #<Game.NMI.SpinMode
	sta Game.NMIL
	lda #>Game.NMI.SpinMode
	sta Game.NMIH

	jsr Game.Main.ChooseMode.CreatePayInformation
	jmp LoopReturn

Game.Main.Spin2Mode:
	lda #<Game.NMI.Spin2Mode
	sta Game.NMIL
	lda #>Game.NMI.Spin2Mode
	sta Game.NMIH

	lda Game.NMI.SpinMode.FrameCounter
	bne +
	ldx Game.Main.SpeedMode.Speed
	lda Game.Main.SpinMode.FrameSpeed.w,x
	sta Game.NMI.SpinMode.FrameCounter

	jsr Game.Main.SpinMode.HighlightWin
	ldx Game.NMI.SpinMode.RandomIndex
	lda $200,x
	tax
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.NMI.SpinMode.AttributeTable,y
	ora Game.Main.ChooseMode.Attributes.RedMasks.w,x
	sta Game.NMI.SpinMode.AttributeTable,y
	inc Game.NMI.SpinMode.RandomIndex

	lda Game.NMI.SpinMode.RandomIndex
	cmp #20
	bcc +

	lda #<Game.Main.Spin3Mode
	sta Game.MainL
	lda #>Game.Main.Spin3Mode
	sta Game.MainH
+
	jmp LoopReturn

Game.Main.Spin3Mode:
	lda Game.NMI.Balls.DrawBallNumber
	cmp #21
	bne +
	lda #<Game.NMI.Spin3Mode
	sta Game.NMIL
	lda #>Game.NMI.Spin3Mode
	sta Game.NMIH

	jsr Game.Main.SpinMode.WaitToDeclareWin
	jsr Game.Main.Spin3Mode.CountWin
+
	jmp LoopReturn

Game.Main.SpinMode.WaitToDeclareWin:
	System.Main.Read.Controller()
	lda System.Hardware.ControlTrigger
	and #$10
	beq +

	jsr Game.Main.SpinMode.ClearRedAttributes
	lda #<Game.Main.SpinMode
	sta Game.MainL
	lda #>Game.Main.SpinMode
	sta Game.MainH
	jsr Game.Main.CreditsMode.AlterCredits
+
	lda System.Hardware.ControlTrigger
	and #$EF
	beq +

	jsr Game.Main.SpinMode.ClearRedAttributes
	lda #<Game.Main.ChooseMode
	sta Game.MainL
	lda #>Game.Main.ChooseMode
	sta Game.MainH

+
	rts

Game.Main.SpinMode.ClearRedAttributes:
	lda $28A
	and #$5F
	sta $28A
	lda $28B
	and #$5F
	sta $28B
	lda $28C
	and #$5F
	sta $28C
	lda $28D
	and #$5F
	sta $28D
	lda $28E
	and #$5F
	sta $28E

	lda $292
	and #$55
	sta $292
	lda $293
	and #$55
	sta $293
	lda $294
	and #$55
	sta $294
	lda $295
	and #$55
	sta $295
	lda $296
	and #$55
	sta $296

	lda $29A
	and #$05
	sta $29A
	lda $29B
	and #$05
	sta $29B
	lda $29C
	and #$05
	sta $29C
	lda $29D
	and #$05
	sta $29D
	lda $29E
	and #$05
	sta $29E

	lda $2A2
	and #$55
	sta $2A2
	lda $2A3
	and #$55
	sta $2A3
	lda $2A4
	and #$55
	sta $2A4
	lda $2A5
	and #$55
	sta $2A5
	lda $2A6
	and #$55
	sta $2A6

	lda $2AA
	and #$55
	sta $2AA
	lda $2AB
	and #$55
	sta $2AB
	lda $2AC
	and #$55
	sta $2AC
	lda $2AD
	and #$55
	sta $2AD
	lda $2AE
	and #$55
	sta $2AE
	
	lda #$00
	sta $280
	sta $281
	sta $288
	sta $289
	sta $290
	sta $291
	sta $298
	sta $299
	sta $2A0
	sta $2A1
	sta $2A8
	sta $2A9
	
	lda #$00
	sta $287
	sta $28F
	sta $297
	sta $29F
	sta $2A7
	sta $2AF
	lda #$A0
	sta $2B7
	
	ldy #0
	lda #$FF
-
	sta $300.w,y
	iny
	iny
	iny
	iny
	bne -
	rts
Game.Main.SpinMode.DrawNumbers:
;If A was pressed, draw 20 random numbers

	lda Game.VBLCount				;Initialize some values for random drawing
	sta System.Main.Random.Random0
	sec
	lda System.Main.Random.Index0
	sbc #1
	adc Game.VBLCount
	and #$0F
	sta System.Main.Random.Index0

	ldx #0						;Clear random number string
	ldy #20
	lda #$9F
-
	sta $200,x
	inx
	dey
	bne -

	ldx #0
	ldy #20
	sty System.Main.ZTempVar2
-
	stx System.Main.ZTempVar1			;Retrieve random number
--
	jsr System.Main.Random.8

	ldx System.Main.ZTempVar1			;Validate the number
	lda System.Main.Random.Random0
							;First see if it is greater than 79
	cmp #80
	bcs --						;If so, draw a new number

	ldy #21						;This is tricky code. We must compare each
	sty System.Main.ZTempVar3			;Drawn value to the current value. If any are equal
	ldy #$FF					;Draw a new number
---
	dec System.Main.ZTempVar3			;Loop 20 times
	beq +						;If counter is 0, leave the loop
	iny						;Move to next value to compare
	cmp $200,y					;If not equal
	bne ---						;Keep moving
	jmp --						;Else, draw a new number
+
	sta $200,x					;If not equal to any other number, and less than 79, store value
	inx						;Move on
	dec System.Main.ZTempVar2
	bne -
+++
	rts
	
Game.Main.SpinMode.HighlightWin:
	ldx Game.NMI.SpinMode.RandomIndex
	ldy Game.Main.SpinMode.PickedSoFar
	lda $200,x
	cmp Game.Main.SpinMode.Matching.w,y
	bne +++
	inc Game.Main.SpinMode.PickedSoFar
	
	lda #$81
	sta Game.Main.SpinMode.Sound
	
	ldx Game.Main.ChooseMode.NumberPicked
	lda Game.Main.SpinMode.PayTable.PointersL.w,x
	sta System.Main.TempAdd0L
	lda Game.Main.SpinMode.PayTable.PointersH.w,x
	sta System.Main.TempAdd0H
	
	lda Game.Main.SpinMode.PickedSoFar
	asl a
	tay
	lda (System.Main.TempAdd0L),y
	bne +
	iny
	lda (System.Main.TempAdd0L),y
	bne +
	rts
+
	ldx Game.Main.SpinMode.HighlightedWin
	lda Game.Main.SpinMode.WinHighlights.AttributeL.w,x
	sta System.Main.TempAdd0L
	lda #$02
	sta System.Main.TempAdd0H
	ldy #0
	lda Game.Main.SpinMode.WinHighlights.w,x
	sta (System.Main.TempAdd0L),y
	iny
	sta (System.Main.TempAdd0L),y
	sec
	lda System.Main.TempAdd0L
	sbc #8
	sta System.Main.TempAdd0L
	lda #$00
	tay
	sta (System.Main.TempAdd0L),y
	iny
	sta (System.Main.TempAdd0L),y
	inc Game.Main.SpinMode.HighlightedWin
	rts
+++
	lda #$80
	sta Game.Main.SpinMode.Sound
	rts

Game.Main.SpinMode.CreateBallInformation:
	lda #$FF
	sta System.Main.ZTempVar3				;Starting Y Coordinate High
	lda #$E0
	sta System.Main.ZTempVar4				;Starting X and Y Coordinate Low
	sta System.Main.ZTempVar5
	ldx #0
	stx System.Main.ZTempVar6
	stx System.Main.ZTempVar7
	stx System.Main.ZTempVar8
-
	clc
	lda $200.w,x
	pha
	adc #1
	sta System.Main.Convert.Hex0
	jsr System.Main.HexToDecimal.8
	ldy System.Main.ZTempVar7
	lda System.Main.Convert.DecTens
	asl a
	asl a
	asl a
	asl a
	ora System.Main.Convert.DecOnes
	sta Game.NMI.Balls.Value.w,y
	
	ldx System.Main.ZTempVar6
	pla
	cmp Game.Main.SpinMode.Matching.w,x
	bne +
	inc System.Main.ZTempVar6
	lda #2
	sta Game.NMI.Balls.Color.w,y
	jmp ++
+
	lda #0
	sta Game.NMI.Balls.Color.w,y
++
	lda System.Main.ZTempVar3
	sta Game.NMI.Balls.YH.w,y
	lda System.Main.ZTempVar4
	sta Game.NMI.Balls.YL.w,y
	lda System.Main.ZTempVar5
	sta Game.NMI.Balls.X.w,y
	
	lda System.Main.ZTempVar5
	eor #$10
	sta System.Main.ZTempVar5
	sec
	lda System.Main.ZTempVar4
	sbc #24
	sta System.Main.ZTempVar4
	lda System.Main.ZTempVar3
	sbc #0
	sta System.Main.ZTempVar3
	clc
	lda System.Main.ZTempVar7
	adc #5
	sta System.Main.ZTempVar7
	inc System.Main.ZTempVar8
	ldx System.Main.ZTempVar8
	cpx #20
	bne -
	
	rts
;*************************************************
Game.Main.SpinMode.PayTable.PointersL:
	.db <Game.Main.SpinMode.PayTable.0
	.db <Game.Main.SpinMode.PayTable.1
	.db <Game.Main.SpinMode.PayTable.2
	.db <Game.Main.SpinMode.PayTable.3
	.db <Game.Main.SpinMode.PayTable.4
	.db <Game.Main.SpinMode.PayTable.5
	.db <Game.Main.SpinMode.PayTable.6
	.db <Game.Main.SpinMode.PayTable.7
	.db <Game.Main.SpinMode.PayTable.8
	.db <Game.Main.SpinMode.PayTable.9
	.db <Game.Main.SpinMode.PayTable.A

Game.Main.SpinMode.PayTable.PointersH:
	.db >Game.Main.SpinMode.PayTable.0
	.db >Game.Main.SpinMode.PayTable.1
	.db >Game.Main.SpinMode.PayTable.2
	.db >Game.Main.SpinMode.PayTable.3
	.db >Game.Main.SpinMode.PayTable.4
	.db >Game.Main.SpinMode.PayTable.5
	.db >Game.Main.SpinMode.PayTable.6
	.db >Game.Main.SpinMode.PayTable.7
	.db >Game.Main.SpinMode.PayTable.8
	.db >Game.Main.SpinMode.PayTable.9
	.db >Game.Main.SpinMode.PayTable.A


;Wins are 16 bit, multiplied by an 8 bit bet to get the grand total winnings (up to 24 bits)
;Define low/high
;See PayTable.txt for non-hex numbers

Game.Main.SpinMode.PayTable.0:

Game.Main.SpinMode.PayTable.1:
	.db $00,$00,$03,$00
Game.Main.SpinMode.PayTable.2:
	.db $00,$00,$00,$00,$0F,$00
Game.Main.SpinMode.PayTable.3:
	.db $00,$00,$00,$00,$03,$00,$2E,$00
Game.Main.SpinMode.PayTable.4:
	.db $00,$00,$00,$00,$02,$00,$05,$00,$5B,$00
Game.Main.SpinMode.PayTable.5:
	.db $00,$00,$00,$00,$00,$00,$03,$00,$0C,$00,$2A,$03
Game.Main.SpinMode.PayTable.6:
	.db $00,$00,$00,$00,$00,$00,$03,$00,$04,$00,$46,$00,$40,$06
Game.Main.SpinMode.PayTable.7:
	.db $00,$00,$00,$00,$00,$00,$01,$00,$02,$00,$15,$00,$90,$01,$58,$1B
Game.Main.SpinMode.PayTable.8:
	.db $00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$0C,$00,$62,$00,$74,$06,$10,$27
Game.Main.SpinMode.PayTable.9:
	.db $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$06,$00,$2C,$00,$4F,$01,$5C,$12,$10,$27
Game.Main.SpinMode.PayTable.A:
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$18,$00,$8E,$00,$E8,$03,$94,$11,$10,$27

Game.NMI.SpinMode.BallTileLocationsL:
	.db $1C,$1E,$DC,$DE,$9C,$9E,$5C,$5E,$1C,$1E,$DC,$DE,$9C,$9E,$5C,$5E
	.db $1C,$1E,$DC,$DE,$9C,$9E,$5C,$5E
	
Game.NMI.SpinMode.BallTileLocationsH:
	.db $23,$23,$22,$22,$22,$22,$22,$22,$22,$22,$21,$21,$21,$21,$21,$21
	.db $21,$21,$20,$20,$20,$20,$20,$20

Game.NMI.SpinMode.BallMasksRed:
	.db $02,$08,$20,$80,$02,$08,$20,$80,$02,$08,$20,$80,$02,$08,$20,$80
	.db $02,$08,$20,$80
	
Game.NMI.SpinMode.BallMasks.Location:
	.db $B7,$B7,$AF,$AF,$AF,$AF,$A7,$A7,$A7,$A7,$9F,$9F,$9F,$9F,$97,$97
	.db $97,$97,$8F,$8F,$8F,$8F,$87,$87
	
Game.NMI.SpinMode.BallSpriteStops:
	.db 192, 192, 176, 176, 160, 160, 144, 144, 128, 128, 112, 112, 96, 96
	.db 80, 80, 64, 64, 48, 48
	
Game.Main.SpinMode.WinHighlights:
	.db $05, $50, $05, $50, $05, $50, $05, $50, $05, $50, $05

Game.Main.SpinMode.WinHighlights.AttributeL:
	.db $88, $88, $90, $90, $98, $98, $A0, $A0, $A8, $A8
	
Game.Main.SpinMode.FrameSpeed:
	.db 0, 30, 13, 8						;The amount of frames to wait depending on the speed.
									;Speed is also always 1-3, not 0-2, so we must
									;Put a dummy value before the first real value.
;*************************************************
;*************************************************
;*************************************************

Game.NMI.SpinMode:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.SpinMode.PPUUpdates
	jsr Game.NMI.SpinMode.APUUpdates

	inc Game.VBLCount

	pla
	tay
	pla
	tax
	pla
	rti



Game.NMI.SpinMode.PPUUpdates:

	ldx Game.NMI.ChooseMode.PayString.TableEntry
	lda Game.NMI.ChooseMode.PPUAddress.NumberH.w,x
	sta $2006
	lda Game.NMI.ChooseMode.PPUAddress.NumberL.w,x
	sta $2006

	lda Game.NMI.ChooseMode.PayString.PayNumber1
	sta $2007
	lda Game.NMI.ChooseMode.PayString.PayNumber2
	sta $2007

	ldx Game.NMI.ChooseMode.PayString.TableEntry
	lda Game.NMI.ChooseMode.PPUAddress.PayStringH.w,x
	sta $2006
	lda Game.NMI.ChooseMode.PPUAddress.PayStringL.w,x
	sta $2006

	ldx #0
	ldy #6
-
	lda Game.NMI.ChooseMode.PayString,x
	sta $2007
	inx
	dey
	bne -

;Clear where the balls fall.
	lda #$8C
	sta $2000
	
	lda #$20
	sta $2006
	lda #$1C
	sta $2006
	
	ldx #26
	lda #0
-
	sta $2007
	dex
	bne -
	
	lda #$20
	sta $2006
	lda #$1D
	sta $2006
	
	ldx #26
	lda #0
-
	sta $2007
	dex
	bne -
	
	lda #$20
	sta $2006
	lda #$1E
	sta $2006
	
	ldx #26
	lda #0
-
	sta $2007
	dex
	bne -
	
	lda #$20
	sta $2006
	lda #$1F
	sta $2006
	
	ldx #26
	lda #0
-
	sta $2007
	dex
	bne -
	
	lda #$88
	sta $2000
	
	lda Game.NMI.ChooseMode.PayString.TableEntry
	cmp #9
	bcs +
	inc Game.NMI.ChooseMode.PayString.TableEntry
	jmp ++
+
	
	lda #0
	sta Game.NMI.ChooseMode.PayString.TableEntry
	sta Game.NMI.ChooseMode.PayString.PayIndex
	sta Game.NMI.SpinMode.ClearColumnCounter
	lda Game.Main.ChooseMode.NumberPicked
	sta Game.NMI.ChooseMode.PayString.NumberPicked
	lda #0
	sta Game.Main.SpinMode.HighlightedWin
	sta Game.Main.SpinMode.PickedSoFar
	
	lda #<Game.Main.Spin2Mode
	sta Game.MainL
	lda #>Game.Main.Spin2Mode
	sta Game.MainH
	ldx Game.Main.SpeedMode.Speed
	lda Game.Main.SpinMode.FrameSpeed.w,x
	sta Game.NMI.SpinMode.FrameCounter

	lda #0
	sta Game.NMI.SpinMode.RandomIndex
++

	jsr Game.NMI.CreditsMode.DisplayCredits
	lda #$00
	sta $2005
	sta $2005
	rts
	
Game.NMI.SpinMode.APUUpdates:

	rts

Game.NMI.SpinMode.MoveBalls:
	ldx #0
	stx System.Main.ZTempVar1
	stx System.Main.ZTempVar2
	stx System.Main.ZTempVar3
-
	lda Game.NMI.Balls.YH.w,x				;If the YH value is 1, the ball does not need to be a sprite.
	cmp #1
	beq ++
	clc
	lda Game.NMI.Balls.YL.w,x
	adc #4
	sta Game.NMI.Balls.YL.w,x
	lda Game.NMI.Balls.YH.w,x
	adc #0
	sta Game.NMI.Balls.YH.w,x
	bne ++
	ldy System.Main.ZTempVar2
	lda Game.NMI.Balls.YL.w,x
	cmp Game.NMI.SpinMode.BallSpriteStops.w,y
	bne +
	sty Game.NMI.Balls.DrawBallNumber.w
	lda #1
	sta Game.NMI.Balls.YH.w,x
	jsr Game.NMI.MakeBGOfBall
	jmp ++
+
	jsr Game.NMI.MakeSpriteOfBall
++
	clc
	lda System.Main.ZTempVar1
	adc #5
	sta System.Main.ZTempVar1
	tax
	inc System.Main.ZTempVar2
	lda System.Main.ZTempVar2
	cmp #20
	bne -

	ldy System.Main.ZTempVar3
	cpy #0
	beq ++
	lda #$FF
-
	sta $300.w,y
	iny
	iny
	iny
	iny
	bne -
++
	rts

Game.NMI.MakeSpriteOfBall:
	ldy System.Main.ZTempVar3			;Keeps track of place in sprite page.
	lda Game.NMI.Balls.YL.w,x
	sta $300.w,y
	sta $304.w,y
	clc
	adc #8
	sta $308.w,y
	sta $30C.w,y
	lda Game.NMI.Balls.X.w,x
	sta $303.w,y
	sta $30B.w,y
	clc
	adc #8
	sta $307.w,y
	sta $30F.w,y
	
	lda Game.NMI.Balls.Value.w,x
	and #$0F
	ora #$40
	sta $305.w,y
	ora #$10
	sta $30D.w,y
	lda Game.NMI.Balls.Value.w,x
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	ora #$20
	sta $301.w,y
	ora #$10
	sta $309.w,y
	
	lda Game.NMI.Balls.Color.w,x
	sta $302.w,y
	sta $306.w,y
	sta $30A.w,y
	sta $30E.w,y
	
	clc
	lda System.Main.ZTempVar3
	adc #16
	sta System.Main.ZTempVar3
	rts
	
Game.NMI.MakeBGOfBall:
	lda Game.NMI.Balls.Value.w,x
	and #$0F
	ora #$C0
	sta Game.NMI.Balls.DrawBallTile1
	ora #$10
	sta Game.NMI.Balls.DrawBallTile3
	lda Game.NMI.Balls.Value.w,x
	and #$F0
	lsr a
	lsr a
	lsr a
	lsr a
	ora #$A0
	sta Game.NMI.Balls.DrawBallTile0
	ora #$10
	sta Game.NMI.Balls.DrawBallTile2
	
	lda Game.NMI.Balls.Color.w,x
	beq +
	ldx Game.NMI.Balls.DrawBallNumber.w
	lda #$02
	sta System.Main.TempAdd0H
	lda Game.NMI.SpinMode.BallMasks.Location.w,x
	sta System.Main.TempAdd0L
	
	ldy #0
	lda (System.Main.TempAdd0L),y
	ora Game.NMI.SpinMode.BallMasksRed.w,x
	sta (System.Main.TempAdd0L),y
+
	rts
	
Game.NMI.Spin3Mode:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.Spin3Mode.PPUUpdates
	jsr Game.NMI.Spin3Mode.APUUpdates
	inc Game.VBLCount

	pla
	tay
	pla
	tax
	pla
	rti

Game.NMI.Spin2Mode:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.Spin2Mode.PPUUpdates
	jsr Game.NMI.Spin2Mode.APUUpdates

	inc Game.VBLCount

	dec Game.NMI.SpinMode.FrameCounter
	
	jsr Game.NMI.SpinMode.MoveBalls

	pla
	tay
	pla
	tax
	pla
	rti

Game.NMI.Spin2Mode.PPUUpdates:
	lda #$23
	sta $2006
	lda #$C0
	sta $2006

	ldx #0
	ldy #$40
-
	lda Game.NMI.SpinMode.AttributeTable,x
	sta $2007
	inx
	dey
	bne -
	
	ldx Game.NMI.Balls.DrawBallNumber
	cpx #21
	beq +
	
	cpx #19
	bne ++
	lda #21
	sta Game.NMI.Balls.DrawBallNumber
	lda #$FF
	sta $300
	sta $304
	sta $308
	sta $30C
++
	lda Game.NMI.SpinMode.BallTileLocationsH.w,x
	sta $2006
	lda Game.NMI.SpinMode.BallTileLocationsL.w,x
	sta $2006
	
	lda Game.NMI.Balls.DrawBallTile0
	sta $2007
	lda Game.NMI.Balls.DrawBallTile1
	sta $2007
	
	lda Game.NMI.SpinMode.BallTileLocationsH.w,x
	sta $2006
	clc
	lda Game.NMI.SpinMode.BallTileLocationsL.w,x
	adc #$20
	sta $2006
	
	lda Game.NMI.Balls.DrawBallTile2
	sta $2007
	lda Game.NMI.Balls.DrawBallTile3
	sta $2007
+
	lda #$00
	sta $2005
	sta $2005
	
	lda #3
	sta $4014
	rts
	
Game.NMI.Spin2Mode.APUUpdates:
	lda #$08
	sta $4001
	lda Game.Main.SpinMode.Sound
	and #$80
	beq +
	lda Game.Main.SpinMode.Sound
	and #$7F
	sta Game.Main.SpinMode.Sound
	lda #5
	sta Game.Sound.HitSoundCounter
	lda #$01
	sta $4015
	lda Game.Main.SpinMode.Sound
	and #1
	eor #1
	ora #$E0
	sta $4003
+
	lda Game.Sound.HitSoundCounter
	bne +
	lda #$00
	sta $4015
	rts
+
	lda Game.Main.SpinMode.Sound
	and #$7F
	bne +
	lda #$67
	sta $4002
	lda #$48
	sta $4000
	jmp ++
+
	lda #$B3
	sta $4002
	lda #$48
	sta $4000
++
	dec Game.Sound.HitSoundCounter
	rts


Game.Main.SpinMode.AddWin:
	lda Game.Main.ChooseMode.NumberPicked
	sta System.Main.ZTempVar1
	ldy #0
	sty System.Main.Math.Answer0
	sty System.Main.Math.Answer1
	sty System.Main.Math.Answer2
	sty System.Main.ZTempVar7
	ldx #0
	stx Game.Main.SpinMode.NumbersMatched
-
	lda Game.Main.ChooseMode.Chosen.w,x
	cmp $200.w,y
	bne +
	inc Game.Main.SpinMode.NumbersMatched
	stx System.Main.ZTempVar6
	ldx System.Main.ZTempVar7
	sta Game.Main.SpinMode.Matching.w,x
	inc System.Main.ZTempVar7
	ldx System.Main.ZTempVar6
+
	inx
	dec System.Main.ZTempVar1
	bne -
	ldx #0
	lda Game.Main.ChooseMode.NumberPicked
	sta System.Main.ZTempVar1
	iny
	cpy #20
	bne -

	ldx Game.Main.ChooseMode.NumberPicked
	lda Game.Main.SpinMode.PayTable.PointersL.w,x
	sta System.Main.TempAdd0L
	lda Game.Main.SpinMode.PayTable.PointersH.w,x
	sta System.Main.TempAdd0H

	lda Game.Main.SpinMode.NumbersMatched
	asl a
	tay
	lda (System.Main.TempAdd0L),y
	sta System.Main.Math.B0
	iny
	lda (System.Main.TempAdd0L),y
	sta System.Main.Math.B1

	lda Game.Main.BetMode.Bet
	sta System.Main.Math.A0

	ldx #6
	jsr System.Main.Multiply.6.16

	lda Game.Main.CreditsMode.Credits0
	sta Game.Main.SpinMode.MockCredits0
	lda Game.Main.CreditsMode.Credits1
	sta Game.Main.SpinMode.MockCredits1
	lda Game.Main.CreditsMode.Credits2
	sta Game.Main.SpinMode.MockCredits2

	lda System.Main.Math.Answer0
	sta Game.Main.SpinMode.Win0
	lda System.Main.Math.Answer1
	sta Game.Main.SpinMode.Win1
	lda System.Main.Math.Answer2
	sta Game.Main.SpinMode.Win2

	clc
	lda Game.Main.CreditsMode.Credits0
	adc Game.Main.SpinMode.Win0
	sta Game.Main.CreditsMode.Credits0
	lda Game.Main.CreditsMode.Credits1
	adc Game.Main.SpinMode.Win1
	sta Game.Main.CreditsMode.Credits1
	lda Game.Main.CreditsMode.Credits2
	adc Game.Main.SpinMode.Win2
	sta Game.Main.CreditsMode.Credits2
	rts


Game.Main.Spin3Mode.CountWin:
	lda Game.Main.SpinMode.MockCredits0
	sta System.Main.Convert.Hex0
	lda Game.Main.SpinMode.MockCredits1
	sta System.Main.Convert.Hex1
	lda Game.Main.SpinMode.MockCredits2
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

	lda Game.VBLCount
	and #1
	beq +
	lda Game.Main.CreditsMode.Credits0
	cmp Game.Main.SpinMode.MockCredits0
	bne ++
	lda Game.Main.CreditsMode.Credits1
	cmp Game.Main.SpinMode.MockCredits1
	bne ++
	lda Game.Main.CreditsMode.Credits2
	cmp Game.Main.SpinMode.MockCredits2
	bne ++
	lda #1
	sta Game.Sound.CountingDone
	rts
+
	rts
++
	clc
	lda Game.Main.SpinMode.MockCredits0
	adc #1
	sta Game.Main.SpinMode.MockCredits0
	lda Game.Main.SpinMode.MockCredits1
	adc #0
	sta Game.Main.SpinMode.MockCredits1
	lda Game.Main.SpinMode.MockCredits2
	adc #0
	sta Game.Main.SpinMode.MockCredits2

	lda #0
	sta Game.Sound.CountingDone

	rts

Game.NMI.Spin3Mode.APUUpdates:
	lda Game.Sound.CountingDone
	beq +
	lda #$00
	sta $4015
	rts
+
	lda #$01
	sta $4015
	lda #$BC
	sta $4000
	
	lda Game.VBLCount
	and #3
	beq +
	rts
+	
	ldx Game.Sound.CountTableIndex
	lda Game.Sound.$4003
	and #$0F
	cmp Sound.CountWinHighs.w,x
	beq +

	lda Sound.CountWinHighs.w,x
	sta Game.Sound.$4003
	sta $4003
+
	lda Sound.CountWinLows.w,x
	sta $4002
	
	clc
	lda Game.Sound.CountTableIndex
	adc #1
	cmp #25
	bne +
	lda #0
+
	sta Game.Sound.CountTableIndex
	rts

Sound.CountWinLows:	

.db $56		;C	F
.db $26		;Db	10
.db $F9		;D	11
.db $CE		;Eb	12
.db $A6		;E	13
.db $7F		;F	14
.db $5C		;Gb	15
.db $3A		;G	16
.db $1A		;Ab	17
	
.db $FB		;A	18
.db $DF		;Bb	19
.db $C4		;B	1A
.db $AB		;C	1B

.db $93		;Db	1C
.db $7C		;D	1D
.db $67		;Eb	1E
.db $52		;E	1F
.db $3F		;F	20
.db $2D		;Gb	21
.db $1C		;G	22
.db $0C		;Ab	23
	
.db $FD		;A	24
.db $EF		;Bb	25
.db $E2		;B	26
.db $D2		;C	27

Sound.CountWinHighs:

.db $03		;C	F
.db $03		;Db	10
.db $02		;D	11
.db $02		;Eb	12
.db $02		;E	13
.db $02		;F	14
.db $02		;Gb	15
.db $02		;G	16
.db $02		;Ab	17
	
.db $01		;A	18
.db $01		;Bb	19
.db $01		;B	1A
.db $01		;C	1B

.db $01		;Db	1C
.db $01		;D	1D
.db $01		;Eb	1E
.db $01		;E	1F
.db $01		;F	20
.db $01		;Gb	21
.db $01		;G	22
.db $01		;Ab	23
	
.db $00		;A	24
.db $00		;Bb	25
.db $00		;B	26
.db $00		;C	27

Game.NMI.Spin3Mode.PPUUpdates:
	jsr Game.NMI.CreditsMode.DisplayCredits

	lda #$00
	sta $2005
	sta $2005
	rts