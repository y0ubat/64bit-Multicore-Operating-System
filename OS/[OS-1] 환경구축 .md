#Mac OSX에서 환경구축
-

###명령어 라인 개발자 도구 설치
Cross-compiler를 build하기 위해 Native Compiler가 필요하다.
OSX 10.8 Mountain Lion부터는 추가 설치가 필요하다.

	$xcode-select --install

###Cross-compiler Build

	$export TARGET=x86_64-pc-linux
	$export PREFIX=/opt/cross (설치경로)
	
Home Directory의 `.bash_profile` or `.bashrc` 파일을 편집하여, Cross-compiler directory를 PATH 환경변수에 추가한다. 

####GNU Binutils Bulid
OS X의 Mach-O형식을 지원하지 않기 때문에 Port를 이용해 설치하는 경우 as ld 등 명령어가 실행이 안되서 직접 컴파일 해야된다.
<br>[다운로드](http://www.gnu.org/software/binutils/) (binutils-2.23.tar.gz) <br>

	$ ./configure --target=$TARGET --prefix=$PREFIX --enable-64-bit-bfd --disable-shared --disable-nls --disable-werror
	$ make configure-host
	$ make LDFLAGS="-all-static"
	$ sudo make install
	
####GCC설치 
OS X은 Mach-O 형식의 실행 파일을 사용합니다. 때문에 OS X 개발툴에 포함된 GCC는 Mach-O 형식의 실행파일을 생성하며, 책에서 사용하는 ELF 형식을 지원하지 않습니다.
[다운로드](https://gcc.gnu.org/)에서 받을 수 있습니다.

압축 풀고 `$ ./contrib/download_prerequisites`을 우선 실행합니다. 
	
	$ ./configure --target=$TARGET --prefix=$PREFIX --	disable-nls --enable-languages=c --without-headers --	disable-shared --enable-multilib
	$ make configure-host
	$ make all-gcc
	$ sudo make install-gcc
	

###NASM,QEMU 설치
port를 이용해서 간단히 받을 수 있다. Port설치는 [다운로드](https://www.macports.org/install.php)에서 설치할수있다. <br>
`sudo port install nasm qemu`


###Reference
* [참고](http://nayuta.net/64%EB%B9%84%ED%8A%B8_%EB%A9%80%ED%8B%B0%EC%BD%94%EC%96%B4_OS_%EC%9B%90%EB%A6%AC%EC%99%80_%EA%B5%AC%EC%A1%B0/OS_X%EC%97%90%EC%84%9C_%EA%B0%9C%EB%B0%9C%ED%99%98%EA%B2%BD_%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0)