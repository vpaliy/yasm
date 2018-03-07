#include "mem.h"
#include <assert.h>
#include <sys/types.h>
#include <unistd.h>

#define SIZE 2048
#define META_SIZE sizeof(page_t)
#define SBRK_ERROR (void*)(-1)

page_t* global;
page_t* last;

page_t* find(page_t* head, size_t size)
{
  while(head) {
    if(head->size == size && head->free)
      return head;
    head = head->next;
  }
  return NULL;
}

page_t* allocate(size_t size)
{
  page_t* node = sbrk(0);
  void* pointer = sbrk(size + sizeof(page_t));
  if(pointer == SBRK_ERROR)
    return NULL;
  if(last != NULL)
    last->next = node;
  last = node;
  node->next = NULL;
  node->free = false;
  node->size = size;
  return node;
}

void* memalloc(size_t size)
{
  page_t* result = NULL;
  if(global == NULL){
    global = allocate(size);
    result = global;
  }else {
    result = find(global, size);
    if(result == NULL)
      result = allocate(size);
  }
  return result ? (result + 1) : result;
}

void* memcopy(void* dest, void* source, size_t length, size_t size)
{
  if(!length||!size||!source)
    return dest;
  else if(!dest)
    dest=calloc(length,size);
  /* Cast this too unsigned long, so the data will be moved in bigger chunks */
  unsigned long* source_ul = (unsigned long*)(source);
  unsigned long* dest_ul = (unsigned long*)(dest);
  /* Get the total number of bytes that need to be copied */
  length *= size;
  /* Copy data from the destination into source */
  for(ssize_t bound = length - sizeof(unsigned long);bound >= 0;bound -= sizeof(unsigned long))
        *dest_ul++ = *source_ul++;
  size_t copied =(dest_ul-(unsigned long*)(dest))*sizeof(unsigned long);
  if(copied == length)
    return dest;
  /* Copy whatever is left */
  unsigned char* source_uc = (unsigned char*)(source_ul);
  unsigned char* dest_uc = (unsigned char*)(dest_ul);
  while(copied++ <= length)
    *dest_uc++ = *source_uc++;
  return dest;
}

int main(int argc, char** argv)
{
  for(int index =0; index <= 2; index++){
    char* pointer = memalloc(10);
    printf("%p\n", pointer);
  }
  return 1;
}
