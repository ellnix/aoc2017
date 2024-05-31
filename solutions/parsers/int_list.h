#ifndef INT_LIST
#define INT_LIST
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  int len;
  int cap;
  int items[];
} int_array_t;

int_array_t *read_int_arr(int day);
void print_int_arr(int_array_t *arr);

#endif // !INT_LIST
