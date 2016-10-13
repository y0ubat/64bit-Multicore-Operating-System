[ORG 0x00] 
[BITS 16]

SECTION .text


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;코드 영역
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START:
	mov ax,0x1000 				; 보호모드 엔트리 포인트의 시작어드레스 0x1000를 세그먼트 레지스터값으로 변환
	mov ds,ax					; DS 세그먼트 레지스터에 설정
	mov es,ax					; ES 세그먼트 레지스터에 설정

	cli 						; 인터럽트가 발생하지 못하게 설정
	lgdt [ GDTR ] 				; GDTR 자료구조를 프로세스에 설정, GDT테이블을 로드 

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; 보호 모드 진입
	; Disable Paging, Disable Cache, Internal FPU, Disable Align Chheck, Enable Protected_Mode
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov eax, 0x4000003B	; PG=0,CD=1,NW=0,AM=0,WP=0,NE=1,TS=1,EM=0,MP=1,PE=1
	mov cr0, eax 		; CR0 컨트롤 레지스트에 저장한 플래그를 설정 하여 보호모드로 전환

	; 커널 코드 세그먼트를 0x00 기준으로 하는것으로 교체하고 EIP의 값을 0x00 기준으로 재설정
	; cs 세그먼트 셀럭터: eip
	jmp dword 0x8: ( protected_mode - $$ + 0x10000)
	; 커널코드 세그먼트가 0x00을 기준으로 하는 반명 실제 코드는 0x10000을 기준으로 실행되고 있으므로
	; 오프셋에 0x10000을 더해 세그먼트 교체 이후에도 같은 선형주소를 가리키게 함.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 보호 모드로 진입
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[BITS 32]
protected_mode:
	mov ax, 0x10 	; 보호모드 커널용 데이터 세그먼트 디스크럽터를 ax에 저장
	mov ds, ax  	; 설정
	mov es, ax  	; 설정
	mov fs, ax  	; 설정
	mov gs, ax  	; 설정

	; 스택 64kb 크기로 설정
	mov ss,ax
	mov esp, 0xFFFE
	mov ebp, 0xFFFE

	push ( switch_success_message - $$ + 0x10000 ) ;  출력할 메세지의 어드레스를 스택에 삽입
	push 2
	push 0
	call print_message
	add esp, 12

	jmp dword 0x08: 0x10200 ; c언어 커널이 존재하는 0x10200 주소로 이동하여 커널 수

print_message:
	push ebp
	mov esp,ebp

	push esi
	push edi
	push eax
	push ecx
	push edx

	mov eax, dword [ ebp+ 8 ]		; x좌표 계산
	mov esi, 2
	mul esi
	mov edi, eax

	mov eax, dword [ ebp + 12 ]		; y좌표 계산  
	mov esi, 80*2
	mul esi
	add edi, eax

	mov esi, dword [ ebp + 16 ]		; 문자열 받아오기

	message_loop:
		mov cl, byte [ esi ]

		cmp cl,0
		je message_end

		mov byte [ edi + 0xB8000 ], cl 
		add edi, 2
		add esi, 1

		jmp message_loop

message_end:
	pop edx
	pop ecx
	pop eax
	pop edi
	pop esi
	pop ebp
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 데이터 영역
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

align 8, db 0 ; 아래 데이터들을 8바이트에 맞쳐 정렬 하기 위해 추가

dw 0x0000 ; GDTR 끝을 8byte로 정렬하기 위해 추가

GDTR:
	dw GDTEND - GDT - 1 		; GDT 테이블의 전체 크기
	DD ( GDT - $$ + 0x10000)	; GDT 테이블의 시작 주소
								; 실제 GDB가 있는 선형주소 계산을 위해 
								;현재 섹션내 GDT 오프셋에 세그먼트 기준 주소 0x10000을 더함



GDT: ; GDT 테이블 정의
	null_descriptor: ; 널디스크럽터, 반드시 0으로 초기화 해야함
		dw 0x00000
		dw 0x00000
		db 0x00
		db 0x00
		db 0x00
		db 0x00

		; ~~

	data_descriptor: 	; 보호모드 커널용 데이터 세그먼트
		dw 0xFFFF		; Limit [15:0]
		dw 0x0000  		; Base [15:0]
		db 0x00 		; Base [23:16]
		db 0x92  		; P=1, DPL=0, Data Segment, R/W
		db 0xCF  		; Base [31:24]

GDTEND:

switch_success_message: db 'Switch To Protected Mode Success!!!!!', 0

times 512 - ( $ - $$ ) db 0x00 ; 512로 맞추기 위해 남은 부분을 0으로 채움

