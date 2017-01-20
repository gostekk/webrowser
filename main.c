#include <stdio.h>
#include "getpage.h"

int main(void){
  char *argss[] = { "http://91.188.125.49/index.html", "tmp/page.html"};
  getpage(argss);
  return 0;
}
