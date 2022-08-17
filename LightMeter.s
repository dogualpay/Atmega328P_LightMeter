.equ portd, 0x0B
.equ ddrd, 0x0A
.equ ddrc, 0x07
.equ adcl, 0x78
.equ adch, 0x79
.equ adcsra, 0x7A
.equ admux, 0x7C
.equ adsc, 6

.equ eecr, 0x1F ; CONTROL REGISTER
.equ eedr, 0x20 ; DATA REGISTER
.equ eearl, 0x21 ; ADDRESS REGISTER
.equ eearh, 0x22 ; ADDRESS REGISTER -LOWER 2 BITS ARE USED-

.equ eere, 0 ; READ ENABLE BIT
.equ eewe, 1 ; WRITE ENABLE BIT
.equ eemwe, 2 ; MASTER WRITE ENABLE BIT

.equ tccr0a, 0x24
.equ tccr0b, 0x25
.equ tcnt0, 0x26
.equ tifr0, 0x15

.text
.global main

main:	
	ldi r28, 0x01 ; for eeprom higher address
	ldi r27, 0x3A ; for eeprom lower address
	out eearl, r20
	out eearh, r21
readrom:	
	sbic eecr, eewe ; XXX
	rjmp readrom
	sbi eecr, eere ; XXX
	in r22, eedr
	
	eor r16, r16 ; all analogs for input
	out ddrc, r16
	
	ldi r16, 0b00111100
	out ddrd, r16
	
	ldi r16, 0b00000000
	out tccr0a, r16
	ldi r16, 0b00000100 ; clock/256
	out tccr0b, r16
	
	ldi r23, 3
	ldi r24, 254
	rjmp analog_read
	
delay_long:
writerom:
	sbic eecr, eewe
	rjmp writerom
	
	out eedr, r22
	sbi eecr, eemwe
	sbi eecr, eewe
	ldi r16, 0b00000101 ; clock/1024
	out tccr0b, r16
	ldi r19, 0
	out tcnt0, r19
while_long:
	in r20, tifr0
	sbrs r20, 0
	rjmp while_long
	
	ldi r20, 0x00
	out tcnt0, r20
	ldi r20, 0x01
	out tifr0, r20
	inc r19
	cp r19, r24
	brlo while_long
	ldi r16, 0b00000100 ; clock/256
	out tccr0b, r16

	
analog_read:
	ldi r16, 0b10000111
	sts adcsra, r16
	ldi r16, 0b01000000
	sts admux, r16
	
	lds r16, adcsra
	ori r16, 0b01000000
	sts adcsra, r16
poll:
	lds r16, adcsra
	sbrc r16, adsc
	rjmp poll
	
	lds r17, adcl
	lds r18, adch

	lsr r17
	lsr r17
	lsl r18
	lsl r18
	lsl r18
	lsl r18
	lsl r18
	lsl r18
	or r18, r17
	cp r18, r22
	brlo decrement
	breq delay_long
	rjmp increment

increment:
	inc r22
	ldi r21, 0b00000100
	out portd, r21
	rjmp delay_short_f
	two_f:
	ldi r21, 0b00001100
	out portd, r21
	rjmp delay_short_f
	three_f:
	ldi r21, 0b00001000
	out portd, r21
	rjmp delay_short_f
	four_f:
	ldi r21, 0b00011000
	out portd, r21
	rjmp delay_short_f
	five_f:
	ldi r21, 0b00010000
	out portd, r21
	rjmp delay_short_f
	six_f:
	ldi r21, 0b00110000
	out portd, r21
	rjmp delay_short_f
	seven_f:
	ldi r21, 0b00100000
	out portd, r21
	rjmp delay_short_f
	eight_f:
	ldi r21, 0b00100100
	out portd, r21
	rjmp delay_short_f
	nine_f:
	rjmp analog_read
	
delay_short_f:
	ldi r19, 0
	out tcnt0, r19
while_f:
	in r20, tifr0
	sbrs r20, 0
	rjmp while_f
	
	ldi r20, 0x00
	out tcnt0, r20
	ldi r20, 0x01
	out tifr0, r20
	inc r19
	cp r19, r23
	brlo while_f
	cpi r21, 0b00000100
	breq two_f
	cpi r21, 0b00001100
	breq three_f
	cpi r21, 0b00001000
	breq four_f
	cpi r21, 0b00011000
	breq five_f
	cpi r21, 0b00010000
	breq six_f
	cpi r21, 0b00110000
	breq seven_f
	cpi r21, 0b00100000
	breq eight_f
	cpi r21, 0b00100100
	breq nine_f
	
decrement:
	dec r22
	ldi r21, 0b00000100
	out portd, r21
	rjmp delay_short_b
	two_b:
	ldi r21, 0b00100100
	out portd, r21
	rjmp delay_short_b
	three_b:
	ldi r21, 0b00100000
	out portd, r21
	rjmp delay_short_b
	four_b:
	ldi r21, 0b00110000
	out portd, r21
	rjmp delay_short_b
	five_b:
	ldi r21, 0b00010000
	out portd, r21
	rjmp delay_short_b
	six_b:
	ldi r21, 0b00011000
	out portd, r21
	rjmp delay_short_b
	seven_b:
	ldi r21, 0b00001000
	out portd, r21
	rjmp delay_short_b
	eight_b:
	ldi r21, 0b00001100
	out portd, r21
	rjmp delay_short_b
	nine_b:
	rjmp analog_read

delay_short_b:
	ldi r19, 0
	out tcnt0, r19
while_b:
	in r20, tifr0
	sbrs r20, 0
	rjmp while_b
	
	ldi r20, 0x00
	out tcnt0, r20
	ldi r20, 0x01
	out tifr0, r20
	inc r19
	cp r19, r23
	brlo while_b
	cpi r21, 0b00000100
	breq two_b
	cpi r21, 0b00100100
	breq three_b
	cpi r21, 0b00100000
	breq four_b
	cpi r21, 0b00110000
	breq five_b
	cpi r21, 0b00010000
	breq six_b
	cpi r21, 0b00011000
	breq seven_b
	cpi r21, 0b00001000
	breq eight_b
	cpi r21, 0b00001100
	breq nine_b
	
