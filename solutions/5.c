#include <stdio.h>
#include "parsers/int_list.h"

int part1();
int part2();

int main() {
  int p1 = part1();
  int p2 = part2();
  printf("Part 1: %d, Part 2: %d.\n", p1, p2);
}

int part1() {
  int_array_t *input_nums = read_int_arr(5);
  int steps = 0;

  for (int pos = 0; pos >= 0 && pos < input_nums->len;
       steps++, pos += input_nums->items[pos]++)
    ;

  free(input_nums);

  return steps;
}

int part2() { 
  int_array_t *input_nums = read_int_arr(5);
  int steps = 0;

  for (int pos = 0; pos >= 0 && pos < input_nums->len; steps++) {
    if (input_nums->items[pos] >= 3)
      pos += input_nums->items[pos]--;
    else
      pos += input_nums->items[pos]++;
  }

  free(input_nums);

  return steps;
}
