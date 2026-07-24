# Plot formula-metric distributions

Plot formula-metric distributions

## Usage

``` r
plot_formula_metrics(
  data,
  metric = "DBE",
  group = NULL,
  bins = 35,
  facet = NULL,
  theme = NULL,
  return_data = FALSE
)
```

## Arguments

- data:

  Assigned formula table.

- metric:

  One of H_C, O_C, DBE, AI_mod, or NOSC.

- group:

  Optional grouping column.

- bins:

  Histogram bins.

- facet:

  Optional faceting column.

- theme:

  ggplot2 theme.

- return_data:

  Return plot and data.

## Value

A ggplot object or list.
