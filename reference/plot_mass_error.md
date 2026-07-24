# Plot mass errors

Plot mass errors

## Usage

``` r
plot_mass_error(
  data,
  distribution = FALSE,
  group = NULL,
  alpha = 0.6,
  point_size = 1.2,
  xlim = NULL,
  ylim = NULL,
  facet = NULL,
  theme = NULL,
  return_data = FALSE
)
```

## Arguments

- data:

  Assigned formula table.

- distribution:

  Draw a histogram instead of m/z versus mass error.

- group:

  Optional grouping column.

- alpha:

  Point transparency.

- point_size:

  Point size.

- xlim, ylim:

  Optional coordinate limits.

- facet:

  Optional faceting column.

- theme:

  ggplot2 theme object.

- return_data:

  Return a list with plot and plot data.

## Value

A ggplot object or list.
