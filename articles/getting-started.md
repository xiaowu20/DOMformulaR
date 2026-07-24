# Getting started with DOMformulaR

DOMformulaR 0.1.0 accepts CHONPS peak tables for singly charged `[M-H]-`
data. The minimum columns are `sample_id`, `mz`, and `intensity`.
Optional fields are never silently converted into evidence.

``` r

path <- system.file("extdata", "simulated_peaks.csv", package = "DOMformulaR")
peaks <- read_peak_table(path)
inspect_peak_quality(peaks)
#>          sample_id peak_count   mz_min   mz_max intensity_sum
#> sample_A  sample_A          7 211.0612 290.0258       3900000
#> sample_B  sample_B          7 211.0612 290.0257       3690000
#>          missing_signal_to_noise duplicate_rows mz_decimal_digits_warning
#> sample_A                       0              0                      TRUE
#> sample_B                       0              0                      TRUE
```

``` r

cfg <- read_dom_config(
  system.file("extdata", "example_config.yml", package = "DOMformulaR")
)
result <- run_dom_workflow(path, config = cfg)
result
#> <dom_result>
#>   Cleaned peaks: 14 
#>   Assigned formulae: 12 
#>   Samples: 2
```
