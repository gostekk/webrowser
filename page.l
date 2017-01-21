%{
#include <stdio.h>
#include <string.h>
#include <SDL2/SDL.h>
#include "getpage.h"
#include <SDL2/SDL_ttf.h>

const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;
char *yylval;
int title=0;
char titlee[50];
int yywrap();
int yywrap() {return 1;}
char buf[100];
char *s;

%}
%x STRING
%x BODY
%x TITLE
%%
\<              { BEGIN STRING; s = buf; }
<STRING>(body>) { BEGIN BODY;}
<STRING>(title>) { BEGIN TITLE;}
<STRING>\>      {
                  *s = 0;
                  BEGIN 0;
                }
<STRING>.       { *s++ = *yytext; }
<BODY>\<        { s = buf;}
<BODY>\\n     { printf("desu" );*s++ = '\n'; }
<BODY>(\/body>)  { BEGIN 0;}
<BODY>(\/br)     { *s++ = '\n'; }
<BODY>\>      {   *s = 0;
                }

<BODY>.         { printf("%s", yytext); *s++ = *yytext; }


<TITLE>\<[^<]*    { BEGIN 0;}
<TITLE>.          { titlee[title]=*yytext;
                  title++;
                  }
\n                {}
%%
int main(argc, argv)
int argc;
char** argv;
{
SDL_Window* window = NULL;
SDL_Surface* surface = NULL;
SDL_Renderer* renderer = NULL;
SDL_Texture* texture = NULL;
if( SDL_Init( SDL_INIT_VIDEO ) < 0)
{
        printf("SDL coult not initalize! SDL_Error: %s\n", SDL_GetError());
}
else
{
	TTF_Init();
        window = SDL_CreateWindow("PonyBrowser", 100, 100, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
        if(window == NULL)
        {
                printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
        }
        else
        {
		renderer = SDL_CreateRenderer(window, -1, 0);
		TTF_Font * font = TTF_OpenFont("arial.ttf", 25);
		if(renderer == NULL)
		{
			printf("Renderer could not be created! SDL_Error: %s\n", SDL_GetError());
		}
		else
		{
			SDL_Event e;
			do{
				SDL_WaitEvent(&e);
				switch(e.type)
				{
				case SDL_WINDOWEVENT:
					SDL_SetRenderDrawColor(renderer, 0,0,0,255);
					SDL_RenderClear(renderer);
					SDL_RenderPresent(renderer);
					SDL_Color color = { 255, 255, 255};
					SDL_Surface * surface = TTF_RenderText_Solid(font, "Welcome", color);
					SDL_Texture * texture = SDL_CreateTextureFromSurface(renderer, surface);
					SDL_RenderCopy(renderer, texture, NULL, NULL);
					break;
					}
				}while(e.type != SDL_QUIT);
				SDL_DestroyTexture(texture);
				SDL_FreeSurface(surface);
				TTF_CloseFont(font);
				TTF_Quit();
				return 0;
		}
        }
}

        char *argss[] = { "http://91.188.125.49/index.html", "tmp/page.html"};
        getpage(argss);
        FILE *file;
        file = fopen("tmp/page.html","r");
        if(!file)
        {
                fprintf(stderr, "Count not open %s\n", argv[1]);
                exit(-1);
        }
        yyin = file;
yylex();
SDL_Delay(20000);
}
