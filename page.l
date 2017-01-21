%{
#include <stdio.h>
#include <string.h>
#include "getpage.h"
#include "gui.h"
char *yylval;
int title=0;
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
//eprintf("%d\n", title);
}
