# Validate a standardized peak table

Validation errors stop processing. Duplicate rows and unsorted m/z
values produce warnings because they can be handled downstream.

## Usage

``` r
validate_peak_table(data)
```

## Arguments

- data:

  Standardized peak table.

## Value

The input data, invisibly.
