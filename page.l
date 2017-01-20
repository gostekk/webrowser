%{
#include <stdio.h>
#include "getpage.h"
int title;
%}
%%
[a-zA-Z]+	{
	title += yyleng;	
}
%%
int yywrap(void)
{
	fprintf(yyout, "\tSlow:%d\n", title);
	return 1;
}
