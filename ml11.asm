.label comma_test   =         $aefd
.label frmev1       =         $ad9e
.label getadr       =         $b7f7
.label store_add    =         $fb
.label num_bytes    =         $fd

*=$033c

          jsr get_parameters  // storage address
          sty store_add
          sta store_add+1
          jsr get_parameters  // number of bytes
          sty num_bytes
          sta num_bytes+1
          jsr get_parameters  // storage byte
          tya                 // Y is the storage byte
          ldy #$00
          ldx num_bytes+1     // >0 here indicates more than 1 page to store
          beq do_partial_fill
!:
          sta (store_add),y
          iny
          bne !-
          inc store_add+1
          dec num_bytes+1
          bne !-

do_partial_fill:

          ldy num_bytes
          beq !++             // done
!:
          dey                 // fill backward as Y already contains our index
          sta (store_add),y
          bne !-
!:
          rts

get_parameters:

          jsr comma_test      // test for [,] comma
          jsr frmev1          // Evaluate Expression in Text
          jsr getadr          // Convert FAC#1 to Integer in LINNUM
          rts

/*        BUILDS TO THIS:

	033c  20 69 03	jsr $0369
	033f  84 fb   	sty $fb
	0341  85 fc   	sta $fc
	0343  20 69 03	jsr $0369
	0346  84 fd   	sty $fd
	0348  85 fe   	sta $fe
	034a  20 69 03	jsr $0369
	034d  98      	tya 
	034e  a0 00   	ldy #$00
	0350  a6 fe   	ldx $fe
	0352  f0 0b   	beq $035f
	0354  91 fb   	sta ($fb),y
	0356  c8      	iny 
	0357  d0 fb   	bne $0354
	0359  e6 fc   	inc $fc
	035b  c6 fe   	dec $fe
	035d  d0 f5   	bne $0354
	035f  a4 fd   	ldy $fd
	0361  f0 05   	beq $0368
	0363  88      	dey 
	0364  91 fb   	sta ($fb),y
	0366  d0 fb   	bne $0363
	0368  60      	rts 
	0369  20 fd ae	jsr $aefd
	036c  20 9e ad	jsr $ad9e
	036f  20 f7 b7	jsr $b7f7
	0372  60      	rts 

*/