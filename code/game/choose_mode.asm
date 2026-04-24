Game.Main.ChooseMode:
	lda #<Game.NMI.ChooseMode
	sta Game.NMIL
	lda #>Game.NMI.ChooseMode
	sta Game.NMIH

	jsr Game.Main.ChooseMode.HandleInput
	jsr Game.Main.ChooseMode.CreatePayInformation

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

	lda #$ff
	sta $300
	sta $303
	jmp LoopReturn



;**********************************************************

Game.Main.ChooseMode.HandleInput:
	System.Main.Read.Controller()

	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.NMI.SpinMode.AttributeTable,y
	ora Game.Main.ChooseMode.Attributes.RedMasks.w,x
	sta Game.NMI.SpinMode.AttributeTable,y

;****************
	lda System.Hardware.ControlTrigger
	and #$80
	beq +
	lda Game.Main.ChooseMode.NumberPicked
	cmp #10
	beq ++
	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.NMI.SpinMode.AttributeTable,y
	ora Game.Main.ChooseMode.Attributes.Masks.w,x
	sta Game.NMI.SpinMode.AttributeTable,y
	jsr Game.Main.ChooseMode.PushNumber
++
	rts
+
	lda System.Hardware.ControlTrigger
	and #$40
	beq +

	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.Main.ChooseMode.Attributes.Masks.w,x
	eor #$FF
	sta System.Main.ZTempVar1
	lda Game.NMI.SpinMode.AttributeTable,y
	and System.Main.ZTempVar1
	sta Game.NMI.SpinMode.AttributeTable,y
	jsr Game.Main.ChooseMode.PullNumber
+

;****************
++++
	lda System.Hardware.ControlTrigger
	and #$01
	beq +

	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.Main.ChooseMode.Attributes.RedMasks.w,x
	eor #$FF
	sta System.Main.ZTempVar1
	lda Game.NMI.SpinMode.AttributeTable,y
	and System.Main.ZTempVar1
	sta Game.NMI.SpinMode.AttributeTable,y

	lda Game.Main.ChooseMode.CurrentNumber
	cmp #79
	beq +
	inc Game.Main.ChooseMode.CurrentNumber
+

	lda System.Hardware.ControlTrigger
	and #$02
	beq +

	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.Main.ChooseMode.Attributes.RedMasks.w,x
	eor #$FF
	sta System.Main.ZTempVar1
	lda Game.NMI.SpinMode.AttributeTable,y
	and System.Main.ZTempVar1
	sta Game.NMI.SpinMode.AttributeTable,y
	lda Game.Main.ChooseMode.CurrentNumber
	beq +
	dec Game.Main.ChooseMode.CurrentNumber
+

	lda System.Hardware.ControlTrigger
	and #$04
	beq +
	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.Main.ChooseMode.Attributes.RedMasks.w,x
	eor #$FF
	sta System.Main.ZTempVar1
	lda Game.NMI.SpinMode.AttributeTable,y
	and System.Main.ZTempVar1
	sta Game.NMI.SpinMode.AttributeTable,y
	lda Game.Main.ChooseMode.CurrentNumber
	cmp #70
	bcs +
	clc
	lda Game.Main.ChooseMode.CurrentNumber
	adc #10
	sta Game.Main.ChooseMode.CurrentNumber
+

	lda System.Hardware.ControlTrigger
	and #$08
	beq +
	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.Main.ChooseMode.Attributes.RedMasks.w,x
	eor #$FF
	sta System.Main.ZTempVar1
	lda Game.NMI.SpinMode.AttributeTable,y
	and System.Main.ZTempVar1
	sta Game.NMI.SpinMode.AttributeTable,y
	lda Game.Main.ChooseMode.CurrentNumber
	cmp #10
	bcc +
	sec
	lda Game.Main.ChooseMode.CurrentNumber
	sbc #10
	sta Game.Main.ChooseMode.CurrentNumber

;****************
+
	lda System.Hardware.ControlTrigger
	and #$20
	beq +

	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.Main.ChooseMode.Attributes.RedMasks.w,x
	eor #$FF
	sta System.Main.ZTempVar1
	lda Game.NMI.SpinMode.AttributeTable,y
	and System.Main.ZTempVar1
	sta Game.NMI.SpinMode.AttributeTable,y

	lda #<Game.Main.BetMode
	sta Game.MainL
	lda #>Game.Main.BetMode
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

	ldx Game.Main.ChooseMode.CurrentNumber
	ldy Game.Main.ChooseMode.Attributes.Index.w,x
	lda Game.Main.ChooseMode.Attributes.RedMasks.w,x
	eor #$FF
	sta System.Main.ZTempVar1
	lda Game.NMI.SpinMode.AttributeTable,y
	and System.Main.ZTempVar1
	sta Game.NMI.SpinMode.AttributeTable,y
+
	rts

;**********************
Game.Main.ChooseMode.PushNumber:
	lda Game.Main.ChooseMode.NumberPicked
	bne +						;No checks are necessary if none have been picked yet.
							;Just throw the number in the pile.
	inc Game.Main.ChooseMode.NumberPicked
	lda Game.Main.ChooseMode.CurrentNumber
	sta Game.Main.ChooseMode.Chosen
	rts
	
+
	tay
	ldx #0
-
	lda Game.Main.ChooseMode.Chosen,x		;Check to make sure number has not been taken
	cmp Game.Main.ChooseMode.CurrentNumber
	beq +
	inx
	dey
	bne -
	lda Game.Main.ChooseMode.CurrentNumber		;Insert number in array
	sta Game.Main.ChooseMode.Chosen,x
	inc Game.Main.ChooseMode.NumberPicked
+							;If so, return
	rts
Game.Main.ChooseMode.PullNumber:
	lda Game.Main.ChooseMode.NumberPicked		;If none are picked, do nothing, because nothing's being erased.
	bne +
	rts
+
	sta System.Main.ZTempVar1
	ldx #0
	ldy #0
-
	lda Game.Main.ChooseMode.Chosen,x		;We compare each element of the chosen array to the current number
	cmp Game.Main.ChooseMode.CurrentNumber
	beq +						;If they are equal, we've found the number to delete
	sta Game.Main.ChooseMode.ChosenTemp,y		;If the element is not equal, keep it, copying it to a temp array
	iny						;Move each element up
	inx
	dec System.Main.ZTempVar1
	bne -
	jmp +++
+
	dec Game.Main.ChooseMode.NumberPicked
	inx
	dec System.Main.ZTempVar1
	bne -
+++
	ldy Game.Main.ChooseMode.NumberPicked		;This contains the modified value of the number picked, after one
	beq +						;is removed. If none are picked there is no need to copy the temp
							;array.
	ldx #0
-							;Copy temp array over
	lda Game.Main.ChooseMode.ChosenTemp,x
	sta Game.Main.ChooseMode.Chosen,x
	inx
	dey
	bne -
+
	rts						;Number removal complete.

;********************************************************
;This routine calculates the current bet times the current entry in the pay table.
;By current, we mean the one we see if we have to draw.
;The logic might be confusing, but here's what we have to communicate.
;If the current valid entry pays nothing, move to the next valid entry that pays.
;If the entry passes the point of invalidity, draw blanks.

Game.Main.ChooseMode.CreatePayInformation:
	ldx Game.NMI.ChooseMode.PayString.NumberPicked
	lda Game.Main.SpinMode.PayTable.PointersL.w,x
	sta System.Main.TempAdd1L
	lda Game.Main.SpinMode.PayTable.PointersH.w,x
	sta System.Main.TempAdd1H

	lda Game.NMI.ChooseMode.PayString.PayIndex
	lsr a
	sta System.Main.ZTempVar1
	lda Game.NMI.ChooseMode.PayString.NumberPicked
	cmp System.Main.ZTempVar1
	bcs +
	jsr Game.Main.ChooseMode.StoreBlank
	rts
+
	ldy Game.NMI.ChooseMode.PayString.PayIndex
-
	lda (System.Main.TempAdd1L),y
	bne +
	iny
	lda (System.Main.TempAdd1L),y
	bne ++
	iny
	sty System.Main.ZTempVar1
	lsr System.Main.ZTempVar1
	lda Game.NMI.ChooseMode.PayString.NumberPicked
	cmp System.Main.ZTempVar1
	bcs -
	jsr Game.Main.ChooseMode.StoreBlank
	rts
+
	iny
++
	iny
	sty Game.NMI.ChooseMode.PayString.PayIndex

	dey
	dey
	lda (System.Main.TempAdd1L),y
	sta System.Main.Math.B0
	iny
	lda (System.Main.TempAdd1L),y
	sta System.Main.Math.B1

	lda Game.Main.BetMode.Bet
	sta System.Main.Math.A0

	ldx #6
	jsr System.Main.Multiply.6.16
	lda System.Main.Math.Answer0
	sta System.Main.Convert.Hex0
	lda System.Main.Math.Answer1
	sta System.Main.Convert.Hex1
	lda System.Main.Math.Answer2
	sta System.Main.Convert.Hex2
	jsr System.Main.HexToDecimal.24

	lda System.Main.Convert.DecHundredThousands
	beq +
	ora #$30
	sta Game.NMI.ChooseMode.PayString+0
	lda System.Main.Convert.DecTenThousands
	ora #$30
	sta Game.NMI.ChooseMode.PayString+1
	lda System.Main.Convert.DecThousands
	ora #$30
	sta Game.NMI.ChooseMode.PayString+2
	lda System.Main.Convert.DecHundreds
	ora #$30
	sta Game.NMI.ChooseMode.PayString+3
	lda System.Main.Convert.DecTens
	ora #$30
	sta Game.NMI.ChooseMode.PayString+4
	lda System.Main.Convert.DecOnes
	ora #$30
	sta Game.NMI.ChooseMode.PayString+5
	jmp +++
+
	sta Game.NMI.ChooseMode.PayString+0
	lda System.Main.Convert.DecTenThousands
	beq +
	ora #$30
	sta Game.NMI.ChooseMode.PayString+1
	lda System.Main.Convert.DecThousands
	ora #$30
	sta Game.NMI.ChooseMode.PayString+2
	lda System.Main.Convert.DecHundreds
	ora #$30
	sta Game.NMI.ChooseMode.PayString+3
	lda System.Main.Convert.DecTens
	ora #$30
	sta Game.NMI.ChooseMode.PayString+4
	lda System.Main.Convert.DecOnes
	ora #$30
	sta Game.NMI.ChooseMode.PayString+5
	jmp +++
+
	sta Game.NMI.ChooseMode.PayString+1
	lda System.Main.Convert.DecThousands
	beq +
	ora #$30
	sta Game.NMI.ChooseMode.PayString+2
	lda System.Main.Convert.DecHundreds
	ora #$30
	sta Game.NMI.ChooseMode.PayString+3
	lda System.Main.Convert.DecTens
	ora #$30
	sta Game.NMI.ChooseMode.PayString+4
	lda System.Main.Convert.DecOnes
	ora #$30
	sta Game.NMI.ChooseMode.PayString+5
	jmp +++
+
	sta Game.NMI.ChooseMode.PayString+2
	lda System.Main.Convert.DecHundreds
	beq +
	ora #$30
	sta Game.NMI.ChooseMode.PayString+3
	lda System.Main.Convert.DecTens
	ora #$30
	sta Game.NMI.ChooseMode.PayString+4
	lda System.Main.Convert.DecOnes
	ora #$30
	sta Game.NMI.ChooseMode.PayString+5
	jmp +++
+
	sta Game.NMI.ChooseMode.PayString+3
	lda System.Main.Convert.DecTens
	beq +
	ora #$30
	sta Game.NMI.ChooseMode.PayString+4
	lda System.Main.Convert.DecOnes
	ora #$30
	sta Game.NMI.ChooseMode.PayString+5
	jmp +++
+
	sta Game.NMI.ChooseMode.PayString+4
	lda System.Main.Convert.DecOnes
	ora #$30
	sta Game.NMI.ChooseMode.PayString+5

+++
	lda Game.NMI.ChooseMode.PayString.PayIndex
	lsr a
	sec
	sbc #1
	sta System.Main.Convert.Hex0
	jsr System.Main.HexToDecimal.8

	lda System.Main.Convert.DecTens
	beq +
	ora #$30
	sta Game.NMI.ChooseMode.PayString.PayNumber1
	lda System.Main.Convert.DecOnes
	ora #$30
	sta Game.NMI.ChooseMode.PayString.PayNumber2
	rts
+
	lda System.Main.Convert.DecOnes
	ora #$30
	sta Game.NMI.ChooseMode.PayString.PayNumber1
	lda #$00
	sta Game.NMI.ChooseMode.PayString.PayNumber2
	rts
Game.Main.ChooseMode.StoreBlank:
	lda #$00
	sta Game.NMI.ChooseMode.PayString.PayNumber1
	sta Game.NMI.ChooseMode.PayString.PayNumber2
	sta Game.NMI.ChooseMode.PayString+0
	sta Game.NMI.ChooseMode.PayString+1
	sta Game.NMI.ChooseMode.PayString+2
	sta Game.NMI.ChooseMode.PayString+3
	sta Game.NMI.ChooseMode.PayString+4
	sta Game.NMI.ChooseMode.PayString+5
	rts
;**********************
Game.Main.ChooseMode.Attributes.Index:
	.db $0A,$0A,$0B,$0B,$0C,$0C,$0D,$0D,$0E,$0E
	.db $12,$12,$13,$13,$14,$14,$15,$15,$16,$16
	.db $12,$12,$13,$13,$14,$14,$15,$15,$16,$16
	.db $1A,$1A,$1B,$1B,$1C,$1C,$1D,$1D,$1E,$1E

	.db $22,$22,$23,$23,$24,$24,$25,$25,$26,$26
	.db $22,$22,$23,$23,$24,$24,$25,$25,$26,$26
	.db $2A,$2A,$2B,$2B,$2C,$2C,$2D,$2D,$2E,$2E
	.db $2A,$2A,$2B,$2B,$2C,$2C,$2D,$2D,$2E,$2E

Game.Main.ChooseMode.Attributes.Masks:
	.db $10,$40,$10,$40,$10,$40,$10,$40,$10,$40
	.db $01,$04,$01,$04,$01,$04,$01,$04,$01,$04
	.db $10,$40,$10,$40,$10,$40,$10,$40,$10,$40
	.db $01,$04,$01,$04,$01,$04,$01,$04,$01,$04

	.db $01,$04,$01,$04,$01,$04,$01,$04,$01,$04
	.db $10,$40,$10,$40,$10,$40,$10,$40,$10,$40
	.db $01,$04,$01,$04,$01,$04,$01,$04,$01,$04
	.db $10,$40,$10,$40,$10,$40,$10,$40,$10,$40

Game.Main.ChooseMode.Attributes.RedMasks:
	.db $20,$80,$20,$80,$20,$80,$20,$80,$20,$80
	.db $02,$08,$02,$08,$02,$08,$02,$08,$02,$08
	.db $20,$80,$20,$80,$20,$80,$20,$80,$20,$80
	.db $02,$08,$02,$08,$02,$08,$02,$08,$02,$08

	.db $02,$08,$02,$08,$02,$08,$02,$08,$02,$08
	.db $20,$80,$20,$80,$20,$80,$20,$80,$20,$80
	.db $02,$08,$02,$08,$02,$08,$02,$08,$02,$08
	.db $20,$80,$20,$80,$20,$80,$20,$80,$20,$80
;**********************************************************
;**********************************************************
;**********************************************************

Game.NMI.ChooseMode:
	pha
	txa
	pha
	tya
	pha

	jsr Game.NMI.ChooseMode.PPUUpdates
	jsr Game.NMI.ChooseMode.APUUpdates

	inc Game.VBLCount

	pla
	tay
	pla
	tax
	pla
	rti


Game.NMI.ChooseMode.PPUUpdates:
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

	jsr Game.NMI.ChooseMode.DisplayPayInformation
	jsr Game.NMI.CreditsMode.DisplayCredits

	lda #3
	sta $4014
	lda #$00
	sta $2005
	sta $2005
	rts
Game.NMI.ChooseMode.APUUpdates:
	rts

Game.NMI.ChooseMode.DisplayPayInformation:
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

	lda Game.NMI.ChooseMode.PayString.TableEntry
	cmp #9
	bcs +
	inc Game.NMI.ChooseMode.PayString.TableEntry
	jmp ++
+
	lda #0
	sta Game.NMI.ChooseMode.PayString.TableEntry
	sta Game.NMI.ChooseMode.PayString.PayIndex
	lda Game.Main.ChooseMode.NumberPicked
	sta Game.NMI.ChooseMode.PayString.NumberPicked
++
	rts
;***************************************
Game.NMI.ChooseMode.PPUAddress.NumberL:
	.db $80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0
Game.NMI.ChooseMode.PPUAddress.NumberH:
	.db $20,$20,$21,$21,$21,$21,$22,$22,$22,$22
Game.NMI.ChooseMode.PPUAddress.PayStringL:
	.db $A1,$E1,$21,$61,$A1,$E1,$21,$61,$A1,$E1
Game.NMI.ChooseMode.PPUAddress.PayStringH:
	.db $20,$20,$21,$21,$21,$21,$22,$22,$22,$22