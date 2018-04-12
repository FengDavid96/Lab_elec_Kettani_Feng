#include <stdio.h>
int steps = 0;
void move(char src, char dst);
void mhanoi(int n, char src, char dst, char temp);
void mhanoi2(int n, char src, char dst, char temp);

int main(int argc, const char * argv[]) {
    int n = 3;
    mhanoi(n, 'A', 'B', 'C');
    return 0;
}

void move(char src, char dst){
    steps++;
    printf("%d move %c -> %c\n", steps, src, dst);
}

void mhanoi(int n, char src, char dst, char temp){
    if(n==1){
        move(src, dst);
    }else{
        mhanoi(n-1, src, temp, dst);
        move(src, dst);
        mhanoi2(n-1, temp, src, dst);
        mhanoi(n-1, src, dst, temp);
    }
}

void mhanoi2(int n, char src, char dst, char temp){
    if(n==1){
        move(src, dst);
    }else{
        mhanoi2(n-1, src, dst, temp);
        mhanoi(n-1, dst, temp, src);
        move(src, dst);
        mhanoi2(n-1, temp, dst, src);
    }
}