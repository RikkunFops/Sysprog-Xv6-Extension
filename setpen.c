#include "types.h"
#include "user.h"
int main(int argc, char* argv[])
{
    int hdc = 0;
    int index = atoi(argv[1]);
    selectpen(hdc, index);

    exit();
}