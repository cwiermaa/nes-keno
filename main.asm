.include "memory.asm"
.incdir "code/game"
.include "game_module.asm"
.incdir "code/system"
.include "system_module.asm"
.incdir "code/game"
.include "graphics_module.asm"
.incdir "code/sound"
.include "sound_module.asm"
.incdir ""


;***************************************************************
;***************************************************************
;***************************************************************
.bank 1 SLOT 1
.section "Fixed" FORCE	

RESET:
	cld
	sei
	ldx #$FF
	txs

	Graphics.Initialize

	ldx #0
	txa
-
	sta $0,x
	sta $100,x
	sta $200,x
	sta $300,x
	sta $400,x
	sta $500,x
	sta $600,x
	sta $700,x
	inx
	bne -

	Game.Initialize.Values

;******* Software Initialization ********
	lda #<Game.Main.BetMode				;Start off in Bet Mode
	sta Game.MainL
	lda #>Game.Main.BetMode
	sta Game.MainH

	lda #<Game.NMI.BetMode
	sta Game.NMIL
	lda #>Game.NMI.BetMode
	sta Game.NMIH
;***************************************
	lda #$88
	sta $2000
	lda #$1E
	sta $2001

Loop:
	jmp (Game.MainL)

LoopReturn:
	lda Game.VBLCount
-
	cmp Game.VBLCount
	beq -
	jmp Loop

IRQ:
	rti
	
NMI:
	jmp (Game.NMIL)


.incdir "code/game"
.include "choose_mode.asm"
.include "spin_mode.asm"
.include "bet_mode.asm"
.include "speed_mode.asm"
.include "credit_mode.asm"

.incdir "code/sound"
.include "sound.asm"
.incdir "code/system"
.include "system_code.asm"
.incdir ""

;88888888888888 Palette Data 88888888888888888888

.DEFINE Keno.Palette.Length 32

Keno.Palette:
.incdir "data/graphics"
.incbin "keno.pal"
.incdir ""

;8888888888888888888888888888888888888888888888888

.ends

;***************************************************************
;***************************************************************
;***************************************************************

.bank 1 SLOT 1
.orga $FFFA
.section "vectors" FORCE
.dw NMI
.dw RESET
.dw IRQ
.ends

.bank 2 SLOT 2
.section "graphics" FREE
.incdir "data/graphics"
.incbin "Keno.CHR"
.ends

.bank 0 SLOT 0
.section "kenoscreen" FREE
Keno.Screen.Map:
.incdir "data/graphics"
.incbin "Keno.nam"
.ends
.incdir ""