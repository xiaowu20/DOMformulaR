# Plot sample composition

Plot sample composition

## Usage

``` r
plot_sample_composition(
  data,
  weight = c("count", "intensity"),
  position = "stack",
  theme = NULL,
  return_data = FALSE
)
```

## Arguments

- data:

  Assigned formula table.

- weight:

  `count` or `intensity`.

- position:

  Bar position.

- theme:

  ggplot2 theme.

- return_data:

  Return plot and summarized data.

## Value

A ggplot object or list.
