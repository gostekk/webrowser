%{
// Headers
#include <stdio.h>
#include <string.h>
#include "getpage.h"
#include <stdbool.h>
#include <gtk/gtk.h>

char *yylval;
int title=0,body_len=0;
char titlee[50];
int yywrap();
int yywrap() {return 1;}
char buf[100],body[4096];
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
<BODY>(\/body>)  { BEGIN 0;}

<BODY>.         { body[body_len]=*yytext; body_len++; *s++ = *yytext; }


<TITLE>\<[^<]*    { BEGIN 0;}
<TITLE>.          { titlee[title]=*yytext;
                  title++;
                  }
\n                {}
%%
int main()
{
	GtkWidget *window;
	GtkWidget *textView;
	GtkTextBuffer *buffer;
	GtkTextIter iter;
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
	gtk_init();
	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
	gtk_window_set_default_size(GTK_WINDOW(window), 250, 200);
	gtk_window_set_title(GTK_WINDOW(window), "PonyBrowser");
	gtk_container_set_border_width(GTK_CONTAINER(window), 5);
	GTK_WINDOW(window)->allow_shrink = TRUE;
	textView = gtk_text_view_new();
	gtk_container_add(GTK_CONTAINER(window), textView);
	g_signal_connect(G_OBJECT(window), "destroy", G_CALLBACK(gtk_main_quit), NULL);
	gtk_widget_show_all(window);
	gtk_main();
	return 0;
	
}
