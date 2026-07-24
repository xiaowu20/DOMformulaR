# Rank formula candidates

Ranking is deterministic and transparent: absolute mass error, N+P+S
count, P+S count, and formula string. It is not a probability of
identification.

## Usage

``` r
rank_formula_candidates(
  candidates,
  weights = c(mass_error = 1, nps = 0.15, ps = 0.05)
)
```

## Arguments

- candidates:

  Candidate data frame.

- weights:

  Named numeric vector for `mass_error`, `nps`, and `ps`.

## Value

Ranked candidates with `candidate_count`, `score`, and `candidate_rank`.
