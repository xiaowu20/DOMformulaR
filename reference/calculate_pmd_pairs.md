# Detect paired-mass-difference transformation candidates

PMD matches are mass-consistent edges, not observed biochemical
reactions.

## Usage

``` r
calculate_pmd_pairs(data, transformations, tolerance = 5e-04)
```

## Arguments

- data:

  Assigned formula table with `sample_id`, `mz_observed`, and
  `molecular_formula`.

- transformations:

  Data frame with `transformation_id`, `mass_difference`, and optional
  annotation columns.

- tolerance:

  Absolute mass-difference tolerance in daltons.

## Value

Candidate PMD edge table.
