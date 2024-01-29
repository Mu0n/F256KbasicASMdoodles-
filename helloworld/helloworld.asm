			.cpu		"w65c02"

			.virtual $0000 ; zero page address references
mmu_ctrl	.byte 	?
io_ctrl		.byte 	?
reserved	.fill	6
mmu			.fill	8
			.endv

*			= $2000  ; set for slot 1, aligned at every $2000 multiples
			
start:		lda		#$2  ; set io_ctrl to 2 so we can access the screen text memory
			sta		io_ctrl
			ldy		#0	;start the text counter
_textloop:	lda		_text,y
			beq 	_ending 	;if we're finished, go to endless loop
			sta 	$C000,y ;start writing at the top left of text memory, offset by y's value
			iny 			;increment y
			bra		_textloop	;keep going through the text
			sta		io_ctrl
_ending		lda		#$0
			sta		io_ctrl	;no reason to put back the original value, but good practice to reset io_ctrl
_deathloop:	bra 	_deathloop	; just reset the machine or power cycle at this point, no going back to basic or dos
_text: 		.null 	" Welcome to this amazing first asm example program"