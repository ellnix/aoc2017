#include "int_list.h"

IntArray *read_int_arr(int day) {
  IntArray *output =
      (IntArray *)malloc((sizeof(IntArray) + 10) * sizeof(int));
  output->len = 0;
  output->cap = 10;

  char *filename = malloc(sizeof(char) * 20);
  sprintf(filename, "inputs/%d", day);
  FILE *input_file = fopen(filename, "r");

  int n;

  while (fscanf(input_file, "%d", &n) != EOF) {
    if (output->len >= output->cap) {
      output = (IntArray *)realloc(
          output, output->len * 2  * sizeof(int) + sizeof(IntArray));

      output->cap *= 2;
    }

    output->items[output->len] = n;

    output->len++;
  }

  fclose(input_file);

  return output;
}

void print_int_arr(IntArray *arr) {
  printf("Len: %d, cap: %d.\n", arr->len, arr->cap);
  printf("Elements: ");
  for (int i = 0; i < arr->len; i++)
    printf(" %d", arr->items[i]);

  printf("\n");
}

IntArray* deep_copy_array(IntArray* orig) {
  IntArray* clone = malloc(sizeof(IntArray) + sizeof(int) * orig->len);

  clone->cap = clone->len = orig->len;
  for (int i = 0; i < orig->len; i++)
    clone->items[i] = orig->items[i];

  return clone;
}

bool arrays_equal(IntArray* first, IntArray* second) {
  if (first->len != second->len)
    return false;

  for(int i = 0; i < first->len; i++)
    if (first->items[i] != second->items[i])
      return false;

  return true;
}

IntMatrix* new_int_matrix(int cap) {
  IntMatrix* matrix = malloc(sizeof(IntMatrix) + cap * sizeof(IntArray*));
  matrix->len = 0;
  matrix->cap = cap;
  return matrix;
}

void int_matrix_push(IntMatrix** container_ref, IntArray* array) {
  if ((*container_ref)->len >= (*container_ref)->cap) {
    if ((*container_ref)->cap == 0)
      (*container_ref)->cap++;
    *container_ref = realloc((*container_ref), sizeof(IntMatrix) + (*container_ref)->cap * 2 * sizeof(IntArray*));
    (*container_ref)->cap *= 2;
  }
  (*container_ref)->arrays[(*container_ref)->len] = array;
  (*container_ref)->len++;
}

void print_int_matrix(IntMatrix* cont) {
  printf("<CONTAINER> Len: %d, Cap: %d.\nArrays:", cont->len, cont->cap);
  for(int i = 0; i < cont->len; i++)
    printf(" %p", cont->arrays[i]);

  printf("\n");
}

int find_matrix_row(IntMatrix* container, IntArray* needle) {
  for (int i = 0; i < container->len; i++) {
    if (arrays_equal(needle, container->arrays[i]))
      return i;
  }

  return -1;
}
