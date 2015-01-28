#! /bin/bash

main() {
  INPUT="${1}"
  OUTPUT="${2}"
  TEMP="${INPUT}.c"
  FILE=' 
  begFileName = ptr;
  if(!isOpen) {
    int* cur = ptr
    int idx = 0;
    while(cur) {
      name[idx] = cur;
      ++ptr;
      cur = *ptr;
      idx++;
    }
    if(f = fopen(name,w+b)) {
      ptr = begFileName;
      ptr* = 0x00;
    }
    else {
      ptr = begFileName;
      ptr* = 0xFF;
    }
  } else {
    fclose(f);
  }'
  READBYTE='
  if(!(*ptr = fread(&curByte,sizeOf(char),1,f)))
    *ptr = 0x00;
  '
  WRITEBYTE='
  if(!(*ptr = fwrite(ptr, sizeOf(char),1,f)))
    *ptr = 0x00;
  '
  BEGIN='#include <stdio.h>
  bool isOpen = false;
  #include <fstream>
  int main(){
  int array[100000] = {0};
  int *ptr=array;
  int cur = *ptr;
  char* fptr;
  char* name;
  int* begFileName;
  char curByte = 0;
  FILE* f;'
  echo "$BEGIN" > "${TEMP}"
  while read -n1 char; do
    case $char in
      \>)
        echo -n '++ptr;' >> "${TEMP}";;
      \<)
        echo -n '--ptr;' >> "${TEMP}";;
      \+)
        echo -n '++*ptr;' >> "${TEMP}";;
      \-)
        echo -n '--*ptr;' >> "${TEMP}";;
      \.)
        echo -n 'putchar(*ptr);' >> "${TEMP}";;
      \,)
        echo -n '*ptr=getchar();' >> "${TEMP}";;
      \[)
        echo -n 'while (*ptr) {' >> "${TEMP}";;
      \])
        echo -n '}' >> "${TEMP}";;
      \#)
        echo -n "$FILE" >> "${TEMP}";;
      \:)
        echo -n "$READBYTE" >> "${TEMP}";;
      \;) 
        echo -n "$WRITEBYTE" >> "${TEMP}";;
    esac
  done < "${INPUT}"
  echo >> "${TEMP}"
  echo '}' >> "${TEMP}"
  g++ -o "${OUTPUT}" "${TEMP}"
  rm "${TEMP}"
}
main "${@}"
