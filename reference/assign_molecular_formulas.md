# Assign CHONPS molecular formula candidates

Uses calibrated m/z when `mz_corrected` is available; otherwise uses
`mz`. The supported ion model is singly charged negative-ion `[M-H]-`.
All candidates are retained before ranking.

## Usage

``` r
assign_molecular_formulas(peaks, config = dom_config(), return_all = TRUE)
```

## Arguments

- peaks:

  Standardized peak table.

- config:

  A `dom_config`.

- return_all:

  Return both selected assignments and all candidates.

## Value

A list with `assigned` and `candidates`, or assigned data frame.

## References

Fu Q-L, Fujii M, Riedel T (2020).
[doi:10.1016/j.aca.2020.05.048](https://doi.org/10.1016/j.aca.2020.05.048)
; Fu Q-L, Fujii M, Ma R (2023).
[doi:10.1021/acs.analchem.2c04113](https://doi.org/10.1021/acs.analchem.2c04113)
; Kujawinski EB, Behn MD (2006).
[doi:10.1021/ac0600306](https://doi.org/10.1021/ac0600306) ; Koch BP et
al. (2007). [doi:10.1021/ac061949s](https://doi.org/10.1021/ac061949s)
