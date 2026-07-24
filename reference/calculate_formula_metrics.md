# Calculate all formula-level DOM indices

Calculate all formula-level DOM indices

## Usage

``` r
calculate_formula_metrics(data)
```

## Arguments

- data:

  Formula data frame containing CHONPS atom counts.

## Value

Input data with elemental ratios, DBE, DBE/C, DBE/O, AI_mod, and NOSC.

## Examples

``` r
calculate_formula_metrics(data.frame(C = 10, H = 12, O = 5, N = 0, P = 0, S = 0))
#>    C  H O N P S H_C O_C N_C P_C S_C DBE DBE_C DBE_O    AI_mod NOSC
#> 1 10 12 5 0 0 0 1.2 0.5   0   0   0   5   0.5     1 0.3333333 -0.2
```
