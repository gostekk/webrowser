OBJECTS = lex.yy.c getpage.c
LIBS = -lSDL2_ttf -lSDL2 -lcurl
webrowser: $(OBJECTS)
	flex page.l
	gcc $(OBJECTS) $(LIBS)

