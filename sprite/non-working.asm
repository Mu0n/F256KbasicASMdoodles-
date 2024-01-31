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
			cmp #16
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
			