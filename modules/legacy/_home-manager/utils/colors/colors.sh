#!/bin/sh
set -eu

print_row() {
  start=$1
  i=0
  while [ $i -lt 8 ]; do
    color=$((start + i))
    tput setaf "${color}"
    printf "%s " "██"
    tput sgr0
    i=$((i + 1))
  done
  printf "\n"
}

print_row 0
print_row 8
