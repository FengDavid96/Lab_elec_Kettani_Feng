#include <stdio.h>
int steps=0;

void hanoi(int, char src, char dst, char tmp);
void move(char src, char dst);

int main()
{
    int num=4;
    hanoi(num, 'A', 'B', 'C');
    return 0;
}

void hanoi(int num, char src, char dst, char tmp)
{
    if (num == 1){
        move(src, dst);
    }else{
    hanoi(num - 1, src, tmp, dst);
    move(src, dst);
    hanoi(num - 1, tmp, dst, src);
    }
}

void move(char src, char dst){
    steps++;
    printf("%d move %c -> %c\n", steps, src, dst);
}