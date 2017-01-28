%{
// Headers
#include <stdio.h>
#include <string.h>
#include "getpage.h"
#include <stdbool.h>
#include <getopt.h>
#include <ctype.h> // library with isprint()
#include <gtk/gtk.h>

char program_name[20]; /*!< Nazwa wywołanego programu */
int title=0;
char titlee[50]; /*!< Zmienna odpowiadajaca za tytul strony */
int yywrap();
int yywrap() {return 1;}
char buf[100];
char *s;
char bodyy[1024]; /*!< Zmienna odpowiadajaca za glowna czesc strony */
char *body = NULL;
char version[64] = "v.0.1 Alpha"; /*!< Aktualna wersja programu */
// Content of help
static char const * const option_help[] =
{
"-v  --version  Show version of program.",
"--help  Output this help.",
0
};

/*! \brief Struktura zawierająca opcje programu.
 *
 *  Funcja zawierająca długie opcje pliku wywoływane przy pomocy podwójnego myślnika na przykład:--show-all .
 */
static struct option const long_options[] =
{
  {"version", 0, 0, 'v'},
  {"help", 0, 0, 'h'},
  {0, 0, 0, 0}
};
// Parsing of file
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
<BODY>[\r\n\t]	{ *s++ = *yytext;}
<BODY>.        { bodyy[title]=*yytext;title++; *s++ = *yytext; }


<TITLE>\<[^<]*    { BEGIN 0;}
<TITLE>.          { titlee[title]=*yytext;
                  title++;
                  }
\n                {}
%%
/*! \brief Funkcja wyświetla zawartość pomocy.
 *
 *  Funcja uruchamiana gdy użytkownik wpisze --help lub -h, wyświetla ona zawartość pomocy oraz przykładowe użycie.
 */
void usage()
{
  printf ("Usage: %s [OPTION]... [URL]\n\n", program_name);
  for (int i=0 ; option_help[i] != 0; i++)
    printf ("  %s\n", option_help[i]);
  printf ("\nIf url is `-', read standard input.\n");
}

/*! \brief Funkcja wyświetla aktualna wersje programu.
 *
 *
 */
void pversion()
{
  printf ("PonyBrowser\nVersion: %s\n", version);
  exit(-1);
}

/*! \brief Funkcja (wyświetla błąd)* oraz podpowiedz użycia pomocy.
 *
 *  Funcja wyświetla aktualny błąd jeżeli takowy wystąpił oraz podpowiedz użycia komendy wyświetlającej pomoc.
 */
static void try_help (char const *reason)
{
  if (reason)
    fprintf (stderr, "%s \n", reason);
  printf ("Try `%s --help' for more information.\n", program_name);
  exit(EXIT_FAILURE);
}
/*! \brief Glowna funkcja odpowiadajaca za GUI oraz parsowanie pliku.
 *
 * Funkcja powoduje powstanie glownego okna programu oraz wywolanie na nim sparsowanej strony.
 */
int main(int argc, char *argv[])
{
  int c;
  strcpy(program_name,argv[0]);
  opterr = 0;

  while ((c = getopt_long (argc, argv,
          "vh",
          long_options, 0)) != EOF){

    switch (c)
    {
      case 'v':
        pversion();

      case 'h':
        usage();
        exit (0);

      case '?':
        if (optopt == 'c'){
          fprintf (stderr, "Option -%c requires an argument.\n", optopt);
          try_help(0);
        }
        else if (isprint (optopt)){
          fprintf (stderr, "Unknown option `-%c'.\n", optopt);
          try_help(0);
        }
        else {
          fprintf (stderr,
                    "Unknown option character `\\x%x'.\n",
                    optopt);
          try_help(0);
        }
        return 1;

        default:
          try_help (0);
      }
  }

  if (optind >= argc) {
    try_help("Expected page address after options");
  }
  else if (argc - optind < 1){
    try_help("Insert page address");
  }
  else if (argc - optind > 1){
    try_help("Too much arguments");
  }
  else{

  GtkWidget *window;
  GtkWidget *label;

  gtk_init(&argc, &argv);

	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
	gtk_window_set_title(GTK_WINDOW(window), "PonyBrowser");
	label = gtk_label_new(NULL);
	gtk_window_set_default_size(GTK_WINDOW(window), 800, 600);
	gtk_label_set_yalign(GTK_LABEL(label), 0);
	gtk_label_set_xalign(GTK_LABEL(label), 0);
	gtk_container_add(GTK_CONTAINER(window), label);
	gtk_widget_show(label);
        char *argss[] = { argv[1], "tmp/page.html"};
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

	gtk_label_set_markup(GTK_LABEL(label), bodyy);

	g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
	gtk_widget_show(window);
	gtk_main();
	return 0;
}
}
