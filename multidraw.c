#include "types.h"
#include "user.h"

struct rect {
    int x1;
    int y1;
    int x2;
    int y2;
} Trect;

int main(int argc, char* argv[])
{

    int pid = fork();
    setvideomode(0x13);
    if (pid < 0) {
        printf(1, "Forking failed\n");
    }
    else if (pid == 0) {
        // Child process
        printf(1, "Child process (PID: %d) created\n", getpid());

        Trect.x1 = 10;
        Trect.y1 = 10;
        Trect.x2 = 20;
        Trect.y2 = 20;
        int hdc = beginpaint(0);
        selectpen(hdc, 3);
        fillrect(hdc, &Trect);
        endpaint(hdc);
        exit();
    }
    else {
        // Parent process
        printf(1, "Parent process (PID: %d) created a child process (PID: %d)\n", getpid(), pid);
        wait();

        Trect.x1 = 40;
        Trect.y1 = 40;
        Trect.x2 = 50;
        Trect.y2 = 50;
        int hdc = beginpaint(0);
        selectpen(hdc, 7);
        fillrect(hdc, &Trect);
        endpaint(hdc);
        getch();
        setvideomode(0x03);

        exit();
    }

}


