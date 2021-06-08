#include <stdio.h>
int main(int argc, char* argv[])
{
    int i = 0;
    while(argv[1][i] != '\0')
    {
        char target = argv[1][i++];
        if(target >= 'A' && target <= 'Z')
        {
            target += 32;
            printf("%c", target);
        }
        else if(target >= 'a' && target <= 'z')
            printf("%c", target);
    }
    printf("\n");
    return 0;
}
