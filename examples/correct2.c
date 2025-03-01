#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "teaclib.h"

const int N = 100;
int a, b, z;


int cube(int i){
return i * i * i;
}


int add(int n, int k){
int j;
j = (N - n) + cube(k);
printf("%d", j);
return j;
}


int main(){
a = atoi(readString());
b = atoi(readString());
add(a, b);
if(a < b)
{
printf("%d", b);
}
else if(a != 0)
{
printf("%d", a);
}
else
{
z = a * b;
while(z != 0)
{
if(z < 0)
{
z = z + 1;
}
else
{
z = z - 1;
}
a = a + b;
b = a - b;
a = b - a;
}
}
return 0;
}
