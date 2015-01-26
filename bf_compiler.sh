#! /bin/bash

main() {
  INPUT="${1}"
  OUTPUT="${2}"
  TEMP="${INPUT}.c"

  BEGIN='#include <stdio.h>
  int main(){
  char array[100000] = {0};
  char *ptr=array;'
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
    esac
  done < "${INPUT}"
  echo >> "${TEMP}"
  echo '}' >> "${TEMP}"
  gcc -o "${OUTPUT}" "${TEMP}"
  rm "${TEMP}"
}
main "${@}"
