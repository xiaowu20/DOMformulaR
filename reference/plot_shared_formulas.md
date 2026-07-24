# Plot shared formula occurrence

Uses an occurrence-frequency bar chart that remains readable for many
samples. It does not default to a Venn diagram.

## Usage

``` r
plot_shared_formulas(data, min_samples = 1L, theme = NULL, return_data = FALSE)
```

## Arguments

- data:

  Assigned formula table.

- min_samples:

  Minimum occurrence count.

- theme:

  ggplot2 theme.

- return_data:

  Return plot and data.

## Value

A ggplot object or list.
