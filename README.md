##Web-browser
###Liczba wykonawców: 4
###Subiektywny poziom trudności: \*\*\*\*\*

Napisać własną przeglądarkę internetową (bez GUI). Można się ograniczyć do kilku podstawowych "tagów" html, np: a, b, i, img, br, hn.
Sugerowany podział pracy:

    -wykonawca 1: struktury danych wewnętrznie reprezentujące dokument html, zarządzanie pamięciom, koordynacja pracy całego zespołu;
    -wykonawca 2: obsługa internetu, pobieranie strony i zasobów; (wskazówka: użyć biblioteki libcurl, tutoriale łatwo dostępne w internecie);
    -wykonawca 3: parsowanie pliku html i przekształcenie na wewnętrzną reprezentację w pamięci programu; (wskazówka: użyć lex+yacc lub flex+bison, tutoriale łatwo dostępne w internecie);
    -wykonawca 4: renderowanie wewnętrznej pamięciowej reprezentacji strony www na ekranie; (wskazówka: użyć bibliotek sdl i sdl_image, tutoriale łatwo dostępne w internecie);

_______________
Usage: ? [OPTION]
Web-browser.
________________________
### OPTIONS.
|short| long                     | Descriptors |
| :---| :----                    |:---|
| -h  | --help                   | Output this help.|
