# Select the best formula per peak

Select the best formula per peak

## Usage

``` r
select_best_formula(
  candidates,
  max_candidates = 50L,
  weights = c(mass_error = 1, nps = 0.15, ps = 0.05)
)
```

## Arguments

- candidates:

  Ranked or unranked candidates.

- max_candidates:

  Maximum acceptable candidate count. Peaks exceeding this limit are
  returned with `formula_status = "ambiguous_excess"`.

- weights:

  Named ranking weights passed to
  [`rank_formula_candidates()`](https://xiaowu20.github.io/DOMformulaR/reference/rank_formula_candidates.md)
  when candidates are not already ranked.

## Value

One row per candidate-bearing peak.
