#ifndef __MEM__
#define __MEM__
#include<stdio.h>
#include<stdlib.h>
extern void* memcopy(void* source, void* dest, size_t length, size_t size);
extern void* memalloc(size_t size);
extern void* memfree(void* pointer);
#endif
