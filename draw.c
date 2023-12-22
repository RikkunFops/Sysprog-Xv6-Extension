#include "types.h"
#include "user.h"
int main(int argc, char* argv[])
{

    int pid = fork();
    setvideomode(0x13);
    if (pid < 0) {
        printf(1, "Fork failedd");
    }
    else if (pid == 0) {
        // Child proccess
        int hdc = beginpaint(0);
        selectpen(hdc, 12);
        moveto(hdc, 0, 0);
        lineto(hdc, 100, 100);
        lineto(hdc, 200, 10);
        endpaint(hdc);
        exit();
    }
    wait();
    int hdc = beginpaint(0);
    selectpen(hdc, 15);
    moveto(hdc, 100, 50);
    lineto(hdc, 200, 50);
    lineto(hdc, 200, 150);
    lineto(hdc, 100, 150);
    lineto(hdc, 100, 50);
    endpaint(hdc);
    getch();
    setvideomode(0x03);
    exit();
}