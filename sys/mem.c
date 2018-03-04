#include "mem.h"
int below;
int size = 0;
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

int main(int argc, char* argv[]) {
  void* pointer = sbrk(0);
  printf("%p\n", &size);
    printf("%p\n", &below);
  printf("%p\n",pointer);
  pointer = sbrk(1);
  printf("%p\n",pointer);
  pointer = sbrk(0);
  printf("%p\n",pointer);
}
