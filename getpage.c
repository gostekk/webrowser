#include <stdio.h>
#include <curl/curl.h>


int main(int argc, char* args[]) {

    char *url = args[1];
    CURL *curl;
    CURLcode res;
    FILE *file;

    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url);

        char *output = args[1];
        file = fopen(output, "wb");
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, file);

        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
          fprintf(stderr, "Couldn't download file: %s\n",
                  curl_easy_strerror(res));

        curl_easy_cleanup(curl);
    }

    return 0;
}
