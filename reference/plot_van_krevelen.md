# Plot a van Krevelen diagram

Plot a van Krevelen diagram

## Usage

``` r
plot_van_krevelen(
  data,
  group = "element_class",
  intensity_weighted = FALSE,
  alpha = 0.6,
  point_size = 1.3,
  xlim = c(0, 1.2),
  ylim = c(0.3, 2.25),
  facet = NULL,
  theme = NULL,
  return_data = FALSE
)
```

## Arguments

- data:

  Formula table.

- group:

  Grouping column, default `element_class`.

- intensity_weighted:

  Scale points by intensity.

- alpha:

  Point transparency.

- point_size:

  Base point size.

- xlim, ylim:

  Coordinate limits.

- facet:

  Optional faceting column.

- theme:

  ggplot2 theme.

- return_data:

  Return plot and data.

## Value

A ggplot object or list.
