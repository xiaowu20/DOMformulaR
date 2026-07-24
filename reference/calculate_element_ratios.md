# Calculate elemental ratios

Calculate elemental ratios

## Usage

``` r
calculate_element_ratios(data)
```

## Arguments

- data:

  Formula data frame containing C, H, O, N, P, and S.

## Value

Input data with H/C, O/C, N/C, P/C, and S/C columns. Ratios are `NA`
when C is zero or missing.
