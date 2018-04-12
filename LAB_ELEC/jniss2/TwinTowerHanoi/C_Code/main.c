//
//  main.c
//  Thanoi
//
//  Created by CoorFang on 17/04/2017.
//  Copyright © 2017 CoorFang. All rights reserved.
//

#include <stdio.h>
int steps = 0;
void Amove(char src, char dst);
void consolidate(int n, char src, char dst, char temp);
void distribute(int n, char src, char dst, char temp);
void double_hanoi(int n, char src, char dst, char temp);

int main(int argc, const char * argv[]) {
    int n = 3;
    consolidate(n-1, 'B', 'A', 'C');
    Amove('B', 'C');
    double_hanoi(n-1, 'A', 'C', 'B');
    Amove('A', 'B');
    double_hanoi(n-1, 'C', 'B', 'A');
    Amove('C', 'A');
    distribute(n-1, 'B', 'A', 'C');
}

void Amove(char src, char dst){
    steps++;
    printf("%d move %c -> %c\n", steps, src, dst);
}

void consolidate(int n, char src, char dst, char temp){
    if(n == 1) Amove(src, dst);
    else{
        consolidate(n-1, src, dst, temp);
        double_hanoi(n-1, dst, temp, src);
        Amove(src, dst);
        double_hanoi(n-1, temp, dst, src);
    }
}

void double_hanoi(int n, char src, char dst, char temp){
    if(n==1){
        Amove(src, dst);
        Amove(src, dst);
    }else{
        double_hanoi(n-1, src, temp, dst);
        Amove(src, dst);
        Amove(src, dst);
        double_hanoi(n-1, temp, dst, src);
    }
}

void distribute(int n, char src, char dst, char temp){
    if(n==1) Amove(src, dst);
    else{
        double_hanoi(n-1, src, temp, dst);
        Amove(src, dst);
        double_hanoi(n-1, temp, src, dst);
        distribute(n-1, src, dst, temp);
    }
}
