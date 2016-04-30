[ORG 0x00]
[BITS 16]

SECTION .text

jmp 0x07C0:START

total_sector_count: dw 1024

START:
	mov ax,0x07C0
	mov ds,ax
	mov ax,0xB800
	mov es,ax

	mov ax,0x0000
	mov ss,ax
	mov sp,0xFFFE
	mov bp,0xFFFE

	mov si,0



clear_loop:
	mov byte [es:si], 0
	mov byte [es:si+1],0x0A
	add si,2

	cmp si,80*25*2
	jl clear_loop

	
	push MESSAGE1
	push 0
	push 0
	call print_message
	add sp, 6


	push image_loading_message
	push 1
	push 0
	call print_message
	add sp, 6
	
	
reset_disk:
	mov ax,0
	mov dl,0
	int 0x13
	jc handle_disk_error

	mov si, 0x1000
	mov es, si
	mov bx, 0x0000

	mov di, word [total_sector_count]

read_data:
	cmp di, 0
	je read_end
	sub di, 0x1

	mov ah,0x2
	mov al, 0x1
	mov ch, byte [track_number]
	mov cl, byte [sector_number]
	mov dh, byte [handle_number]
	mov dl, 0x0
	int 0x13
	jc handle_disk_error

	add si, 0x0020
	mov es, si

	mov al, byte [ sector_number ]
	add al, 0x01
	mov byte [ sector_number ], al
	cmp al, 19
	jl read_data

	xor byte [ handle_number ], 0x1
	mov byte [ sector_number ], 0x1

	cmp byte [ handle_number ], 0x0
	jne read_data

	add byte [ track_number ], 0x01
	jmp read_data

read_end:
	push loading_complete_message
	push 1
	push 20
	call print_message
	add sp, 6

	jmp 0x1000:0x0000


handle_disk_error:
	push disk_error_message
	push 1
	push 20
	call print_message
	add sp, 6

	jmp $



print_message:
	push bp
	mov bp, sp

	push es
	push si
	push di
	push ax
	push cx
	push dx

	mov ax,0xB800
	mov es,ax

	mov ax, word [bp + 6] ; print_message(x,y,string) // x
	mov si, 160
	mul si
	mov di, ax

	mov ax, word [bp + 4] ; y
	mov si, 2
	mul si
	add di, ax

	mov si, word [bp + 8]

message_loop:
	mov cl, byte [ si ]

	cmp cl,0
	je message_end

	mov byte [es:di],cl
	add si, 1
	add di, 2

	jmp message_loop

message_end:
	pop dx
	pop cx
	pop ax
	pop di
	pop si
	pop es
	pop bp
	ret


MESSAGE1: db 'hello y0ubat!', 0
image_loading_message: db 'image loading.....', 0
loading_complete_message: db 'complete!!!', 0
disk_error_message: db 'disk error!!', 0

sector_number: db 0x2
handle_number: db 0x0
track_number: db 0x0


times 510 - ( $ - $$ )  db 0x00

db 0x55
db 0xAA

