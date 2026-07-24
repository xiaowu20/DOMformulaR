# Standardize peak-table columns

Standardize peak-table columns

## Usage

``` r
standardize_peak_table(data, column_map = NULL)
```

## Arguments

- data:

  A data frame.

- column_map:

  Optional named character vector mapping standard names to source
  names. Required standard names are `sample_id`, `mz`, `intensity`.

## Value

A data frame using the DOMformulaR input schema.
