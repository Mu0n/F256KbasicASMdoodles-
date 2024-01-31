			.cpu		"w65c02"

MMU_IO_CTRL = $0001 ; MMU I/O Control Register
VKY_MSTR_CTRL_0 = $D000 ; Vicky Master Control Register 0
VKY_GR_CLUT_0 = $D000
VKY_MSTR_CTRL_1 = $D001 ; Vicky Master Control Register 1
VKY_BRDR_CTRL = $D004 ; Vicky Border Control Register
VKY_BKG_COL_B = $D00D ; Vicky Graphics Background Color Blue
VKY_BKG_COL_G = $D00E ; Vicky Graphics Background Color Green
VKY_BKG_COL_R = $D00F ; Vicky Graphics Background Color Red

VKY_SP0_CTRL = $D900 ; Sprite #0’s control register
VKY_SP0_AD_L = $D901 ; Sprite #0’s pixel data address register
VKY_SP0_AD_M = $D902
VKY_SP0_AD_H = $D903
VKY_SP0_POS_X_L = $D904 ; Sprite #0’s X position register
VKY_SP0_POS_X_H = $D905
VKY_SP0_POS_Y_L = $D906 ; Sprite #0’s Y position register
VKY_SP0_POS_Y_H = $D907

ptr_dst = $50
ptr_src = $52

			.virtual $0000 ; zero page address references
mmu_ctrl	.byte 	?
io_ctrl		.byte 	?
reserved	.fill	6
mmu			.fill	8
			.endv

*			= $2000  ; set for slot 1, aligned at every $2000 multiples
			
start:		
			stz 	MMU_IO_CTRL ; go to io page 0
			lda		#$24  ; set graphics and sprite engines enabled
			sta		VKY_MSTR_CTRL_0
			stz		VKY_MSTR_CTRL_1 ; set 320x240 @ 60 Hz
			
			stz		VKY_BRDR_CTRL	; no border
			
			lda #$96 ; Background: lavender
			sta VKY_BKG_COL_R
			lda #$7B
			sta VKY_BKG_COL_G
			lda #$B6
			sta VKY_BKG_COL_B
;
; Load the sprite LUT into memory
;
			lda #$01 ; Switch to I/O Page #1
			sta MMU_IO_CTRL
			
			lda #<balls_clut_start ; Set the source pointer to the palette
			sta ptr_src
			lda #>balls_clut_start
			sta ptr_src+1
			
			lda #<VKY_GR_CLUT_0 ; Set the destination to Graphics CLUT
			sta ptr_dst
			lda #>VKY_GR_CLUT_0
			sta ptr_dst+1
			
			ldx #0 ; X is the number of colors copied
color_loop: 
			ldy #0 ; Y points to the color component
comp_loop: 
			lda (ptr_src),y ; Read a byte from the code
			sta (ptr_dst),y ; And write it to the CLUT
			iny ; Move to the next byte
			cpy #4
			bne comp_loop ; Continue until 4 bytes copied
			
			inx ; Move to the next color
			cpx #16
			beq done_lut ; Until we have copied all 16
			
			clc ; Move ptr_src to the next source color
			lda ptr_src
			adc #4
			sta ptr_src
			lda ptr_src+1
			adc #0
			sta ptr_src+1
			clc ; Move ptr_dst to the next destination

			lda ptr_dst
			adc #4
			sta ptr_dst
			lda ptr_dst+1
			adc #0
			sta ptr_dst+1
			bra color_loop ; And start copying that new color
			

done_lut:	
			stz MMU_IO_CTRL

;
; Set up sprite #0
;

init_sp0: 	
			lda #<balls_img_start ; Address = balls_img_start
			sta VKY_SP0_AD_L
			lda #>balls_img_start
			sta VKY_SP0_AD_M
			stz VKY_SP0_AD_H
			lda #100
			sta VKY_SP0_POS_X_L ; (x, y) = (100, 80)... should be
			stz VKY_SP0_POS_X_H ; upper-left corner of the screen
			lda #80
			sta VKY_SP0_POS_Y_L
			stz VKY_SP0_POS_Y_H
			lda #$41 ; Size=16x16, Layer=0, LUT=0, Enabled
			sta VKY_SP0_CTRL


_deathloop:	
			bra 	_deathloop	; just reset the machine or power cycle at this point, no going back to basic or dos

balls_img_start:
.byte $0, $0, $0, $0, $0, $0, $3, $2, $2, $1, $0, $0, $0, $0, $0, $0
.byte $0, $0, $0, $0, $5, $5, $4, $3, $3, $3, $3, $2, $0, $0, $0, $0
.byte $0, $0, $0, $7, $7, $7, $6, $5, $4, $4, $3, $3, $1, $0, $0, $0
.byte $0, $0, $7, $9, $A, $B, $A, $8, $6, $5, $4, $3, $2, $1, $0, $0
.byte $0, $5, $7, $A, $D, $E, $D, $A, $7, $5, $5, $4, $3, $1, $1, $0
.byte $0, $5, $7, $B, $E, $E, $E, $C, $7, $5, $5, $4, $3, $1, $1, $0
.byte $3, $4, $6, $A, $D, $E, $D, $A, $7, $5, $5, $4, $3, $2, $1, $1
.byte $2, $3, $5, $8, $A, $C, $A, $8, $6, $5, $5, $4, $3, $2, $1, $1
.byte $2, $3, $4, $6, $7, $7, $7, $6, $5, $5, $5, $4, $3, $1, $1, $1
.byte $1, $3, $4, $5, $5, $5, $5, $5, $5, $5, $5, $3, $3, $1, $1, $1		
.byte $0, $3, $3, $4, $5, $5, $5, $5, $5, $5, $4, $3, $2, $1, $1, $0
.byte $0, $2, $3, $3, $4, $4, $4, $4, $4, $3, $3, $2, $1, $1, $1, $0
.byte $0, $0, $1, $2, $3, $3, $3, $3, $3, $3, $2, $1, $1, $1, $0, $0
.byte $0, $0, $0, $1, $1, $1, $2, $2, $1, $1, $1, $1, $1, $0, $0, $0
.byte $0, $0, $0, $0, $1, $1, $1, $1, $1, $1, $1, $1, $0, $0, $0, $0
.byte $0, $0, $0, $0, $0, $0, $1, $1, $1, $1, $0, $0, $0, $0, $0, $0

balls_clut_start:
.byte $00, $00, $00, $00
.byte $88, $00, $00, $00
.byte $7C, $18, $00, $00
.byte $9C, $20, $1C, $00
.byte $90, $38, $1C, $00
.byte $B0, $40, $38, $00
.byte $A8, $54, $38, $00
.byte $C0, $5C, $50, $00
.byte $BC, $70, $50, $00
.byte $D0, $74, $68, $00
.byte $CC, $88, $68, $00
.byte $E0, $8C, $7C, $00
.byte $DC, $9C, $7C, $00
.byte $EC, $A4, $90, $00
.byte $EC, $B4, $90, $00