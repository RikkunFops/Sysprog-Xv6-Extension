#include "types.h"
#include "user.h"
int main(int argc, char* argv[])
{
    int index = atoi(argv[1]);
    int r = atoi(argv[2]);
    int g = atoi(argv[3]);
    int b = atoi(argv[4]);
  
    setpencolour(index, r, g, b);
    exit();
    
}