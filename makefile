# build an executable named myprog from myprog.c
 all: getpage.c
	 flex page.l
	 gcc -std=c99 -w `pkg-config --cflags gtk+-3.0` -o ponybrowser lex.yy.c getpage.c `pkg-config --libs gtk+-3.0` -lcurl

 clean:
	 $(RM) ponybrowser
