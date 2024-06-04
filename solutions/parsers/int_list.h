#ifndef INT_LIST
#define INT_LIST
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct {
  int len;
  int cap;
  int items[];
} IntArray;

typedef struct {
  int len;
  int cap;
  IntArray* arrays[];
} IntMatrix;

IntArray *read_int_arr(int day);
void print_int_arr(IntArray *arr);
IntArray* deep_copy_array(IntArray* orig);
bool arrays_equal(IntArray* first, IntArray* second);

IntMatrix* new_int_matrix(int cap);
void int_matrix_push(IntMatrix** container_ref, IntArray* array);
void print_int_matrix(IntMatrix* cont);
int find_matrix_row(IntMatrix* container, IntArray* needle);

#endif // !INT_LIST
