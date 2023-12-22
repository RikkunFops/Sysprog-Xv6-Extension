#include "types.h"
#include "user.h"
#include "stat.h"

struct rect {
    int x1;
    int y1;
    int x2;
    int y2;
} Trect;

int main(int argc, char* argv[]) {

    if (argc != 5) {
        printf(1, "Syntax is 'fillrect x1 y1 x2 y2'\n");
        exit();
    }

    Trect.x1 = atoi(argv[1]);
    Trect.y1 = atoi(argv[2]);
    Trect.x2 = atoi(argv[3]);
    Trect.y2 = atoi(argv[4]);

    
    setvideomode(0x13);
    int hdc = beginpaint(0);
    setpencolour(20, 30, 22, 2);
    selectpen(hdc, 20);
    fillrect(hdc, &Trect);
    endpaint(hdc);
    getch();
    setvideomode(0x03);
    exit();
}