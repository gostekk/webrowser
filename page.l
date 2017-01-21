%{
// Headers
#include <stdio.h>
#include <string.h>
#include <SDL2/SDL.h>
#include "getpage.h"
#include <SDL2/SDL_ttf.h>
#include <stdbool.h>

// Screen attributes
const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;
const int SCREEN_BPP = 32;

//The surfaces
SDL_Surface * message = NULL;
SDL_Window * window = NULL;
SDL_Renderer * renderer = NULL;
//The texture
SDL_Texture * texture = NULL;
//The event structure
SDL_Event event;

//Font
TTF_Font * font = NULL;

//The color of the font
SDL_Color textColour = {125, 125, 125};

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
bool init()
{
	//Initialize all SDL subsystems
	if(SDL_Init(SDL_INIT_EVERYTHING) == -1)
	{
		return false;
	}
	//Set up the screen
	window = SDL_CreateWindow("PonyBrowser", 0,0, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
	//If there was an error in setting up the window
	if(window == NULL)
	{
		return false;
	}
	//Initialize SDL_ttf
	TTF_Init();
	font = TTF_OpenFont("lazy.ttf", 25);
	//If there was an error in setting font
	if(TTF_Init() == -1)
	{
		return false;
	}
	//Set up the renderer
	renderer = SDL_CreateRenderer(window, -1, 0);
	//If there was an error in setting in the renderer
	if(renderer == NULL)
	{
		return false;
	}
	//If everything initalized fine
	return true;	
}
void clean_up()
{
	//Clean the texture
	SDL_DestroyTexture(texture);
	//Clean surface
	SDL_FreeSurface(message);
	//Close the font
	TTF_CloseFont(font);
	//Clean Renderer
	SDL_DestroyRenderer(renderer);
	//Clean window
	SDL_DestroyWindow(window);	
	//Quit SDL_ttf
	TTF_Quit();
	//Quit SDL
	SDL_Quit();
}
int main()
{	
	//Quit flag
	bool quit = false;
	int texW = 0;
	int texH = 0;
	//int argc;
	//char** argv;
	//Initialize
	if(init() == false)
	{
		return 1;
	}
	//Set the background colour
	SDL_SetRenderDrawColor(renderer, 0,0,0,255);
	//Renderer the window
	SDL_RenderClear(renderer);
	SDL_RenderPresent(renderer);
	//Render message
	message = TTF_RenderText_Solid(font, "PonyBrowser", textColour);
	//Create texture from surface
	texture = SDL_CreateTextureFromSurface(renderer, message);
	SDL_QueryTexture(texture, NULL, NULL, &texW, &texH);
	SDL_Rect dstrect = {0, 0, texW, texH};
	
	//If there was an error in rendering text
	if(message == NULL)
	{
		return 1;
	}
	//While the user hasn't quit
	while(quit == false)
	{
		//While there's events to handle
		while(SDL_PollEvent(&event))
		{
			//If the user has X out the window
			if(event.type == SDL_QUIT)
			{
				quit = true;
				break;
			}
		}
		SDL_RenderCopy(renderer,texture, NULL, &dstrect);
		SDL_RenderPresent(renderer);	
	}

        char *argss[] = { "http://91.188.125.49/index.html", "tmp/page.html"};
        getpage(argss);
        FILE *file;
        file = fopen("tmp/page.html","r");
        if(!file)
        {
                fprintf(stderr, "Count not open page.html");
                exit(-1);
        }
        yyin = file;
	yylex();
	clean_up();
	return 0;
	
}
