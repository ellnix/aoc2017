#include "int_list.h"

int_array_t *read_int_arr(int day) {
  int_array_t *output =
      (int_array_t *)malloc((sizeof(int_array_t) + 10) * sizeof(int));
  output->len = 0;
  output->cap = 10;

  char *filename = malloc(sizeof(char) * 20);
  sprintf(filename, "inputs/%d", day);
  FILE *input_file = fopen(filename, "r");

  int n;

  while (fscanf(input_file, "%d", &n) != EOF) {
    if (output->len >= output->cap) {
      output = (int_array_t *)realloc(
          output, (output->len + 10 + sizeof(int_array_t)) * sizeof(int));
      output->cap += 10;
    }

    output->items[output->len] = n;

    output->len++;
  }

  fclose(input_file);

  return output;
}

void print_int_arr(int_array_t *arr) {
  printf("Len: %d, cap: %d.\n", arr->len, arr->cap);
  printf("Elements: ");
  for (int i = 0; i < arr->len; i++)
    printf(" %d", arr->items[i]);

  printf("\n");
}

