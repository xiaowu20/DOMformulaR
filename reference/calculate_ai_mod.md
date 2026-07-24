# Calculate modified aromaticity index

Uses the commonly applied DOM formula expression. Values are set to zero
when the numerator is non-positive or denominator is non-positive.
Interpretation for P- and S-containing formulae requires caution.

## Usage

``` r
calculate_ai_mod(data)
```

## Arguments

- data:

  Formula data frame.

## Value

Numeric AI_mod vector.

## References

Koch BP, Dittmar T (2006).
[doi:10.1002/rcm.2386](https://doi.org/10.1002/rcm.2386)
