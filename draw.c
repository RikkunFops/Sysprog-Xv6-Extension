#include "types.h"
#include "user.h"

int main(int argc, char* argv[])
{
    setvideomode(0x13);
    
    moveto(0, 100, 50);
    lineto(0, 200, 50);
    lineto(0, 200, 150);
    lineto(0, 100, 150);
    lineto(0, 100, 50);
    getch();
    setvideomode(0x03);

    exit();
}