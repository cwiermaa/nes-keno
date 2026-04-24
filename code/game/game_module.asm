.DEFINE Game.NMIL $00
.DEFINE Game.NMIH $01
.DEFINE Game.MainL $02
.DEFINE Game.MainH $03
.DEFINE Game.Main.Mode0.EventL $04
.DEFINE Game.Main.Mode0.EventH $05

.DEFINE Game.VBLCount $06

.DEFINE Game.Main.BetMode.Bet $98
.DEFINE Game.Main.CreditsMode.Credits0 $99
.DEFINE Game.Main.CreditsMode.Credits1 $9A
.DEFINE Game.Main.CreditsMode.Credits2 $9B
.DEFINE Game.Main.SpeedMode.Speed $9C
.DEFINE Game.Main.ChooseMode.NumberPicked $9D
.DEFINE Game.Main.ChooseMode.CurrentNumber $9E
.DEFINE Game.Main.SpinMode.NumbersMatched $9F

.DEFINE Game.Main.BetMode.Increment $A0
.DEFINE Game.Main.CreditsMode.Increment0 $A1
.DEFINE Game.Main.CreditsMode.Increment1 $A2
.DEFINE Game.Main.CreditsMode.Increment2 $A3
.DEFINE Game.Main.CreditsMode.IncrementIndex $A4
.DEFINE Game.NMI.ChooseMode.PayString $A5		;Update one entry of the pay table every frame
							;Ends at $AB
.DEFINE Game.NMI.ChooseMode.PayString.PayNumber1 $AB	;Contains Tile ID of 10s digit of Winning number.
.DEFINE Game.NMI.ChooseMode.PayString.PayNumber2 $AC	;Contains Tile ID of 1s digit of Winning number.

.DEFINE Game.NMI.ChooseMode.PayString.TableEntry $AD	;Specifies the current "slot" for information on the visual pay
							;Table.
.DEFINE Game.NMI.ChooseMode.PayString.PayIndex $AE	;Specifies the current value in the pay table we're looking for.
.DEFINE Game.NMI.ChooseMode.PayString.NumberPicked $AF	;We have a different variable for this because we change this
							;value ONLY when a table begins to be drawn. That way, we don't
							;start drawing things for a different number picked halfway through
							;drawing a pay table.

.DEFINE Game.NMI.BetMode.Bet1 $B0
.DEFINE Game.NMI.BetMode.Bet2 $B1

.DEFINE Game.NMI.CreditMode.Credit1 $B2
.DEFINE Game.NMI.CreditMode.Credit2 $B3
.DEFINE Game.NMI.CreditMode.Credit3 $B4
.DEFINE Game.NMI.CreditMode.Credit4 $B5
.DEFINE Game.NMI.CreditMode.Credit5 $B6
.DEFINE Game.NMI.CreditMode.Credit6 $B7
.DEFINE Game.NMI.CreditMode.Credit7 $B8
.DEFINE Game.NMI.CreditMode.Credit8 $B9

.DEFINE Game.NMI.SpinMode.FrameCounter $BA		;Defines the amount of frames we have left to wait for.
.DEFINE Game.NMI.SpinMode.RandomIndex $BB

.DEFINE Game.Main.SpinMode.MockCredits0 $BC		;For displaying win
.DEFINE Game.Main.SpinMode.MockCredits1 $BD
.DEFINE Game.Main.SpinMode.MockCredits2 $BE

.DEFINE Game.Main.SpinMode.Win0 $BF
.DEFINE Game.Main.SpinMode.Win1 $C0
.DEFINE Game.Main.SpinMode.Win2 $C1

.DEFINE Game.Main.SpinMode.HighlightedWin $C2
.DEFINE Game.Main.SpinMode.PickedSoFar $C3
.DEFINE Game.Main.SpinMode.Sound $C4			;Bit 0 - Sound No Hit, Bit 1 - Sound Hit, Bit 7 - New Sound

.DEFINE Game.Main.ChooseMode.Chosen $220		;The current numbers the player has chosen
.DEFINE Game.Main.ChooseMode.ChosenTemp $230		;Ends at $240. We use this array to modify the other one.

.DEFINE Game.Main.SpinMode.WinningNumbers $200	;Ends at $21F. The 20 winning numbers are contained in this array.

.DEFINE Game.Main.SpinMode.Matching	$240		;This array contains the matching numbers. That is, the ones chosen
												;Both by the player and the computer.
												
.DEFINE Game.NMI.SpinMode.AttributeTable $280	;Ends at $2C0

.DEFINE Game.Sound.$4000 $2C0
.DEFINE Game.Sound.$4001 $2C1
.DEFINE Game.Sound.$4002 $2C2
.DEFINE Game.Sound.$4003 $2C3
.DEFINE Game.Sound.$4015 $2C4

.DEFINE Game.Sound.HitSoundCounter $2C5
.DEFINE Game.Sound.CountTableIndex $2C6
.DEFINE Game.Sound.CountingDone $2C7

.DEFINE Game.NMI.SpinMode.ClearColumnCounter $2C8

.DEFINE Game.NMI.Balls.X $400
.DEFINE Game.NMI.Balls.YL $401
.DEFINE Game.NMI.Balls.YH $402
.DEFINE Game.NMI.Balls.Value $403
.DEFINE Game.NMI.Balls.Color $404

.DEFINE Game.NMI.Balls.DrawBallTile0 $464
.DEFINE Game.NMI.Balls.DrawBallTile1 $465
.DEFINE Game.NMI.Balls.DrawBallTile2 $466
.DEFINE Game.NMI.Balls.DrawBallTile3 $467
.DEFINE Game.NMI.Balls.DrawBallNumber $468
.DEFINE Game.NMI.Balls.DrawBallSwitch $469
;****************************

.MACRO Game.Initialize.Values
	lda #1
	sta Game.Main.BetMode.Increment
	lda #$03
	sta Game.Main.CreditsMode.Credits1
	lda #$E8
	sta Game.Main.CreditsMode.Credits0

	lda #2
	sta Game.Main.SpeedMode.Speed


	lda Game.Main.BetMode.Bet
	sta System.Main.Convert.Hex0
	jsr System.Main.HexToDecimal.8
	lda System.Main.Convert.DecTens
	sta Game.NMI.BetMode.Bet1
	lda System.Main.Convert.DecOnes
	sta Game.NMI.BetMode.Bet2
	jsr Game.NMI.BetMode.PPUUpdates


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
	jsr Game.NMI.CreditsMode.PPUUpdates

	jsr Game.NMI.SpeedMode.PPUUpdates

	ldx #$40
	ldy #0
-
	lda Keno.Screen.Map + $3C0,y
	sta Game.NMI.SpinMode.AttributeTable,y
	iny
	dex
	bne -
.ENDM