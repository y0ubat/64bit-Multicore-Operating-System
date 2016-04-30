[ORG 0x7c00]
[BITS 16]

SECTION .text

mov ax, 0xB800
mov es, ax

mov si, 0

.clearloop:
	mov byte [es:si], 0x0
	mov byte [es:si+1], 0x0A
	add si, 2

	cmp si,25*80*2
	jl .clearloop

	mov si,0

	
mov ah, 0x09
mov al, 'O'
mov [es:0000], ax
mov al,'S'
mov [es:0002], ax


jmp $

times 510 - ( $ - $$ )  db 0x00

dw 0xaa55
