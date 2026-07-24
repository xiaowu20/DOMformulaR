# Create a CHONPS workflow configuration

Returns a parameter list for negative-ion formula assignment. Version
0.1.0 supports only C, H, O, N, P, and S and only singly charged
`[M-H]-`.

## Usage

``` r
dom_config(
  mass_error_ppm = 0.75,
  elements = list(C = c(4L, 50L), H = c(0L, 120L), O = c(1L, 57L), N = c(0L, 5L), P =
    c(0L, 1L), S = c(0L, 3L)),
  ratios = list(H_C = c(0.3, 2.25), O_C = c(0, 1.15), N_C = c(0, Inf), P_C = c(0, Inf),
    S_C = c(0, Inf)),
  min_dbe = 0,
  dbe_o_range = c(-10, 10),
  max_nps = 2L,
  max_candidates = 50L,
  ion_type = "[M-H]-",
  require_integer_dbe = TRUE,
  senior_rules = TRUE,
  nitrogen_rule = TRUE,
  ranking_weights = c(mass_error = 1, nps = 0.15, ps = 0.05)
)
```

## Arguments

- mass_error_ppm:

  Absolute mass-error tolerance in parts per million.

- elements:

  Named list of inclusive integer ranges for C, H, O, N, P, S.

- ratios:

  Named list of inclusive ratio ranges.

- min_dbe:

  Minimum double-bond equivalent.

- dbe_o_range:

  Inclusive range for DBE minus O.

- max_nps:

  Maximum allowed sum of N, P, and S atoms.

- max_candidates:

  Maximum candidates retained per peak after ranking.

- ion_type:

  Ion model. Only `[M-H]-` is supported.

- require_integer_dbe:

  Require integer DBE values.

- senior_rules:

  Apply a conservative nominal-valence Senior-rule screen.

- nitrogen_rule:

  Apply the nominal-mass parity rule using N.

- ranking_weights:

  Named weights for mass error, N+P+S, and P+S.

## Value

A `dom_config` list.

## Examples

``` r
cfg <- dom_config(mass_error_ppm = 0.75)
```
