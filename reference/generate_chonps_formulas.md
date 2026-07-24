# Generate a CHONPS formula library

Generates neutral molecular formulae under the configured atom, ratio,
DBE, nominal-valence, nitrogen-rule, and heteroatom constraints. Only C,
H, O, N, P, and S are represented.

## Usage

``` r
generate_chonps_formulas(config = dom_config(), mass_range = c(-Inf, Inf))
```

## Arguments

- config:

  A `dom_config`.

- mass_range:

  Optional inclusive neutral-mass range used to reduce output.

## Value

Data frame with formula, elemental counts, theoretical neutral mass, and
calculated indices.

## References

Koch BP, Dittmar T, Witt M, Kattner G (2007).
[doi:10.1021/ac061949s](https://doi.org/10.1021/ac061949s)

## Examples

``` r
cfg <- dom_config(elements = list(
  C = c(4, 10), H = c(0, 24), O = c(1, 10),
  N = c(0, 1), P = c(0, 1), S = c(0, 1)
))
library <- generate_chonps_formulas(cfg, c(100, 300))
```
