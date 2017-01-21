#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "getpage.h"

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
return 0;
}
