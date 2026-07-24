# Calculate double-bond equivalents

Uses `DBE = 1 + C - H/2 + N/2 + P/2`. O and divalent S do not enter the
valence expression. This is a formula-level index, not a structure
count.

## Usage

``` r
calculate_dbe(data)
```

## Arguments

- data:

  Formula data frame.

## Value

Numeric DBE vector.

## References

Koch BP et al. (2007).
[doi:10.1021/ac061949s](https://doi.org/10.1021/ac061949s)
