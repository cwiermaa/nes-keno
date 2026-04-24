;************************************************
;This is the initialization of graphics. It loads the palette,
;Clears the name table, and resets the scroll.

.MACRO Graphics.Initialize
	lda #$00
	sta $2000
	sta $2001

	lda #$3F
	sta $2006
	lda #$00
	sta $2006

	ldx #Keno.Palette.Length
	ldy #0
-
	lda Keno.Palette,y
	sta $2007
	iny
	dex
	bne -

	Graphics.ClearNameTable
	Graphics.LoadKenoTable

	lda #$00
	sta $2005
	lda #$00
	sta $2005
.ENDM

;********************************************
;This macro clears the name table, assuming vertical mirroring.

.MACRO Graphics.ClearNameTable

	lda #$20
	sta $2006
	ldx #8
	ldy #0
	tya
	sta $2006
-
	sta $2007
	iny
	bne -
	dex
	bne -
.ENDM

;********************************************
;This macro loads the unchanging parts of the keno screen, defined in a raw .nam file

.MACRO Graphics.LoadKenoTable
	lda #<Keno.Screen.Map
	sta System.Main.TempAdd0L
	lda #>Keno.Screen.Map
	sta System.Main.TempAdd0H

	lda #$20
	sta $2006
	lda #$00
	sta $2006
	ldx #4
	ldy #0
-
	lda (System.Main.TempAdd0L),y
	sta $2007
	iny
	bne -
	inc System.Main.TempAdd0H
	dex
	bne -
.ENDM