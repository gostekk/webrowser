%{
// Headers
#include <stdio.h>
#include <string.h>
#include "getpage.h"
#include <stdbool.h>
#include <gtk/gtk.h>
int title=0;
char titlee[50];
int yywrap();
int yywrap() {return 1;}
char buf[100];
char *s;
gchar bodyy[1024];
char *body = NULL;

%}
%x STRING
%x BODY
%x TITLE
%%
\<              { BEGIN STRING; s = buf;}
<STRING>(body>) { title=0;BEGIN BODY;}
<STRING>(title>) { BEGIN TITLE;}
<STRING>\>      {
                  *s = 0;
                  BEGIN 0;
                }
<STRING>.       { *s++ = *yytext; }
<BODY>\<"/body>"  { BEGIN 0;}
<BODY>\\n      { bodyy[title]='\n';title++; *s++ = *yytext;}
<BODY>.        { bodyy[title]=*yytext;title++; *s++ = *yytext; }


<TITLE>\<[^<]*    { BEGIN 0;}
<TITLE>.          { titlee[title]=*yytext;
                  title++;
                  }
\n                {}
%%
int main(int argc, char *argv[])
{
  GtkWidget *window;
  GtkWidget *label;

	gtk_init(&argc, &argv);

	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
	gtk_window_set_title(GTK_WINDOW(window), "PonyBrowser");
	label = gtk_label_new(NULL);
	gtk_window_set_default_size(GTK_WINDOW(window), 800, 600);
	gtk_container_add(GTK_CONTAINER(window), label);
	gtk_widget_show(label);
        //char *argss[] = { "http://91.188.125.49/index.html", "tmp/page.html"};
        //getpage(argss);
        FILE *file;
        file = fopen("page.html","r");
        if(!file)
        {
                fprintf(stderr, "Count not open page.html");
                exit(-1);
        }
        yyin = file;
	yylex();

  //strcpy(bodyy, "<b>Tekst</b>ehh ");

	//for(int i = 0; i < (sizeof(bodyy) / sizeof(bodyy[0])); i++)
	//{

	gtk_label_set_markup(GTK_LABEL(label), bodyy);
	//}
	g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
	gtk_widget_show(window);
	gtk_main();
	return 0;
}
