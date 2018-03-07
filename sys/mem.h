#ifndef __MEM__
#define __MEM__
#include<stdio.h>
#include<stdlib.h>
typedef enum { false, true } bool;
typedef struct page
{
  size_t size;
  bool free;
  struct page* next;
} page_t;
extern void* memcopy(void* source, void* dest, size_t length, size_t size);
extern void* memalloc(size_t size);
extern void* memfree(void* pointer);
extern void* calloc(size_t number, size_t size);
#endif
