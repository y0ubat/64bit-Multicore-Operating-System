[ORG 0x00]
[BITS 16]

SECTION .text

jmp 0x1000:START  ; cs 세그먼트 레지스터에 0x1000을 복사하면서, START 레이블로 이동

sector_count:	dw	0x0000 ; 현재 실행 중인 섹터 번호를 저장 
total_sector_count:	equ	1024

START:
	mov ax, cs	; cs 세그먼트 레지스터의 값을 ax 레지스터에 설정
	mov ds, ax  ; ax 레지스터값을 ds 세그먼트 레지스터에 설정
	mov ax, 0xB800 ; 비디오 메모리 어드레스인 0xB800을 세그먼트 레지스터 값으로 변환
	mov es, ax

	%assign i 0
	%rep total_sector_count
		%assign i	i + 1

		mov ax, 2		; 한문자를 나타내는 바이트 수(2)를 ax 레지스터에 설정
		mul word [ sector_count ]  ; ax레지스터와 섹터 수를 곱함
		mov si, ax 					; 곱한 결과를 si 레지스터에 설정
		mov byte [es:si + (160*2)], '0' + ( i % 10 )

		add word [ sector_count ], 1

		%if i == total_sector_count
			jmp $
		%else
			jmp ( 0x1000 + i * 0x20): 0x0000
		%endif
	
		times (512 - ( $ - $$ ) % 512 ) db 0x00 


	%endrep 