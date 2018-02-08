#!usr/bin/bash
#This script builds an executable file for an .asm file for Linux

echo Enter the asm file to execute
read file

yasm -f elf64  -o $file.o $file.asm
ld -o $file $file.o
rm $file.o
