#OS-5 BIOS,Booting



![Imgur](http://i.imgur.com/zd8b96xm.png)

< OS 부팅 과정 > 


BIOS는 POST가 완료되고, 여러 장치 검사후 앞부분에 부트로더가 있는지 확인한다.
존재 한다면, 0x7c00 주소에 복사한 후 0x7c00부터 실행된다.

####MBR(Master Boot Record)

-	512바이트로 구성되어 있다.
-	OS실행에 필요한 환경을 설정한다
-  OS이미지를 메모리에 복사하는 일을 한다


BIOS에서 첫번째 섹터 512바이트 중에 가장 마지막 2바이트가 `0x55,0xAA`인지 검사해서 부트로더 인지 확인한다. 


![Imgur](http://i.imgur.com/qOIzOgPm.png)

< OS 디렉토리 구조 >

<br>
<br>

**BootLoaders.asm**
	
	[ORG 0x00]
	[BITS 16]

	SECTION .text

	jmp 0x07C0:START

	START:
		mov ax,0x07C0
		mov ds,ax
		mov ax,0xB800
		mov es,ax

	mov si, 0

	clearloop:
		mov byte [es:si], 0x00
		mov byte [es:si+1], 0x0A
		add si, 2

		cmp si,80*25*2
		jl clearloop

		mov si, 0
		mov di, 0

	Messageloop:
		mov cl, byte [si + HELLO]
		cmp cl,0
		je MessageEnd

		mov byte [es:di],cl
		add si, 1
		add di, 2

		jmp Messageloop

	MessageEnd:

	HELLO: db 'Welcome to HS Operate System', 0
	
	jmp $ ; 현재 위치에서 무한 루프 수행

	times 510-( $ - $$ )	db	0x00  ; $: 현재라인 주소
									  ; $$: 현재 섹션 (.text)의 시작 어드레스
									  ; $-$$: 현재 섹션을 기준으로 하는 오프셋
									  ; 510-($-$$): 현재부터 어드레스 510까지
									  ; time: 반복수행
								  	  ; 현재 위치에서 어드레스510까지 0x00로 채운다.

	dw 0xAA55 				          ; 부트 섹터 표기
	



PC 부팅후 기본으로 설정뙤는 화면모드는 텍스트모드이며, 가로80 세로25, (80x25x2 == 4000)이다.
비디오 메모리 어드레스는 0xB8000부터 시작 된다.



![Imgur](http://i.imgur.com/aXQVp14.png)

