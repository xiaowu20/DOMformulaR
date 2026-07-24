# Run a complete CHONPS DOM workflow

Reads or standardizes data, validates and filters peaks, assigns CHONPS
candidates, calculates indices and summaries, constructs ggplot objects,
and optionally exports reproducibility artifacts.

## Usage

``` r
run_dom_workflow(
  input,
  config = dom_config(),
  column_map = NULL,
  min_signal_to_noise = 6,
  min_intensity = NULL,
  mz_range = c(-Inf, Inf),
  blank_samples = NULL,
  replicate_min_fraction = NULL,
  output_dir = NULL
)
```

## Arguments

- input:

  File path or data frame.

- config:

  A `dom_config` or YAML path.

- column_map:

  Optional vendor-to-standard column mapping.

- min_signal_to_noise:

  Optional S/N threshold.

- min_intensity:

  Optional intensity threshold.

- mz_range:

  Inclusive m/z range.

- blank_samples:

  Optional blank sample IDs.

- replicate_min_fraction:

  Optional replicate occurrence fraction.

- output_dir:

  Optional export directory.

## Value

A `dom_result` S3 object.

## References

Fu Q-L, Fujii M, Riedel T (2020).
[doi:10.1016/j.aca.2020.05.048](https://doi.org/10.1016/j.aca.2020.05.048)
; Fu Q-L, Fujii M, Ma R (2023).
[doi:10.1021/acs.analchem.2c04113](https://doi.org/10.1021/acs.analchem.2c04113)

## Examples

``` r
path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
result <- run_dom_workflow(path, config = dom_config(
  elements = list(
    C = c(4, 20), H = c(0, 45), O = c(1, 20),
    N = c(0, 2), P = c(0, 1), S = c(0, 1)
  )
))
result
#> <dom_result>
#>   Cleaned peaks: 14 
#>   Assigned formulae: 10 
#>   Samples: 2 
```
