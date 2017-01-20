#include <stdio.h>
#include <string.h>
#include <curl/curl.h>

void getpage(char **args)
{
    CURL *curl;
    FILE *fp;
    CURLcode res;
    char *url = args[0], outfile[FILENAME_MAX];
    printf("%s\n", args[1]);
    strcpy(outfile,args[1]);
    curl = curl_easy_init();
    if (curl)
    {
        fp = fopen(outfile,"wb");
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, NULL);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
        fclose(fp);
    }
}

int main(void){
  char *argss[] = { "http://91.188.125.49/index.html", "tmp/page.html"};
  getpage(argss);
  return 0;
}
