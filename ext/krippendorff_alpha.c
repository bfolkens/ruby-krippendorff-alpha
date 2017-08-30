#include <stddef.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <assert.h>

bool _skip_flag(int index, int *skip_indexes, size_t skip_indexes_size)
{
  for (size_t s_i = 0; s_i < skip_indexes_size; s_i++) {
    if (skip_indexes[s_i] == index) {
      return true;
    }
  }

  return false;
}

double _metric(double c, double k)
{
  return pow(c - k, 2);
}

double _krippendorff_alpha(double *in_array, size_t n_rows, size_t n_columns, int *skip_indexes, size_t skip_indexes_size, double *unique_values, size_t unique_values_size)
{
  // Construct value-by-unit matrix
  unsigned int *vu = calloc(n_columns * unique_values_size, sizeof(unsigned int));
  assert(vu != NULL);

  unsigned int *unit_totals = calloc(n_columns, sizeof(unsigned int));
  assert(unit_totals != NULL);

  unsigned int *unique_value_totals = calloc(unique_values_size, sizeof(unsigned int));
  assert(unique_value_totals != NULL);

  // Count the number of times the value occurs for each unit, accumulating overall totals as well
  for (size_t v_i = 0; v_i < unique_values_size; v_i++) {
    for (size_t u_i = 0; u_i < n_columns; u_i++) {
      for (size_t r_i = 0; r_i < n_rows; r_i++) {
        size_t flat_i = (u_i * n_rows) + r_i;

        // Check if we match the unique value we're currently comparing against and tabulate,
        // and skip over any values marked to be skipped
        if (!_skip_flag(flat_i, skip_indexes, skip_indexes_size) &&
            in_array[flat_i] == unique_values[v_i]) {
          vu[(v_i * n_columns) + u_i] += 1;
          unit_totals[u_i] += 1;
        }
      }
    }
  }

  unsigned int total_pairable_values = 0;

  // Calculate the marginal sums, now that we know if there are any lone values
  for (size_t v_i = 0; v_i < unique_values_size; v_i++) {
    for (size_t u_i = 0; u_i < n_columns; u_i++) {
      // Skip any units with lone values
      if (unit_totals[u_i] > 1) {
        unique_value_totals[v_i] += vu[(v_i * n_columns) + u_i];
      }
    }

    total_pairable_values += unique_value_totals[v_i];
  }

  // Calculate the observed disagreement
  double d_o = 0.0;
  for (size_t u_i = 0; u_i < n_columns; u_i++) {

    double denominator = unit_totals[u_i] - 1;
    if (denominator > 0) {

      double sum_diff = 0.0;
      for (size_t c_i = 0; c_i < unique_values_size; c_i++) {
        for (size_t k_i = c_i + 1; k_i < unique_values_size; k_i++) {
          double c = unique_values[c_i];
          double k = unique_values[k_i];
          double n_uc = vu[(c_i * n_columns) + u_i];
          double n_uk = vu[(k_i * n_columns) + u_i];

          sum_diff += n_uc * n_uk * _metric(c, k);
        }
      }

      d_o += sum_diff / denominator;
    }
  }

  // Calculate the expected disagreement
  double d_e = 0.0;
  for (size_t c_i = 0; c_i < unique_values_size; c_i++) {
    for (size_t k_i = c_i + 1; k_i < unique_values_size; k_i++) {
      double c = unique_values[c_i];
      double k = unique_values[k_i];
      double dot_c = unique_value_totals[c_i];
      double dot_k = unique_value_totals[k_i];

      d_e += dot_c * dot_k * _metric(c, k);
    }
  }

  double a = 1 - (total_pairable_values - 1) * (d_o / d_e);

  free(vu);
  free(unit_totals);
  free(unique_value_totals);

  return a;
}
