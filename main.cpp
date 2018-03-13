#include <stdio.h>

extern "C" {void  myPrintf(const char* fmt, ...);}

int main()
{
	myPrintf("Say hello to everyone, ok?\n%u\nJust look at this number: %x\n%b\n", 123, 0xEDA, 0b111);
}
