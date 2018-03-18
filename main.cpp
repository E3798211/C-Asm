#include <stdio.h>

extern "C" {void  myPrintf(const char* fmt, ...);}

int main()
{
	myPrintf("qwerty\n");
}
